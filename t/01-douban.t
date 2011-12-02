use lib './t/lib';
use Test::Douban;
use Test::Exception;
use Test::More 'no_plan';

package My::Trait;
{
    use Moose::Role;
    with "Net::Douban::Review"
}

package main;
use_ok('Net::Douban') or exit;

my $b = Net::Douban->init(Traits => '+My::Trait');
isa_ok($b, 'Net::Douban');
can_ok($b, 'get_user_review');
my $c = Net::Douban->init(Roles => 'User');
isa_ok($c, 'Net::Douban');
can_ok($c, 'get_user');

