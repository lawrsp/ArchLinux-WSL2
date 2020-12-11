
pacman-key --init
pacman-key --populate archlinux

cd root.x86_64


# mirrorlist
cp -bf ../mirrorlist ./etc/pacman.d/mirrorlist

# locale
sed -i -e "s/#en_US.UTF-8/en_US.UTF-8/" ./etc/locale.gen
#sed -i -e "s/#zh_CN.UTF-8/zh_CN.UTF-8/" ./etc/locale.gen
echo "LANG=en_US.UTF-8" | tee ./etc/locale.conf

# resolve
cp -f /etc/resolv.conf ./etc/resolv.conf
mv -f ./etc/mtab ./etc/mtab.bak
echo "rootfs / rootfs rw 0 0" | tee ./etc/mtab
 
# bootstrap
# recommand: socat zsh  
pacstrap . base sudo vim sed diffutils make openssh git python 

chmod u+s ./usr/bin/ping
rm -rf ./etc/mtab
echo "rootfs / rootfs rw 0 0" | tee ./etc/mtab
chroot . /usr/bin/locale-gen
chroot . /usr/bin/ln /usr/bin/vim /usr/bin/vi

# add a sudo group
chroot . /usr/bin/groupadd -g 27 sudo
cp -f ../sudoers ./etc/sudoers


sleep 2

# clear
yes | chroot . /usr/bin/pacman -Scc
mv -f ./etc/mtab.bak ./etc/mtab
rm -rf `find ./root/ -type f`
rm -rf `find ./var/cache/pacman/pkg/ -type f`
 
tar -zcpf ../rootfs.tar.gz *
chown `id -un` ../rootfs.tar.gz

cd ..
mkdir -p out
mv -f rootfs.tar.gz ./out/install.tar.gz
