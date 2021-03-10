# Copyright (c) Facebook, Inc. and its affiliates.

%include bases/centos-luks-minimal.ks

%include snippets/workstation.ks

# see if we can activate the WiFi adapter this way
graphical

# test changes in one of the minimal kickstarts
# this one should be robust, so just reboot at the end
reboot
