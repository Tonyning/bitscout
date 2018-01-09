#!/bin/bash
#Bitscout project
#Copyright Kaspersky Lab

. ./scripts/functions

CHROOTDIR=./chroot

apt_make_dirs()
{
  statusprint "Creating directory structure.."
  mkdir -p $CHROOTDIR/etc/apt
  mkdir -p $CHROOTDIR/var/lib/dpkg
  touch $CHROOTDIR/var/lib/dpkg/status
  mkdir -p $CHROOTDIR/etc/apt/preferences.d/
}

apt_update()
{
  statusprint "Downloading PGP keys.."
  KEYS=( 40976EAF437D05B5 3B4FE6ACC0B21F32 )
  mkdir -p $CHROOTDIR/etc/apt
  for KEY in ${KEYS[*]}
  do
    apt-key --keyring $CHROOTDIR/etc/apt/trusted.gpg adv --recv-keys --keyserver keyserver.ubuntu.com $KEY
  done

  statusprint "Updating indexes.."
  apt -o "Dir=$PWD/$CHROOTDIR" update
}

statusprint "Preparing APT.." &&
apt_make_dirs &&
apt_update
