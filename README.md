# dotfiles

### Contents
Setup for :
* [i3](http://i3wm.org/), a great tiling windows manager
  * In fact i3-gaps, to add padding between windows
  * And i3-lock-color, an improved lock screen
* [LightDM](https://wiki.ubuntu.com/LightDM) with custom GTKTheme and background
* Sublime Text 3
* [Polybar](https://github.com/jaagr/polybar/), a great replacement for i3-bar with easy custom plugins
* Terminator
* ZSH with Oh My ZSH!
* [Dunst](https://github.com/dunst-project/dunst), a great and lightweight notification daemon
* Random things (GTK3+ theme, Redshift, taskwarrior...)

### Requirements 

Configuration makes use of these things, just to record but not mandatory :

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [fasd](https://github.com/clvv/fasd)
* [Pygments](http://pygments.org/) (with `pygmentize` command)
* [Powerline Fonts](https://github.com/powerline/fonts)
* `sudo pip install --upgrade google-api-python-client` 
* [SpaceFM](https://ignorantguru.github.io/spacefm/)
* [PlayerCTL](https://github.com/acrisci/playerctl)
* [GTK Arc Theme](https://github.com/horst3180/arc-theme)
* Fonts : Noto Sans, DejaVu Sans, MaterialIcons, Symbola

### What is this, Chosto ? 

I used a lot Debian/Ubuntu with Gnome. So a full Desktop Manager with a stacking Windows Manager.
A friend of mine showed me i3, a great and customizable tiling Windows Manager (i.e. no windows stack, just divide the scren and take all empty space).

With some customization and additionnal component (in this repo), I managed to get a functional and pleasant yet lightweight environment (for me, no brag).

So basically, what I like about this setup is that there is no "useless" menu bar anywhere and no border. Just windows with gaps between them when multiple windows are on the same screen, and keybord shortcuts for productivity.

I added to the classic Arch/i3WM :
* A notification daemon (urgency-aware), Dunst, controlled by shortcuts (but possibly with mouse).
* A fancy lock screen, with optionnal suspend-to-RAM, either triggered by hotkey or when there is no activity for X minutes.
* A Display Manager (LightDM), for login and X starting.
* A great File Explorer (SpaceFM), with hotkey / command-line / screen-split / protocol handlers / events support.
* ZSH with Oh My ZSH and excellent community plugins (Git aliases, Docker autocomplete, FASD bindings, cat and man coloration...) 
* Some mappings to control ALSA volume from dedicated keyboards buttons, to play/plause players compatible with MPRIS D-Bus Interface spec ; some changes to key speed (X settings) ; Smooth and dark theme for GTK and for Sublime-Text...

### Usage

Please note : on my system XDG_CONFIG_HOME is $HOME/.config. 

* Clone in bare repository : `git clone --bare https://github.com/Chostakovitch/dotfiles.git $HOME/.cfg`. A bare repository does not have a working tree (basically it is just `.git` content). So we avoid conflicts with another git repository.
* Create a working tree outside `.cfg` : `/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`.
* Adjust `DEFAUT_USER` in `~/.zshrc`.
* Source `~/.zshrc` and use provided `config` alias to pull.
* `config config --local status.showUntrackedFiles no` to ignore untracked files in status (better as it is home dir).

Credits to [this great article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) for the trick.
