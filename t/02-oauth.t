use strict;
use warnings;
use lib './lib';
use lib 't/lib';
use Test::Douban;
use Test::More tests => 7;
use Net::Douban;
use Net::Douban::OAuth;

my $all_tokens = pdakeys;
my $urls       = pdurls;
my $oauth =
  Net::Douban::OAuth->new(%{$all_tokens}, %{$urls}, authorized => 1,);

isa_ok($oauth, 'Net::Douban::OAuth');

my $douban = Net::Douban->new(oauth => $oauth,);

my $saying = $douban->Miniblog->get_user_miniblog(userID => 'Net-Douban');
isa_ok($saying, 'Net::Douban::Atom', 'Return value from get_user_miniblog');
my @a = $saying->entries;
isa_ok($a[0], 'Net::Douban::Entry', 'Content returned from $saying->entires');

my $id = $a[0]->id;
like($id, qr{^http://api.douban.com/miniblog/(\d+)}, 'miniblog id');

$id =~ m{^http://api.douban.com/miniblog/(\d+)};
my $res = $douban->Miniblog->delete_miniblog(miniblogID => $1);
is($res->is_success, 1, 'deleted miniblog');

my $time    = localtime(time);
my $content = <<"EOF";
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
<content>test Perl-Net-Douban: $time</content>
</entry>
EOF
$res = $douban->Miniblog->post_saying(xml => $content);
is($res->is_success, 1, 'created miniblog');

TODO: {
    local $TODO = 'validate not impelmented right now';
    is('1', $douban->oauth->validate);
}
