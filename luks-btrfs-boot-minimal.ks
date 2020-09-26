# based on example-minimal
# https://fedoraproject.org/wiki/QA:Testcase_Kickstart_Http_Server_Ks_Cfg
# https://fedorapeople.org/groups/qa/kickstarts/example-minimal.ks
# + https://github.com/rhinstaller/kickstart-tests/blob/master/btrfs-1.ks.in
# + https://fedoraproject.org/wiki/Changes/SwapOnZRAM
install
rootpw --lock
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
timezone America/Los_Angeles --utc
network --activate

text

# Wipe all disk
zerombr
bootloader
clearpart --all --initlabel
part btrfs.boot --fstype=btrfs --size=1024
part btrfs.main --fstype=btrfs --encrypted --grow --fsoptions="compress=zstd:1,space_cache=v2"

btrfs /boot --label=fedora-boot btrfs.boot
btrfs none --label=fedora-btrfs btrfs.main
btrfs / --subvol --name=root fedora-btrfs
btrfs /home --subvol --name=home fedora-btrfs
btrfs /var/log --subvol --name=var_log fedora-btrfs
btrfs /var/lib/libvirt/images --subvol --name=libvirt_images fedora-btrfs

# Package source
# There's currently no way of using default online repos in a kickstart, see:
# https://bugzilla.redhat.com/show_bug.cgi?id=1333362
# https://bugzilla.redhat.com/show_bug.cgi?id=1333375
# So we default to fedora+updates and exclude updates-testing, which is the safer choice.
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=fedora
repo --name=updates
#repo --name=updates-testing

# make sure that initial-setup runs and lets us do all the configuration bits
firstboot --reconfig

%packages
@^minimal-environment
initial-setup
%end

%post
# https://unix.stackexchange.com/a/351755 for handling TTY in anaconda
printf "Press Alt-F3 to view post-install logs\r\n" > /dev/tty1
{
echo "Turning off copy-on-write for libvirt images directory"
chattr +C /var/lib/libvirt/images
} 2>&1 | tee -a /root/postinstall.log > /dev/tty3
%end
