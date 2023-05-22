# Packer build for Rocky Linux 8/9 core Vagrant base box

## Prerequisites

Packer >= 1.7.x, Vagrant >= 2.2.x and VirtualBox >= 6.1.x must be installed (beyond the scope of this document).

## Description

This Packer build generates a minimal Rocky Linux 8 or 9 core image using the `virtualbox-iso` builder and a Vagrant box based on it using the `vagrant` post-processor.

## Steps

1. Adjust the contents of `variables-8.json` or `variables-9.json` accordingly.  It's a good idea to always grab the latest upstream ISO.

2. Build the box (e.g. for Rocky Linux 9):

    ```
    packer build -var-file variables-9.json packer.json
    ```

3. Test the box locally:

    ```
    vagrant box add --name rocky-9.2-core-20230522 rocky-9.2-core-20230522.box
    vagrant init --minimal rocky-9.2-core-20230522
    vagrant up
    # test here
    vagrant destroy -f
    rm -f Vagrantfile
    vagrant box remove rocky-9.2-core-20230522
    ```

4. Upload the box to Vagrant Cloud: [dhml/rocky-9.2-core-20230522](https://app.vagrantup.com/dhml/boxes/rocky-9.2-core-20230522)

5. Test the box from Vagrant Cloud:

    ```
    vagrant init --minimal dhml/rocky-9.2-core-20230522
    vagrant up
    # test here
    vagrant destroy -f
    rm -f Vagrantfile
    vagrant box remove dhml/rocky-9.2-core-20230522
    ```

6. Update box names/versions/URLs in Vagrantfiles in other repositories that reference this box.
