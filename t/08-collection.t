use lib './t/lib';
use Test::Douban;
use Test::More tests => 9;    # last test to print
use Test::Exception;

BEGIN {
    use_ok("Net::Douban::Collection");
}

my $collection = Net::Douban::Collection->new();
isa_ok($collection, 'Net::Douban::Collection');
my %api_hash = %{Net::Douban::Collection::api_hash};

cmp_ok(scalar keys %api_hash, ">", 0, "api_hash defined");

can_ok($collection, keys %api_hash);

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 5
      unless $ENV{NETWORK_TEST};
    $collection->res_callback(sub {shift});
    $collection->load_token(%{pdakeys()});

    is($collection->get_collection(collectionID => 2154164)->is_success,
        1, "get collection");
    is( $collection->get_user_collection(
            userID => 'Net-Douban',
            cat    => 'book'
          )->is_success,
        1,
        'get user collection'
    );

    is( $collection->post_collection(
            tags      => ["动画"],
            private   => 1,
            content   => "niubility",
            rating    => '5',
            subjectID => 1424406,
            status    => 'watched',
          )->is_success,
        1,
        "add collecition"
    );
    is( $collection->post_collection(
            tags         => ["动画"],
            private      => 1,
            content      => "niubility",
            rating       => '5',
            subjectID    => 1,
            collectionID => 1,
            status       => 'watched',
          )->status_line,
        '400 Bad Request',
        "bad request update collecition"
    );
    is( $collection->delete_collection(collectionID => 1)->status_line,
        '401 Unauthorized',
        "bad request delete collecition"
    );
}
