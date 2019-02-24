# dotfiles

<!-- MarkdownTOC autolink="true" -->

- [What is this, Chosto ?](#what-is-this-chosto-)
- [Contents](#contents)
- [Requirements](#requirements)
- [Usage](#usage)
    - [Bare repository trick](#bare-repository-trick)
    - [Divergence betwteen laptop and desktop](#divergence-betwteen-laptop-and-desktop)
    - [Configuration outside XDG_CONFIG_HOME, e.g. /etc](#configuration-outside-xdg_config_home-eg-etc)

<!-- /MarkdownTOC -->

## What is this, Chosto ? 

I used a lot Debian/Ubuntu with Gnome. So a full Desktop Manager with a stacking Windows Manager.
A friend of mine showed me i3, a great and customizable tiling Windows Manager (i.e. no windows stack, just divide the scren and take all empty space).

With some customization and additionnal component (in this repo), I managed to get a functional and pleasant yet lightweight environment (for me, no brag).

So basically, what I like about this setup is that there is no "useless" menu bar anywhere and no border. Just windows with gaps between them when multiple windows are on the same screen, and keybord shortcuts for productivity.

I added to the classic Arch/i3 :
* A notification daemon (urgency-aware), Dunst, controlled by shortcuts (but possibly with mouse).
* A fancy lock screen, with optionnal suspend-to-RAM, either triggered by hotkey or when there is no activity for X minutes.
* A Display Manager (LightDM), for login and X starting.
* A great File Explorer (SpaceFM), with hotkey / command-line / screen-split / protocol handlers / events support.
* ZSH with Oh My ZSH and excellent community plugins (Git aliases, Docker autocomplete, FASD bindings, cat and man coloration...) 
* Some mappings to control ALSA volume from dedicated keyboards buttons, to play/plause players compatible with MPRIS D-Bus Interface spec ; some changes to key speed (X settings) ; Smooth and dark theme for GTK and for Sublime-Text...

## Contents

Setup for :

* [i3](http://i3wm.org/), a great tiling windows manager
  * In fact i3-gaps, to add margins between windows
  * And i3-lock-color, an improved lock screen
* [LightDM](https://wiki.ubuntu.com/LightDM) with custom GTKTheme and background
* Sublime Text 3
* [Polybar](https://github.com/jaagr/polybar/), a great replacement for i3-bar with easy custom plugins
* Terminator
* ZSH with Oh My ZSH!
* [Dunst](https://github.com/dunst-project/dunst), a great and lightweight notification daemon
* [Rofi](https://github.com/DaveDavenport/rofi), a full-customizable app launcher/windows 
switcher
* Sound setup (total beginner there btw) :
  * JACK, a sound server, without PA support ;
  * PianoTeq, a virtual synth ;
  * Cadence and Claudia, JACK and LADISH front-ends ;
  * Non-Mixer, a mixer.
  * Ardour, a DAW.
* Random things (GTK3+ theme, Redshift, taskwarrior...)

Here is a screenshot of the rendition i3/polybar with this setup (and yeah, I use nano, sorry to disappoint)
![Screenshot of i3/polybar](https://pic.chosty.fr/uploads/big/22c75dc7901223204e0e9c798506b435.png)

## Requirements 

Configuration makes use of these things, just to record but not exhaustive :

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [fasd](https://github.com/clvv/fasd)
* [Pygments](http://pygments.org/) (with `pygmentize` command)
* [Powerline Fonts](https://github.com/powerline/fonts)
* `sudo pip install --upgrade google-api-python-client` 
* [SpaceFM](https://ignorantguru.github.io/spacefm/)
* [PlayerCTL](https://github.com/acrisci/playerctl)
* [GTK Arc Theme](https://github.com/horst3180/arc-theme)
* Fonts : Noto Sans, Noto Emoji, DejaVu Sans, MaterialIcons, Symbola
* xdotool, xsel
* gnupg
* maim, for screenshot

\#todo automatic installation of dependencies

## Usage

Please note : on my system `XDG_CONFIG_HOME` is empty and default to `$HOME/.config`. 

### Bare repository trick

* Clone in bare repository : `git clone --bare https://github.com/Chostakovitch/dotfiles.git $HOME/.cfg`. A bare repository does not have a working tree (basically it is just `.git` content). So we avoid conflicts with another git repository.
* Create a working tree outside `.cfg` : `git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`.
* Adjust `DEFAUT_USER` in `~/.zshrc`.
* Adjust other environment variables, such as `SCREENSHOT_PATH`.
* Source `~/.zshrc` and use provided `config` alias to pull.
* `config config --local status.showUntrackedFiles no` to ignore untracked files in status (better as it is home dir).

Credits to [this great article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) for the trick.

### Divergence betwteen laptop and desktop 

As desktop machine and laptop don't have configuration conflicts (e.g. laptop uses PulseAudio and desktop uses ALSA/Jack), some files have `.desk` extension and others `.laptop`. Configuration files that works on both systems have no extension.

Launch `~/.init_config.sh` to create symlinks (e.g. `~/.config/i3/config` will be symlinked to `~/.config/i3/config.laptop` if I launch `~/.init_config.sh laptop`).

### Configuration outside XDG_CONFIG_HOME, e.g. /etc

Some configuration files reside in `/etc` directory, but I want to keep track of them.

Just create a folder in `XDG_CONFIG_HOME` and a file named `dest`. In this file, write the destination path. Then, copy the configuration files that you want to track and add them to the repository. You can also use `.desk` and `.laptop` extensions for specific configuration.

The `~/.init_config.sh` script will copy relevant files (laptop or desktop) in the directory specified by `dest` file. Now you just modify the files tracked by Git and run `~/.init_config.sh`.

Example : see `~/.config/lightdm` directory.

Note this is a quick and quite dirty solution.