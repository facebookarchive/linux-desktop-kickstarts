# Copyright (c) Facebook, Inc. and its affiliates.
#
# with thanks to Jason Edgecombe <jason@rampaginggeek.com>
# https://www.redhat.com/archives/kickstart-list/2012-October/msg00014.html

%pre
# pre section
#----- partitioning logic below--------------
#!/bin/bash
# pick the first drive that is not removable and is over MINSIZE
DIR="/sys/block"

# minimum size of hard drive needed specified in GIGABYTES
# set to 20 to exclude common thumbdrive sizes, and also
# keep it small enough to cope with VMs
MINSIZE=20

ROOTDRIVE=""

# /sys/block/*/size is in 512 byte chunks
for DEV in $(cd $DIR; ls -d nvme?n? sd? hd? 2>/dev/null); do
  if [ -d $DIR/$DEV ]; then
    REMOVABLE=`cat $DIR/$DEV/removable`
    if (( $REMOVABLE == 0 )); then
      echo $DEV
      SIZE=`cat $DIR/$DEV/size`
      GB=$(($SIZE/2**21))
      if [ $GB -gt $MINSIZE ]; then
        echo "Found matching drive: $(($SIZE/2**21)) GB"
        ROOTDRIVE=$DEV
        break
      fi
    fi
  fi
done

echo "ROOTDRIVE=$ROOTDRIVE"

cat << EOF >> /tmp/part-include
# Wipe disk
zerombr
bootloader --driveorder=$ROOTDRIVE
clearpart --all --drives=$ROOTDRIVE --initlabel
reqpart
part /boot --fstype=ext4 --size=1024 --asprimary --label="boot" --ondisk=$ROOTDRIVE
part /boot/efi --fstype=efi --asprimary --size=1024 --label="esp" --ondisk=$ROOTDRIVE
part pv.01 --size=1000 --grow --type=lvm --encrypted --passphrase="centos" --ondisk=$ROOTDRIVE
# Create Volume group
volgroup centos pv.01
# Create logical volumes
logvol swap --vgname=centos --name=swap --hibernation
logvol / --vgname=centos --size=2048 --grow --name=root --label=root

EOF
%end

# include the partitioning logic from the pre section.
%include /tmp/part-include
