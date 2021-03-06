# SUSE's openQA tests
#
# Copyright © 2009-2013 Bernhard M. Wiedemann
# Copyright © 2012-2018 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Summary: Case#1436067: Firefox: SSL Certificate
# Maintainer: wnereiz <wnereiz@gmail.com>

use strict;
use base "x11test";
use testapi;
use version_utils 'is_sle';

sub run {
    my ($self) = @_;
    $self->start_firefox_with_profile;

    $self->firefox_open_url('https://build.suse.de');

    assert_screen 'firefox-ssl-untrusted';

    # go to advanced button and press it
    send_key "tab";
    send_key "ret";
    # firefox 60.2+ has checkbox above buttons (2 tabs) and rest has checkbox under buttons (3 tabs)
    my $count = is_sle('=12-sp4') ? 3 : 2;
    for (1 .. $count) { send_key "tab"; }
    send_key "ret";

    assert_screen('firefox-ssl-addexception', 60);
    send_key "alt-c";

    assert_screen('firefox-ssl-loadpage', 60);

    send_key "alt-e";
    wait_still_screen 3;
    send_key "n";

    if (is_sle('=12-sp4')) {
        assert_and_click('firefox-ssl-preference_advanced');
        assert_and_click('firefox-ssl-advanced_certificate');
        send_key "alt-shift-c";
    }
    else {
        assert_and_click('firefox-preferences-search');
        type_string "cert\n";
        assert_and_click('firefox-ssl-preference-view-certificate');
    }

    sleep 1;
    assert_and_click('firefox-ssl-certificate_table');

    sleep 1;
    type_string "hong";
    send_key "down";

    sleep 1;
    send_key "alt-shift-e";

    sleep 1;
    send_key "spc";
    assert_screen('firefox-ssl-edit_ca_trust', 30);
    send_key "ret";


    sleep 1;
    assert_and_click('firefox-ssl-certificate_servers');

    for (1 .. 3) { send_key "pgdn"; }

    sleep 1;
    assert_screen('firefox-ssl-servers_cert', 30);

    wait_screen_change { send_key "esc" };
    send_key "ctrl-w";

    $self->firefox_open_url('https://www.hongkongpost.gov.hk');
    assert_screen('firefox-ssl-connection_untrusted');

    # Exit
    $self->exit_firefox;
}
1;
