use strict;
use warnings;

use Test::More tests => 9;    # last test to print
use_ok('Net::Douban::User') or exit;
my $user =
  Net::Douban::User->new( apikey => '04e6b457934823350eb41d06b9d8699f' );
isa_ok( $user, 'Net::Douban::User' );
my $atom = $user->get_user( userID => 'redicaps' );
isa_ok( $atom, 'Net::Douban::Atom' );
my $id = $atom->id;
like( $id, qr{^http://api.douban.com/.*}, "should return a url" );
my $uid = $atom->get('db:uid');
is( $uid, 'redicaps', 'I am redicaps@douban.com' );
my $friends = $user->get_friends( userID => 'redicaps' );
isa_ok( $friends, 'Net::Douban::Atom' );
my $search = $friends->search_info;
isa_ok( $search, 'HASH' );
my $entry = ( $friends->entries )[0];
isa_ok( $entry, 'Net::Douban::Entry' );
$id = $entry->id;
like( $id, qr{^http://api.douban.com/.*}, "should return a url" );
