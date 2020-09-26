install
rootpw --plaintext fedora
auth --enableshadow --passalgo=sha512
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
timezone --isUtc Atlantic/Reykjavik
network --activate

text

# Wipe all disk
zerombr
bootloader
clearpart --all --initlabel
autopart --type=plain --encrypted

# Package source
# There's currently no way of using default online repos in a kickstart, see:
# https://bugzilla.redhat.com/show_bug.cgi?id=1333362
# https://bugzilla.redhat.com/show_bug.cgi?id=1333375
# So we default to fedora+updates and exclude updates-testing, which is the safer choice.
url --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=fedora
repo --name=updates
#repo --name=updates-testing

%packages
@^minimal-environment
%end

