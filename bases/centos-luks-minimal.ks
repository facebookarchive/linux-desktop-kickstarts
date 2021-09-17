# Copyright (c) Facebook, Inc. and its affiliates.

text
rootpw --lock
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
timezone America/Los_Angeles --utc

text

# Wipe all disk
zerombr
bootloader
clearpart --all --initlabel

# Package source
url --mirrorlist="http://mirrorlist.centos.org/?release=$releasever&arch=x86_64&repo=BaseOS"
repo --name=AppStream --mirrorlist="http://mirrorlist.centos.org/?release=$releasever&arch=x86_64&repo=AppStream"
repo --name=epel --metalink="https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=x86_64"

eula --agreed

%packages
@^minimal-environment
%end

