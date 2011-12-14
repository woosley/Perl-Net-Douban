use lib './t/lib';
use Test::Douban;
use Test::More tests => 6;
use Test::Exception;

BEGIN {
    use_ok("Net::Douban");
}

my $mail = Net::Douban->init(Roles => 'Doumail');
isa_ok($mail, 'Net::Douban');

can_ok($mail, 'get_mail_outbox');

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 3
      unless $ENV{NETWORK_TEST};
    $mail->res_callback(sub {shift});
    $mail->load_token(%{pdakeys()});

    is($mail->get_mail_inbox->is_success,
        1, "get inbox mail ok");
    is($mail->get_mail_outbox->is_success,
        1, "get mail outbox");
    is($mail->get_mail(doumailID=> '55556547')->is_success,
        1, "get doumail");
#   is($mail->post_mail(
#                receiver => 'Net-Douban',
#                content => 'test net-douban ' . localtime(time),
#                title => 'helo',
#                )->is_success, 1, 'post mail');
#    $mail->clear_res_callback;
#    my $entries = $mail->get_mail_unread->{entry};
#    cmp_ok(scalar @{$entries}, '>', 0, "get unread mail");
}
