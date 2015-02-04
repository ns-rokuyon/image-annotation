#!/bin/bash

DIR=$(cd $( dirname $0 ) && pwd )

BUNDLER_INSTALL_DIR=vendor/bundle

check(){
    status=$1
    cmd=$2
    if [ $status -ne 0 ]; then
        echo "not found: $cmd"
        exit 1
    else
        echo "found: $cmd"
    fi
}

check_commands(){
    ruby -v > /dev/null
    check $? 'ruby'

    gem -v > /dev/null
    check $? 'gem'
}

install_nginx(){
    sudo yum install nginx
}

install_bundler(){
    bundle -v > /dev/null
    if [ $? -ne 0 ]; then
        echo "install bundler ..."
        sudo gem install bundler
        echo "done: install bundler"
    else
        echo "found: bundler"
    fi
}

install_gems(){
    cd $DIR/..
    echo "install gems ..."
    bundle install --path=$BUNDLER_INSTALL_DIR
    echo "done: install gems"
}

main(){
    check_commands
    install_nginx
    install_bundler
    install_gems
}

main "$@"
