# dotfiles

### Contents

Simple setup for i3, terminator, zsh with oh-my-zsh and a fancy [polybar](https://github.com/jaagr/polybar), screenshot to come.

### Requirements 

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [fasd](https://github.com/clvv/fasd)
* [Pygments](http://pygments.org/) (with `pygmentize` command)
* [Powerline Fonts](https://github.com/powerline/fonts)

### Usage

* Clone in bare repository : `git clone --bare https://github.com/Chostakovitch/dotfiles.git $HOME/.cfg`. A bare repository does not have a working tree (basically it is just `.git` content). So we avoid conflicts with another git repository.
* Create a working tree outside `.cfg` : `/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout`.
* Adjust `DEFAUT_USER` in `~/.zshrc`.
* Source `~/.zshrc` and use provided `config` alias to pull.
* `config config --local status.showUntrackedFiles no` to ignore untracked files in status (better as it is home dir).

Credits to [this great article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/) for the trick.
