%include bases/luks-btrfs-minimal.ks

%include snippets/workstation.ks
%include snippets/zram.ks

# see if we can activate the WiFi adapter this way
graphical

# test changes in one of the minimal kickstarts
# this one should be robust, so just reboot at the end
reboot
