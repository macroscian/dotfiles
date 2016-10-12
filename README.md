# dotfiles
Some configuration files I use on the cluster and workstations
I tend to 'install' them using [this procedure](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)

Also, some notes on the new system:

## Installing emacs
```
module load libX11
module load ncurses
./configure --prefix=$HOME/emacs --bindir=$HOME/bin \
--with-x-toolkit=no --with-xpm=no --with-jpeg=no --with-png=no --with-gif=no --with-tiff=no
make
make install
```
## Mounting directory on windows via vpn
You need to type `thecrick\username` in the windows connection

