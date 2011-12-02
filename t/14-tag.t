use lib './t/lib';
use Test::Douban;
use Test::More tests => 6;
use Test::Exception;

BEGIN {
    use_ok("Net::Douban");
}

my $tag = Net::Douban->init(Roles => 'Tag');
isa_ok($tag, 'Net::Douban');
my %api_hash = %{Net::Douban::Tag::api_hash};

cmp_ok(scalar keys %api_hash, ">", 0, "api_hash defined");

can_ok($tag, keys %api_hash);

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 2
      unless $ENV{NETWORK_TEST};
    $tag->res_callback(sub {shift});
    $tag->load_token(%{pdakeys()});

    is($tag->get_tags(cat => 'movie', subjectID => 3610047)->is_success,
        1, 'get movie tags');

    is( $tag->get_user_tags(userID => 'sakinijino', cat => 'movie')
          ->is_success,
        1,
        'get user tags',
    );
}
