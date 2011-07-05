use Test::More tests => '3';                      # last test to print
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

sub foo {
    return "hello";
}
