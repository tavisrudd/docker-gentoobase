#!/bin/bash

# release keys from http://www.gentoo.org/proj/en/releng/index.xml
for key in "0xBB572E0E2D182910" "0xDB6B8C1F96D8BF6D"; do
    gpg --keyserver subkeys.pgp.net --recv-keys $key
    gpg --edit-key $key trust
done
