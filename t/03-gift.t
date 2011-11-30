use lib 't/lib';
use Test::Douban;
use Net::Douban;

use Test::More 'no_plan';
use Test::Exception;
throws_ok {Net::Douban->new()} qr/^Without/, "Missing augument";
my $gift = Net::Douban->new("Roles" => 'User');
$gift->load_token(%{pdakeys()});
