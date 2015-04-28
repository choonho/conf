#!/bin/bash


QEMU=git://git.qemu.org/qemu.git
QEMU_DIR=qemu
LIBVIRT=git://libvirt.org/libvirt.git
LIBVIRT_DIR=libvirt
KVM=git://git.kernel.org/pub/scm/virt/kvm/kvm.git
KVM_DIR=kvm
DPDK=git://dpdk.org/dpdk
DPDK_DIR=dpdk

# Default index is help
IDX=h

while getopts "1234h" OPTION
do
     case $OPTION in
         h)
             IDX=h
             exit 1
             ;;
        1)
            IDX=1
            exit
            ;;
        2)
            IDX=2
            exit
            ;;
        3)
            IDX=3
            exit
            ;;
        4)
            IDX=4
            exit
            ;;
         ?)
            IDX=h
            exit
            ;;
     esac
done

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

function build_kvm
{
    git clone $KVM
} 

function build_dpdk
{
    git clone $DPDK
    cd $DPDK_DIR
    make install T=x86_64-native-linuxapp-gcc
    echo "reference: http://sunshout.tistory.com/1556"
}

function build
{
    echo "Selected option is $IDX"
    case $IDX in
         h)
             usage
             exit 1
             ;;
        1)
            build_qemu
            exit
            ;;
        2)
            build_libvirt
            exit
            ;;
        3)
            build_kvm
            exit
            ;;
        4) build_dpdk
            exit
            ;;
         ?)
             usage
             exit
             ;;
     esac
}

function usage
{
    echo "1) QEMU"
    echo "2) libvirt"
    echo "3) kvm"
    echo "4) dpdk"
}

if [ $# != 1 ]; then
    usage
    echo "Select option"
    read IDX
else
    echo "Selected $1...."
fi
build


