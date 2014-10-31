#!/bin/bash

echo "Install tools for you"

function install_pkg()
{
    apt-get -y install vim    >> ./install.log
    apt-get -y install cscope >> ./install.log 
    apt-get -y install ctags  >> ./install.log
}

function update_config()
{
    echo "Download .vim"
    echo "Download mkcs"

}


install_pkg
update_config

