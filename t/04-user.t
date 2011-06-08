use strict;
use warnings;

use Test::More tests => '4';                      # last test to print

BEGIN {
    use_ok("Net::Douban::User");
}

my $user = Net::Douban::User->new('userID' => 'redicaps');
isa_ok($user, 'Net::Douban::User');
my %api_hash = %{Net::Douban::User::api_hash};

cmp_ok(scalar keys %api_hash, ">", 0, "api_hash defined");

can_ok($user, keys %api_hash);
