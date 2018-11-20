# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Add Application:Geo repo and install Geo software
# Maintainer: Guillaume <guillaume@opensuse.org>

use base 'x11test';
use strict;
use testapi;

sub run {
    my ($self) = @_;
    
    select_console('x11');
    
    x11_start_program('qgis');
    
    if (check_screen('qgis-welcome')){
        # Close tip of day
        wait_screen_change { send_key 'esc'; };
    }

    # Check we have the qgis main window
    assert_screen('qgis');
    
    # TODO: test QGIS
    
    
    # TODO: close QGIS
    send_key 'alt-f4';
    
    # Make sure QGIS is closed and desktop is shown
    assert_screen 'generic-desktop';
}

1;
