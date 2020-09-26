%packages
@^workstation-product-environment
# initial-setup-gui
%end

%post
# boot in graphical mode
systemctl set-default graphical.target
%end
