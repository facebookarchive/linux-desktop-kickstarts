# Copyright (c) Facebook, Inc. and its affiliates.

# This provides the best UX for workstation deployments
selinux --permissive

%packages
@^workstation-product-environment
# initial-setup-gui
%end

%post
# boot in graphical mode
systemctl set-default graphical.target
%end
