use lib './t/lib';
use Test::Douban;
use Test::Exception;
use Test::More 'tests' => 7;
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

isa_ok($c->request_url, 'URI');

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 1
      unless $ENV{NETWORK_TEST};
    $c->load_token(%{pdakeys()});

    my $contacts = $c->get_user_contacts(userID => 'redicaps', 'start-index' => 1, 'max-results' => 2);  
    is(scalar @{$contacts->{entry}}, 2, "get 2 results");
}

