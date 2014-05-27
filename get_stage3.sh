#!/bin/bash

latest=$(curl -s http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64.txt | tail -n1)
wget http://distfiles.gentoo.org/releases/amd64/autobuilds/$latest
