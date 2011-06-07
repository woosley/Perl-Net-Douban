use strict;
use warnings;

use Test::More tests => 6;    # last test to print
use_ok('Net::Douban') or exit;
my $douban = Net::Douban->new('max_results' => '5', apikey => 'sap5kyif');
isa_ok($douban, 'Net::Douban');

my $user = $douban->user;
isa_ok($douban->user, 'Net::Douban::User');
is($user->max_results, 5, 'max results is 5');
is($user->apikey, 'sap5kyif', 'api key is sap5kyif');

$user->max_results(10);


my $user2 = $douban->user;
is_deeply($user, $user2, "objects are same strcuture");
