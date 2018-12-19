# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Test grass
# Maintainer: Guillaume <guillaume@opensuse.org>

use base 'x11test';
use strict;
use testapi;

sub run {
    my ($self) = @_;

    select_console('x11');
    ensure_installed('grass');
    x11_start_program('grass');

    # Check we have the grass main window
    assert_screen('grass');

    # TODO: test GRASS


    # Close GRASS
    send_key 'alt-f4';

    # Make sure GRASS is closed and desktop is shown
    assert_screen 'generic-desktop';
}

1;
