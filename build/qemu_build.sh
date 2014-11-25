#!/bin/bash


QEMU=git://git.qemu.org/qemu.git
QEMU_DIR=qemu
LIBVIRT=git://libvirt.org/libvirt.git
LIBVIRT_DIR=libvirt

function build_qemu
{
    git clone $QEMU $QEMU_DIR
    apt-get -y build-dep qemu
    cd $QEMU_DIR
    ./configure --enable-debug --target-list="x86_64-softmmu" --enable-kvm
    make -j 4
    make install

    echo "reference: http://sunshout.tistory.com/1553"
}

function build_libvirt
{
    git clone $LIBVIRT
    apt-get -y build-dep libvirt-bin
    apt-get install libtool autopoint xsltproc w3c-dtd-xhtml python-dev autoconf libnl-route-3-dev

    cd $LIBVIRT_DIR
    ./autogen.sh
    make -j 4
    make install
    echo "/usr/lib/libvirt.so.0" > /etc/ld.so.conf.d/libvirt.conf
    ldconfig

    echo "To start libvirt..."
    echo "/usr/local/sbin/libvirtd -d"
    /usr/local/sbin/libvirtd -d
    virsh version

    echo "reference: http://sunshout.tistory.com/1607"
}

build_qemu
build_libvirt
