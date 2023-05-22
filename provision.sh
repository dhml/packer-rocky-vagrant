#!/bin/sh

set -ex

PACKER_PROVISIONED="/tmp/packer-provisioned"

# exit if provisioning already run

[ -e $PACKER_PROVISIONED ] && exit 0

# update all packages if updates exist

if ! dnf -y check-update >/dev/null 2>&1
then
  dnf -y update && reboot
  exit 0
fi

# enable powertools/crb repositories

. /etc/os-release
if echo "$VERSION_ID" | grep -q '^8\.'
then
  dnf config-manager --set-enabled powertools
elif echo "$VERSION_ID" | grep -q '^9\.'
then
  dnf config-manager --set-enabled crb
fi

# configure vagrant base box

useradd -d /home/vagrant -m -p '$6$shio$0HD0iWqBtcMNUKTHZamjN8xB4iJBUlOxJPOFeL56ylmnM3V44y3xlfwpsUp1mOj64zq/ChKyiPJNZOw1RY8zM0' -s /bin/bash -u 1000 -U vagrant
mkdir /home/vagrant/.ssh
chown 1000:1000 /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key' > /home/vagrant/.ssh/authorized_keys
chown 1000:1000 /home/vagrant/.ssh/authorized_keys
chmod 0644 /home/vagrant/.ssh/authorized_keys
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# configure 2gb swap file

dd if=/dev/zero of=/swapfile bs=1M count=2048
chmod 600 /swapfile
mkswap /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# clean up

rm -rfv /{home,tmp}/*/.ansible/tmp
rm -rfv /var/tmp/*/ansible/tmp
rm -fv /etc/udev/rules.d/70-persistent-net.rules

# mark first provision

touch $PACKER_PROVISIONED
