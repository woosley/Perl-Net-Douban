use strict;
use warnings;
use lib './lib';
use lib 't/lib/';
use Test::Douban;
use Net::Douban::Atom;

use Test::More tests => 5;

my $xml = gtxml;

my $atom = Net::Douban::Atom->new(\$xml);
isa_ok($atom, 'Net::Douban::Atom');

is($atom->title, 'Cowboy Bebop', 'title: Cowboy Bebop');
is($atom->search_info->{totalResults}, 24, '24 results');

my @entries = $atom->entries;
isa_ok($entries[0], 'Net::Douban::Entry');
is(scalar @entries, 2, '2 entries');


