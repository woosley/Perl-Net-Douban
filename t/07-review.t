use lib './t/lib';
use Test::Douban;
use Test::More tests => 10;
use Test::Exception;

BEGIN {
    use_ok("Net::Douban");
}

my $review = Net::Douban->init(Roles => 'Review');
isa_ok($review, 'Net::Douban');
can_ok($review, 'get_user_review');

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 7
      unless $ENV{NETWORK_TEST};
    $review->res_callback(sub {shift});
    $review->load_token(%{pdakeys()});
    is($review->get_review(reviewID => '1138468')->is_success,
        1, "get review");
    is($review->get_user_review(userID => 'Net-Douban')->is_success,
        1, "get user review");
    is($review->get_movie_review(subjectID => '1424406')->is_success,
        1, "get movie review by subjectID");
    is($review->get_movie_review(imdbID => 'tt0213338')->is_success,
        1, "get movie review by imdbID");
    is( $review->post_review(
            content   => 'wo, nice',
            rating    => 5,
            title     => 'this is a test review',
            subjectID => '1',
          )->status_line,
        '404 Not Found',
        'post review'
    );

    is( $review->put_review(
            content   => 'wo, nice',
            rating    => 5,
            title     => 'this is a test review',
            subjectID => '1',
            reviewID  => '10',
          )->status_line,
        '404 Not Found',
        'put review'
    );
    throws_ok { $review->put_review()} qr/Missing augument/, "Missing augument";
}

