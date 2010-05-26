use strict;
use warnings;
use lib './lib';
use lib 't/lib/';
use Test::Douban;
use Net::Douban::Atom;

use Test::More tests => 1;

my $xml = gtxml;

my $atom = Net::Douban::Atom->new(\$xml);
