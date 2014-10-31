#!/bin/bash


URL='https://raw.githubusercontent.com/choonho/conf/master'
INIT='init'
VIMRC='.vimrc'
MKCS='mkcs'

function install_pkg()
{
    apt-get -y install vim    >> ./install.log
    apt-get -y install cscope >> ./install.log 
    apt-get -y install ctags  >> ./install.log
}

function update_config()
{
    vimrc=$URL/$INIT/$VIMRC
    mkcs=$URL/$INIT/$MKCS

    echo "Download .vim from $vimrc"
    rm -f $1/$VIMRC
    wget --no-check-certificate -O $1/$VIMRC $vimrc

    echo "Download mkcs from $mkcs"
    rm -f $1/$MKCS
    wget --no-check-certificate -O $1/$MKCS $mkcs
    chmod 744 $1/$MKCS
}

if [ $# -eq 1 ]
then
    echo "Install tools in $1"
    install_pkg $1
    update_config $1
else
    PWD=`pwd`
    echo "Install tools in $PWD"
    install_pkg $PWD
    update_config $PWD
fi

