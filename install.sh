#!/bin/bash

dcm_dir="$HOME/dcm"
if [ -d "$dcm_dir" ]; then
    rm -rf $dcm_dir
fi
cd $HOME
git clone https://github.com/josercc/dcm.git
cd dcm
dart pub get
dart run realm_dart install
dart pub global activate dcm
rm -rf $dcm_dir
