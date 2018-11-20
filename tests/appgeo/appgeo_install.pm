# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Add Application:Geo repo and install Geo software
# Maintainer: Guillaume <guillaume@opensuse.org>

use base 'consoletest';
use strict;
use testapi;
use version_utils qw(is_leap);

sub run {
    my ($self) = @_;
    
    select_console('root-console');

    # disable packagekitd
#     systemctl 'mask packagekit';
#     systemctl 'stop packagekit';
    
    # Default to TW
    my $repo_suffix = "openSUSE_Tumbleweed";
    if ( is_leap('15.0+') ){
        $repo_suffix = "openSUSE_Leap_15.0";
    }
    if ( is_leap('15.0+') ){
        # Leap 15.0: Add OSS and update repo (removed in HDD creation)
        assert_script_run "zypper ar -f http://download.opensuse.org/distribution/leap/15.0/repo/oss/ OSS-repo";
        assert_script_run "zypper ar -f http://download.opensuse.org/update/leap/15.0/oss/openSUSE:Leap:15.0:Update.repo";
    }
    else {
        # TW: Add OSS and update repo (removed in HDD creation)
        assert_script_run "zypper ar -f http://download.opensuse.org/tumbleweed/repo/oss/ OSS-repo";    
        assert_script_run "zypper ar -f http://download.opensuse.org/update/tumbleweed/openSUSE:Factory:Update.repo";
    }
    
    # Add Application:Geo repo with zypper
    assert_script_run "zypper ar -f https://download.opensuse.org/repositories/Application:/Geo/$repo_suffix/Application:Geo.repo";
    assert_script_run "zypper --gpg-auto-import-keys ref";
    
    # Install wanted applications (TODO: move to each test?)
    assert_script_run "zypper -n install qgis qgis-otb-plugin otb-module-iota2 otb-bin", timeout => 600;
}

 sub test_flags {
     # add milestone flag to save setup in lastgood VM snapshot
     return {fatal => 1, milestone => 1};
 }

1;
