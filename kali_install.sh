#!/bin/bash

cur=/home/kali/.dotfiles
home_kali=/home/kali

if [[ -e $home_kali/current_stage ]]
then
    stage=$(cat $home_kali/current_stage)
else
    stage=0
fi

if [[ $stage == 0 ]]
then
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y mate-desktop-environment i3
    chsh -s /usr/bin/bash
    sudo chsh -s /usr/bin/bash
    ssh-keygen -t rsa -b 4096 -C "kali@kali.local" -f $home_kali/.ssh/id_rsa -q -N ""
    ssh-add $home_kali/.ssh/id_rsa
    sudo visudo -c -q -f $cur/sudoers && sudo cp $cur/sudoers /etc/sudoers && sudo chown root:root /etc/sudoers && sudo chmod 440 /etc/sudoers
    echo -n 1 > $home_kali/current_stage
    echo "Stage 0 done, reboot and don't forget to login with MATE"
fi

if [[ $stage == 1 ]]
then
    mkdir -p $home_kali/.config/i3
    mkdir -p $home_kali/.config/i3status
    rm $home_kali/.config/i3/config
    ln $cur/i3_config $home_kali/.config/i3/config
    rm $home_kali/.config/i3status/config
    ln $cur/i3status_config $home_kali/.config/i3status/config
    gsettings set org.mate.session.required-components windowmanager "'i3'"
    gsettings set org.mate.session required-components-list "['windowmanager']"
    gsettings set org.mate.interface gtk-decoration-layout ""
    rm $home_kali/.vimrc
    ln $cur/.vimrc $home_kali/.vimrc
    git clone https://github.com/VundleVim/Vundle.vim.git $home_kali/.vim/bundle/Vundle.vim
    rm $home_kali/.tmux.conf
    ln $cur/.tmux.conf $home_kali/.tmux.conf
    git clone https://github.com/tmux-plugins/tpm $home_kali/.tmux/plugins/tpm
    git clone https://github.com/jimeh/tmux-themepack.git $home_kali/.tmux-themepack
    mv $home_kali/.bashrc $home_kali/.bashrc_bkp
    ln $cur/.bashrc $home_kali/.bashrc
    rm $home_kali/.profile
    ln $cur/.profile $home_kali/.profile
    cp $cur/parrot.jpg $home_kali/Pictures/parrot.jpg
    rm $home_kali/.bash_aliases
    ln $cur/.bash_aliases $home_kali/.bash_aliases
    rm $home_kali/.inputrc
    ln $cur/.inputrc $home_kali/.inputrc
    
    sudo apt -y install py3status fonts-powerline rlwrap ncat mingw-w64 python3-pyftpdlib feh python3-pip python3-venv copyq nemo xclip ranger jq netexec dconf-cli dconf-editor mate-control-center
    vim +PluginInstall +qall
    sudo pip3 install --upgrade pwntools
    wget -O ~/.gdbinit-gef.py -q http://gef.blah.cat/py
    echo source ~/.gdbinit-gef.py >> ~/.gdbinit

    touch $home_kali/.hushlogin
    
    git config --global submodule.recurse true
    git clone --recurse-submodules --template $cur/git-hooks_tools https://github.com/arty-hlr/Tools.git $home_kali/Documents/Tools
    rm $home_kali/Documents/Tools/.git/hooks/*
    ln $cur/git-hooks_tools/hooks/post-merge $home_kali/Documents/Tools/.git/hooks/post-merge
    git -C $home_kali/Documents/Tools hook run post-merge
    $cur/tools_bin_link.sh

    sudo apt -y install $cur/parrot-themes_3.2+parrot3_all.deb
    sudo apt -y autoremove

    dconf load /org/mate/terminal/ < $cur/mate-terminal-profile.bckp

    ln $cur/mount-shares.sh $home_kali/mount-shares.sh
    
    echo "Reboot now"
    echo -n 2 > $home_kali/current_stage
fi

if [[ $stage == 2 ]]
then
    echo "launch tmux"
    echo "tmux source ~/.tmux.conf"
    echo "C-b I in tmux"
    echo "run copyq and enable autostart"
    echo "change the mate theme to icy-dark with mate-appearance-properties"
    echo "install foxyproxy and import settings"
    echo "launch copyq, setup autostart, vi mode"
    echo "Done?"
    read a
    rm $home_kali/current_stage
    echo "Finished! Enjoy your VM :)"
fi
