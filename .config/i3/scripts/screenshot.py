#!/usr/bin/python

import sys
import getopt
import subprocess
import pathlib
import time
import os
import requests
import uuid
import json
import pyperclip
from config import SCREENSHOT_CONFIG

def usage(path):
    print('A tiny wrapper around maim to take screenshots and save or upload them (+ copy link in clipboard).\n')
    print('The default behaviour is : nothing.')
    print('Usage:')
    print('\t' + sys.argv[0] + ' [--upload] [--save] [--path=<save_path>]')
    print('\t' + sys.argv[0] + ' --help')
    print('\nOptions:')
    print('\t-h --help \tShow this screen.')
    print('\t-u --upload \tUpload to server and copy link to clipboard.')
    print('\t\t\tOnly Lychee Laravel server is supported for now.')
    print('\t-s --save\tSave locally.')
    print('\t-p --path\tPath where to save locally [default: ' + path +'].')

def read_args(argv):
    path = SCREENSHOT_CONFIG['default_path']

    try:
        opts, _ = getopt.getopt(argv, "husp:", ["help", "upload", "save", "path="])
    except getopt.GetoptError:
        usage(path)

    upload = False
    save = False

    for opt, _ in opts:
        if opt in ('-h', '--help'):
            usage(path)
        elif opt in ('-u', '--upload'):
            upload = True
        elif opt in ('-s', '--save'):
            save = True
        elif opt in ('-p', '--path'):
            path = opt

    # Expand path if there is a ~ inside
    path = os.path.expanduser(path)

    return (upload, save, path)

def screenshot(img_format):
    output = '/tmp/screenshot'
    proc = subprocess.run(['maim', '-sl', '--color=0.6,0.4,0.2,0.2', '-f', img_format, '-u', '-m', '9', '-b', '5', output], check=True)
    with open(output, 'rb') as f:
        return f.read()

def save_img(path, img, img_format):
    # Create directory if needed
    pathlib.Path(path).mkdir(parents=True, exist_ok=True)

    # Get date formatted with second granularity
    date = time.strftime("%Y-%m-%d_%H-%M-%S")

    # Write image to appropriate file.
    # We get binary from maim, so open in binary mode
    filepath = os.path.join(path, date + '.' + img_format)
    with open(filepath, 'wb') as f:
        f.write(img)

    return filepath

def login():
    auth = {'user': SCREENSHOT_CONFIG['user'], 'password': SCREENSHOT_CONFIG['password']}

    # Get initial cookies
    s = requests.Session()
    r = s.get(SCREENSHOT_CONFIG['base_url'])

    # Set the CSRF token for the whole session
    # Also replace the ending %3D (=), they stop header from being valid (why ?)
    s.headers.update({'X-XSRF-TOKEN': r.cookies['XSRF-TOKEN'].replace('%3D', '')})

    r = s.post(SCREENSHOT_CONFIG['base_url'] + '/api/Session::login', data=auth)

    if r.status_code != 200:
        raise RuntimeError("Cannot login to Lychee!")

    return s

def get_album_id(session, name):
    r = session.post(SCREENSHOT_CONFIG['base_url'] + '/api/Albums::get')
    if r.headers['content-type'] != 'application/json':
        raise RuntimeError("API call didn't return a JSON object!")

    albums = r.json()
    for album in albums['albums']:
        if album['title'] == name:
            return album['id']
    raise RuntimeError("No album " + name + " found!")

def upload_image(session, album_id, binary_img, img_format):
    img_mime = 'image/'
    if img_format == 'jpg':
        img_mime += 'jpeg'
    elif img_format == 'png':
        img_mime += 'png'
    else:
        raise ValueError("Invalid image format {0}!".format(img_format))
    data = {'albumID': album_id}
    files = {'0': (str(uuid.uuid4()) + "." + img_format, binary_img, img_mime)}
    r = requests.Request('POST', SCREENSHOT_CONFIG['base_url'] + '/api/Photo::add', data=data, files=files)
    dump = session.prepare_request(r)
    r = session.post(SCREENSHOT_CONFIG['base_url'] + '/api/Photo::add', data=data, files=files)
    print(r.text)
    if "Error" in r.text:
        raise RuntimeError("Unknown error while uploading picture")

    return r.text

def get_image_direct_link(session, album_id, image_id):
    data = {'albumID': album_id, 'photoID': image_id}
    r = session.post(SCREENSHOT_CONFIG['base_url'] + "/api/Photo::get", data=data)
    if r.text == "false":
        raise ValueError("Image does not exist")
    if r.headers['content-type'] != 'application/json':
        raise RuntimeError("API call didn't return a JSON object")

    image_info = r.json()
    return SCREENSHOT_CONFIG['base_url'] + '/' + image_info['url']

def main(argv):
    upload, save, path = read_args(argv)

    # If we upload the file, set format to jpg, even if we save the screenshot after
    img_format = SCREENSHOT_CONFIG['upload_format'] if upload else SCREENSHOT_CONFIG['save_format']

    if upload or save:
        try:
            img = screenshot(img_format)
            if save:
                final_path = save_img(path, img, img_format)
                pyperclip.copy(final_path)
                subprocess.run(['notify-send', '-u', 'low', '-i', 'Info', '-a', 'Screenchost', 'Screenshot taken', 'Path copied to clipboard!'])
            if upload:
                s = login()
                album_id = get_album_id(s, SCREENSHOT_CONFIG['album_name'])
                image_id = upload_image(s, album_id, img, img_format)
                image_link = get_image_direct_link(s, album_id, image_id)
                pyperclip.copy(image_link)
                subprocess.run(['notify-send', '-u', 'low', '-i', 'Info', '-a', 'Screenchost', 'Screenshot uploaded', 'Link copied to clipboard!'])
        except subprocess.CalledProcessError as e:
            print("Screenshot taking has failed {0}".format(e))

if __name__ == "__main__":
    main(sys.argv[1:])
