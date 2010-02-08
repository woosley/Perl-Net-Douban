use strict;
use warnings;
use lib 't/lib';
use Test::Douban;

#use Smart::Comments;
my $keys = pdkeys();

use Test::More tests => 10;    # last test to print
use_ok('Net::Douban::User') or exit;
my $user =
  Net::Douban::User->new(apikey => $keys->{apikey}, userID => 'Net-Douban');
isa_ok($user, 'Net::Douban::User');

my $atom = $user->get_user;
isa_ok($atom, 'Net::Douban::Atom');
like(
    $atom->id,
    qr{^http://api.douban.com/people/33248251$},
    "my url returned right"
);
is($atom->get('db:uid'), 'Net-Douban', 'I am Net-Douban@douban.com');

my $friends = $user->get_friends;
isa_ok($friends, 'Net::Douban::Atom');
my $search = $friends->search_info;
isa_ok($search, 'HASH');
my $entry = ($friends->entries)[0];
isa_ok($entry, 'Net::Douban::Entry');
like($entry->id, qr{^http://api.douban.com/.*}, "should return a url");

my $contacts = $user->get_contacts->search_info;
is($contacts->{totalResults}, 1, 'I have a contact');
