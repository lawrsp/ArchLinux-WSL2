cd root.x86_64

# mirrorlist, just open a server
sudo cp -bf ../mirrorlist ./etc/pacman.d/mirrorlist

# set locale
sudo sed -i -e "s/#en_US.UTF-8/en_US.UTF-8/" ./etc/locale.gen
#sudo sed -i -e "s/#zh_CN.UTF-8/zh_CN.UTF-8/" ./etc/locale.gen
echo "LANG=en_US.UTF-8" | sudo tee ./etc/locale.conf

# copy resolve.conf
sudo cp -f /etc/resolv.conf ./etc/resolv.conf
sudo mv -f ./etc/mtab ./etc/mtab.bak
echo "rootfs / rootfs rw 0 0" | sudo tee ./etc/mtab
 
# prepare 
sudo mount -t proc /proc proc
sudo mount --make-rslave --rbind /sys sys
sudo mount --make-rslave --rbind /dev dev
sudo mount --make-rslave --rbind /run run 

# install packages
sudo chroot . pacman-key --init
sudo chroot . pacman-key --populate archlinux
sudo chroot . /usr/bin/pacman -Syu --noconfirm bzip2 coreutils diffutils gawk gcc-libs gettext grep gzip inetutils iproute2 iputils less man-db man-pages nano sed tar vi vim wget which

sudo chmod u+s ./usr/bin/ping
sudo rm -rf ./etc/mtab
echo "rootfs / rootfs rw 0 0" | sudo tee ./etc/mtab
sudo chroot . /usr/bin/locale-gen


# clear
yes | sudo chroot . /usr/bin/pacman -Scc
 
# kill agent for workaround
sudo pkill gpg-agent
sleep 5
sudo rm -rf ./etc/pacman.d/gnupg
sudo umount -l ./sys
sudo umount -l ./proc
sudo umount -l ./dev
sudo umount -l ./run
sudo mv -f ./etc/mtab.bak ./etc/mtab

sudo rm -rf `sudo find ./root/ -type f`
sudo rm -rf `sudo find ./var/cache/pacman/pkg/ -type f`
  
sudo tar -zcpf ../rootfs.tar.gz *
sudo chown `id -un` ../rootfs.tar.gz
cd ..
mkdir -p out
mv -f rootfs.tar.gz ./out/install.tar.gz
