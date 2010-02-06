use strict;
use warnings;

use Test::More tests => 2;    # last test to print
use_ok('Net::Douban') or exit;
my $douban = Net::Douban->new;
isa_ok($douban, 'Net::Douban');
