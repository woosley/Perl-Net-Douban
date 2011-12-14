use lib './t/lib';
use Test::Douban;
use Test::More tests => 8;
use Test::Exception;

BEGIN {
    use_ok("Net::Douban");
}

my $collection = Net::Douban->init(Roles => 'Collection');
isa_ok($collection, 'Net::Douban');
can_ok($collection, 'get_collection');

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
