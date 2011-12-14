use lib './t/lib';
use Test::Douban;
use Test::More tests => '7';    # last test to print
use_ok("Net::Douban","use Net::Douban");
my $user = Net::Douban->init(Roles => 'User');
isa_ok($user, 'Net::Douban');
#my %api_hash = %{Net::Douban::User::api_hash};

#cmp_ok(scalar keys %api_hash, ">", 0, "api_hash defined");

#can_ok($user, keys %api_hash);

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 5
      unless $ENV{NETWORK_TEST};
    $user->res_callback(sub {shift});
    $user->load_token(%{pdakeys()});
    is($user->me()->is_success, 1, "get myself is successful");
    is($user->get_user(userID => 'redicaps')->is_success,
        1, "get user 'redicaps'");
    is($user->get_user_contacts(userID => 'redicaps')->is_success,
        1, "get user's contacts");
    is($user->get_user_friends(userID => 'Net-Douban')->is_success,
        1, "get user's friends");
    is($user->search_user(q => 'abei')->is_success,
        1, "search abei");
}
