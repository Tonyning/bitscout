#!/bin/bash
#Bitscout project
#Copyright Kaspersky Lab

. ./scripts/functions

statusprint "Setting up locale filter (localepurge).." &&
if [ -f "chroot/etc/locale.gen" ]
then 
  sudo sed -i 's,^# '$LANG' UTF-8$,'$LANG' UTF-8,' chroot/etc/locale.gen
else
  echo "$LANG UTF-8" | sudo tee chroot/etc/locale.gen >/dev/null
fi &&
statusprint "Generating locale.." &&
chroot_exec chroot 'locale-gen "'$LANG'"' || exit 1 &&

statusprint "Updating system and installing essential packages.." &&

if [ $GLOBAL_RELEASESIZE -eq 1 ]
then
  chroot_exec chroot 'export DEBIAN_FRONTEND=noninteractive &&
apt-fast -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install   netcat socat casper lupin-casper discover laptop-detect os-prober lxc lxc1 bindfs dialog tmux gawk grub-pc ntpdate  && exit 0 || exit 1' || exit 1
else
  chroot_exec chroot 'export DEBIAN_FRONTEND=noninteractive
apt-fast -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install   file hdparm iptables lshw usbutils parted lsof psmisc strace ltrace time systemd-sysv man-db dosfstools cron busybox-static rsync dmidecode bash-completion command-not-found ntfs-3g netcat socat uuid-runtime vim nano less pv casper lupin-casper discover laptop-detect os-prober lxc lxc1 bindfs wicd-curses dialog tmux gawk ntpdate nbd-server grub-pc   qemu-kvm  && exit 0 || exit 1' || exit 1
fi &&
statusprint "Finished installing packages." &&

statusprint "Upgrading kbd package." && #kbd is updated separately, because of related GDM issue/bug.
chroot_exec chroot 'export DEBIAN_FRONTEND=noninteractive &&
apt-mark unhold kbd &&
cp /bin/kbd_mode.dist /bin/kbd_mode &&
apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" upgrade' || exit 1 &&


exit 0;
