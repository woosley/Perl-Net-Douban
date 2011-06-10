use lib './t/lib';
use Test::Douban;
use Test::More tests => '5';                      # last test to print

BEGIN {
    use_ok("Net::Douban::User");
}

my $user = Net::Douban::User->new('userID' => 'redicaps');
isa_ok($user, 'Net::Douban::User');
my %api_hash = %{Net::Douban::User::api_hash};

cmp_ok(scalar keys %api_hash, ">", 0, "api_hash defined");

can_ok($user, keys %api_hash);

SKIP: {
    skip "skip network tests", 1 unless $ENV{NETWORK_TEST};
    $user->res_callback(sub { shift });
    $user->load_token(%{pdakeys()});
    is($user->me()->is_success, 1, "get myself is successful");
}
