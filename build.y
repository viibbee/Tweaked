name: Build Tweak

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repo
      uses: actions/checkout@v3

    - name: Install dependencies
      run: |
        sudo apt update
        sudo apt install -y ldid make clang git perl curl unzip zip
        git clone --recursive https://github.com/theos/theos.git $HOME/theos
        echo "export THEOS=$HOME/theos" >> $GITHUB_ENV
        echo "export PATH=\$THEOS/bin:\$PATH" >> $GITHUB_ENV

    - name: Set up THEOS
      run: |
        echo "export THEOS=$HOME/theos" >> ~/.bashrc
        echo "export PATH=\$THEOS/bin:\$PATH" >> ~/.bashrc

    - name: Create Makefile and tweak structure
      run: |
        echo "TARGET = iphone:clang:latest:latest" > Makefile
        echo "INSTALL_TARGET_PROCESSES = SpringBoard" >> Makefile
        echo "ARCHS = arm64" >> Makefile
        echo "include \$(THEOS)/makefiles/common.mk" >> Makefile
        echo "TWEAK_NAME = TweakAlert" >> Makefile
        echo "TweakAlert_FILES = Tweak.xm" >> Makefile
        echo "include \$(THEOS)/makefiles/tweak.mk" >> Makefile

    - name: Build tweak
      run: |
        make clean
        make

    - name: Upload dylib
      uses: actions/upload-artifact@v3
      with:
        name: TweakAlert.dylib
        path: .theos/obj/debug/TweakAlert.dylib
