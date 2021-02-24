DISK="sdxxx"
HOSTNAME="ghasshee"

pre(){
    wifi-menu       ## connect to internet
    lsblk           ## see your deviece
}
partitioning(){
gdisk /dev/${DISK} <<EOF
o
y
n
1

+1M
ef02
n
2

+8G
8200
n
3


8300
w
y
EOF
lsblk
}
build_fs(){

    echo "###### Determine File System ######"
    mkfs.ext2 /dev/${DISK}1
    mkfs.btrfs /dev/${DISK}3
    mkswap /dev/${DISK}2 && swapon /dev/${DISK}2

    echo "###### Mount Partitions #######"
    mount /dev/${DISK}3 /mnt
    ## if (using GRUB)  Do not mount /dev/${DISK}1 !!!

    echo "###### Install Base ######"
    pacstrap /mnt base base-devel

    echo "###### Generate FSTAB ######"
    genfstab -p /mnt >> /mnt/etc/fstab

    echo "###### chroot ######"
    arch-chroot /mnt /bin/bash
}

# update_hwclock(){ timedatectl }
# choose_mirror(){ vim /etc/pacman.d/mirrolist }

settings(){
    # Locale
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
    # Language
    echo LANG=en_US.UTF-8 > /etc/locale.conf && export LANG=en_US.UTF-8
    # Time
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
    hwclock --systohc --utc
    # Host
    echo "# /etc/hosts: static lookup table for host names" > /etc/hosts
    echo "#<ip-address> <hostname .domain.org=""> <hostname>" >> /etc/hosts
    echo "127.0.0.1 localhost.localdomain localhost $HOSTNAME" >> /etc/hosts
    echo "::1  localhost.localdomain localhost $HOSTNAME" >> /etc/hosts
    echo $HOSTNAME > /etc/hostname
}
installation(){
    echo "##### Install Tools #####"
    pacman -S --noconfirm vim zsh curl wget git tmux openssl xsel tree

    echo "##### Install Wifis #####"
    pacman -S --noconfirm   iw wpa_supplicant   \ ## wireless network interface
                            dialog              \ ## wifi-menu is depending on
                            wpa_actiond           ## automate wireless connection
    echo "##### Network Manager #####"
    pacman -S --noconfirm networkmanager xfce4-notifyd gnome-keyring
    systemctl enable NetworkManager

    echo "##### Network Time Protocol #####"
    pacman -S --noconfirm ntp
    systemctl enable ntpd
}

install_grub_bios(){
    echo "##### GRUB BIOS/GPT #####"
    pacman -S --noconfirm grub-bios
    grub-install --recheck /dev/${DISK}
    grub-mkconfig -o /boot/grub/grub.cfg
}

build2sdb(){
    DISK=sdb
    HOSTNAME=ghasshee


    partitioning
    build_fs
}
install2sdb(){
    DISK=sdb
    HOSTNAME=ghasshee

    settings
    installation
    mkinitcpio -p linux
    install_grub_bios
    install_gui
    exit
}



###### KERNEL UPGRADE
#### if ( you are upgrading kernel )
####        pacman -S linux        // this command also creates kernel img in /boot/
####        mkinitcpio -p linux
