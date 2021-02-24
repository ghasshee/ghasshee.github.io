
YAOURT='yaourt -S --noconfirm'
PACMAN='pacman -S --noconfirm'
SPACMAN='sudo pacman -S --noconfirm'

make_user(){
    useradd -m -g wheel $USERNAME
    $PACMAN sudo
    visudo
    ## decomment Defaults env_keep += "HOME"
    ## decomment %wheel ALL=(ALL) all
    passwd $USERNAME
    su $USERNAME
}


install_gui(){
    ## yaourt
    echo "[archlinuxfr]" >> /etc/pacman.conf
    echo "SigLevel = Never" >> /etc/pacman.conf
    echo 'Server = http://repo.archlinux.fr/$arch' >> /etc/pacman.conf
    pacman -Sy --noconfirm yaourt
    ## X
    $PACMAN xorg-server xorg-server-utils xorg-xinit xorg-xclock xterm
    ## xfce4
    $PACMAN xfce4 xfce4-goodies gamin
    ## Graphic Driver
    lspci | grep VGA
    $PACMAN xf86-video-intel     ## find driver with $ sudo pacman -Ss xf86-video
    ## slim
    $PACMAN slim archlinux-themes-slim slim-themes
    echo 'login_cmd exec /usr/bin/zsh -l ~/.xinitrc %session' >> /etc/slim.conf
    echo 'daemon yes' >> /etc/slim.conf
    echo 'current_theme archlinux-simplyblack' >> /etc/slim.conf
    systemctl enable slim.service
}
install_base(){
    $YAOURT ttf-ricty
    $YAOURT ttf-mona
    $YAOURT otf-takao
    $YAOURT otf-ipaexfont     ## Fonts
    $YAOURT numix-themes
    $YAOURT menda-circle-icon-theme-git          ## theme & icon
    $SPACMAN fcitx-im fcitx-anthy fcitx-configtool         ## Japanese
    $SPACMAN alsa-utils && sudo alsactl store             ## Sound
    $SPACMAN xf86-input-synaptics xf86-input-mouse        ## Mouse Driver
    $SPACMAN ibus ibus-anthy                              ## input text
}

dotfiles(){
    if ! [[ -d "$HOME/ghasshee" ]] ; then
        mkdir $HOME/ghasshee
    fi
    cd $HOME/ghasshee
    git clone https://www.github.com/ghassheee/dotfiles && cd dotfiles
    chmod 777 *
    chmod 777 .*
    ./make_links.zsh
}

xinitrc(){
    echo 'xcalib -a -blue 2 10 5 -green 1 10 70' > $HOME/.xinitrc
    echo "export GTK_IM_MODULE=fcitx" >> $HOME/.xinitrc
    echo "export QT_IM_MODULE=fcitx" >> $HOME/.xinitrc
    echo "export XMODIFIERS="@imi-fcitx"" >> $HOME/.xinitrc
    echo "exec startxfce4" >> $HOME/.xinitrc
}

install_etc(){
    ## Dropbox with Thunar
    $YAOURT thunar-dropbox dropbox
    ## xcalib
    $YAOURT xcalib
    ## etc
    $YAOURT chromium
    $YAOURT vivaldi
    $YAOURT okular
    $YAOURT ffmpeg
    $SPACMAN atom
    $YAOURT vlc
    $YAOURT python-pip
    ## opam
    $YAOURT opam
    ## multirust
    curl -sf https://raw.githubusercontent.com/brson/multirust/master/quick-install.sh | sh
}






make_ghasshee(){
    USERNAME=ghasshee
    make_user
}

installation(){
    install_base
    dotfiles
    install_etc
}
