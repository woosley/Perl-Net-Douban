use Test::More tests => '2';                      # last test to print
{
    package Role;
    use Moose;
    with "Net::Douban::Roles";
}


my $role = Role->new();

isa_ok($role, "Role");

is(ref($role->res_callback), 'CODE', 'res_callback is a CODE');
