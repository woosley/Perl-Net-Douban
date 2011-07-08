use lib './lib';
use Test::More tests => 12;

use_ok('Net::Douban');
for my $pack (
    qw/User Note Tag Collection Recommendation Event Review Subject Doumail Miniblog Entry/
  )
{
    use_ok("Net::Douban::$pack");
}
diag("Testing Net::Douban, Perl $], $^X on $^O");
