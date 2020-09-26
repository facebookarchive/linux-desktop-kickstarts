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
part /boot --fstype=ext4 --size=1024 --ondisk=$ROOTDRIVE
part btrfs.main --fstype=btrfs --encrypted --grow --fsoptions="compress=zstd:1,discard=async,space_cache=v2" --passphrase="fedora" --ondisk=$ROOTDRIVE

btrfs none --label=fedora-btrfs btrfs.main
btrfs / --subvol --name=root fedora-btrfs
btrfs /home --subvol --name=home fedora-btrfs
btrfs /var/log --subvol --name=var_log fedora-btrfs
btrfs /var/lib/libvirt/images --subvol --name=libvirt_images fedora-btrfs

EOF
%end

# include the partitioning logic from the pre section.
%include /tmp/part-include
