#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
#
# Original created by Michael J Samlley:
# https://github.com/michaeljsmalley/dotfiles/blob/master/makesymlinks.sh 
#
# Potential issue in that if this is run twice with no dotfiles in directory, files will be 
# deleted.
############################

########## Variables

dir=~/dotfiles                    # dotfiles directory
olddir=~/dotfiles_old             # old dotfiles backup directory
files="vimrc zshrc Xresources i3 i3status.conf mpdconf ncmpcpp vim oh-my-zsh config/dunstrc"    # list of files/folders to symlink in homedir

##########

#If we're doing this for the first time then copy the relevant dotfiles in and then carry on
if [ ${1:-0} = "--install" ]; then
    echo "Copying existing dotfiles defined in the script into the dotfile dir"
    for file in $files; do
        if [ -e ~/.$file ]; then
            echo -n "Copying $file to $dir"
            cp -r ~/.$file ~/dotfiles/$file
        fi
    done
fi

# create dotfiles_old in homedir
echo  "Creating $olddir for backup of any existing dotfiles in ~ ... "
mkdir -p $olddir

# change to the dotfiles directory
echo  "Changing to the $dir directory ... "
cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
echo "Moving any existing dotfiles from ~ to $olddir"

for file in $files; do
    if [ -e ~/.$file ]; then
        mv ~/.$file ~/dotfiles_old/
    fi
done

echo "Creating symlink to files in home directory."

for file in $files; do
    if [ ! -e ~/.$file ]; then
        ln -s $dir/$file ~/.$file
    fi
done

function install_zsh {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $dir/oh-my-zsh/ ]]; then
        git clone http://github.com/bitdivision/oh-my-zsh.git
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh
        install_zsh
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh

