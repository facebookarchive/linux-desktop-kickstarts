%packages
fedora-workstation-repositories
pciutils
%end

%post
{
# install RPM Fusion's Nvidia driver on VMs (for testing) and if
# the GPU is detected
has_nvidia=false
if /usr/sbin/lspci -mnn | grep -E 'VGA|3D controller' | grep NVIDIA | grep -q 10de; then
  has_nvidia=true
fi

# Lets check if we have virtual machine
systemd-detect-virt >/dev/null && is_virtual=true || is_virtual=false

if $has_nvidia || $is_virtual; then
  echo "Enabling proprietary Nvidia driver repo"
  dnf config-manager --set-enabled \
    rpmfusion-nonfree-nvidia-driver
  echo "Installing proprietary Nvidia driver"
  kver="$(rpm -q kernel --queryformat=%{version}-%{release}.%{arch})"
  dnf install -y \
    akmod-nvidia \
    kernel-devel-$kver \
    nvidia-settings
  # if the installer kernel is of a different version, the driver
  # does not get built automatically
  if [ "$(uname -r)" != "$kver" ];
  then
    echo "Building Nvidia driver"
    akmods --akmod nvidia --kernels $kver
  fi
fi
} 2>&1 | tee -a /root/postinstall.log > /dev/tty3
%end
