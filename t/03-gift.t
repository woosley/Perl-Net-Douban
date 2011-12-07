use lib 't/lib';
use Test::Douban;
use Net::Douban;
use Test::More 'tests' => 10;
use Test::Exception;
throws_ok { Net::Douban->init() } qr/^Without/, "Missing augument";
my $gift = Net::Douban->init("Traits" => 'Gift');
isa_ok($gift, 'Net::Douban');
can_ok($gift, "my_recoms");

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 7
      unless $ENV{NETWORK_TEST};
    $gift->load_token(%{pdakeys()});
    my $json = $gift->me;
    $gift->uid($json->{"db:uid"}->{'$t'});
    $gift->res_callback(sub {shift});
    is($gift->my_recoms()->is_success,      1, "load my recommendations");
    is($gift->my_notes()->is_success,       1, "my notes");
    is($gift->my_reviews()->is_success,     1, "my reviews");
    is($gift->my_collections()->is_success, 1, "my collections");
    is($gift->my_miniblogs()->is_success,   1, "my miniblogs");
    is($gift->my_contact_miniblogs()->is_success, 1, "my contact miniblogs");
    is($gift->my_events()->is_success,            1, "my events");
}
