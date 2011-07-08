use Test::More 'no_plan';    # last test to print
use Test::Exception;
{

    package Role;
    use Moose;
    with "Net::Douban::Roles";
}

my $role = Role->new();

isa_ok($role, "Role");

is(ref($role->res_callback), 'CODE', 'res_callback is a CODE');
$role->res_callback(\&foo);
is($role->res_callback->(), 'hello', 'res_callback get hello');
$role->clear_res_callback();

my $api = {
    path          => '/people/{userID}/collection/{collectionID}',
    has_url_param => '1',
};

my $args = {
    userID       => "woosley",
    collectionID => 'hody',
};
my $path = $role->__build_path($api, $args);
is($path, '/people/woosley/collection/hody', "path build");

throws_ok { $role->__build_path($api, {userID => 'hello'}) }
    qr/Missing augument: collectionID/, "not enough augment";

$api->{path} = '/people/x/fo/';
is($role->__build_path($api, $args), '/people/x/fo/', "path build");


sub foo {
    return "hello";
}
