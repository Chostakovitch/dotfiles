#!/usr/bin/python

import sys
import getopt
import subprocess
import pathlib
import time
import os

def usage(path):
	print('A tiny wrapper around maim to take screenshots and save or upload them (+ copy link in clipboard).\n')
	print('Usage:')
	print('\t' + sys.argv[0] + ' <--upload|--save> [--path=<save_path>]')
	print('\t' + sys.argv[0] + ' --help')
	print('\nOptions:')
	print('\t-h --help \tShow this screen.')
	print('\t-u --upload \tUpload to Lychee.')
	print('\t-s --save\tSave locally.')
	print('\t-p --path\tPath where to save locally [default: ' + path +'].')

def screenshot(img_format):
	proc = subprocess.run(['maim', '-sl', '--color=0.6,0.4,0.2,0.2', '-f', img_format, '-u', '-m', '9', '-b', '5'], capture_output=True, check=True)
	return proc.stdout

def save_img(path, img, img_format):
	# Create directory if needed
	pathlib.Path(path).mkdir(parents=True, exist_ok=True)

	# Get date formatted with second granularity
	date = time.strftime("%Y-%m-%d_%H:%M:%S")

	# Write image to appropriate file.
	# We get binary from maim, so open in binary mode
	filepath = os.path.join(path, date + '.' + img_format)
	print(filepath)
	with open(filepath, 'wb') as f:
		f.write(img)
	
def main(argv):
	path = '~/img/screenshots'

	try:
		opts, _ = getopt.getopt(argv, "husp:", ["help","upload","save","path="])
	except getopt.GetoptError:
		usage(path)

	upload = False
	save = False
	img_format = 'png'

	for opt, arg in opts:
		if opt in ('-h', '--help'):
			usage()
		elif opt in ('-u', '--upload'):
			upload = True
		elif opt in ('-s', '--save'):
			save = True
		elif opt in ('-p', '--path'):
			path = opt

	# Expand path if there is a ~ inside
	path = os.path.expanduser(path)
	
	# If we upload the file, set format to jpg, even if we save the screenshot after
	if upload:
		img_format = 'jpg'

	if upload or save:
		try:
			img = screenshot(img_format)
			if save:
				save_img(path, img, img_format)
		except subprocess.CalledProcessError as e:
			print("Screenshot taking has failed {0}".format(e))
		except Exception as e:
			print("Unknown error : {0}".format(e))

if __name__ == "__main__":
   main(sys.argv[1:])