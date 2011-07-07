use lib './t/lib';
use Test::Douban;
use Test::More tests => 11;
use Test::Exception;

BEGIN {
    use_ok("Net::Douban::Recommendation");
}

my $recom = Net::Douban::Recommendation->new();
isa_ok($recom, 'Net::Douban::Recommendation');
my %api_hash = %{Net::Douban::Recommendation::api_hash};

cmp_ok(scalar keys %api_hash, ">", 0, "api_hash defined");
can_ok($recom, keys %api_hash);

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 8
      unless $ENV{NETWORK_TEST};
    $recom->res_callback(sub {shift});
    $recom->load_token(%{pdakeys()});

    is($recom->get_recom(recomID => '25171200')->is_success,
        1, "get recommendation ok");
    is($recom->get_user_recom(userID => 'Net-Douban')->is_success,
        1, "get user recom ok");

    is($recom->get_recom_comments(recomID => '25171200')->is_success,
        1, "get coments");
    my $id = 25171200;
    $recom->clear_res_callback;
    my $post;
    like(
        $post = $recom->post_recom(
            comment => "神作",
            title   => "name",
            link    => "http://api.douban.com/movie/subject/1424406",
          )->{id}{'$t'},
        qr{^http://api.douban.com/recommendation/\d+$},
        'post recom ok',
    );

    $post = (split /\//, $post)[-1];
  SKIP: {
        skip "skip because douban bug", 2;
        my $comm;
        like(
            $comm = $recom->post_comment(
                recomID => $post,
                content => "test net-douban",
              )->{id}{'$t'},
            qr{^http://api.douban.com/recommendation/$post/comment/(\d+)$},
            'post comment ok',
        );
        $comm = (split /\//, $comm)[-1];
        $recom->res_callback(sub {shift});
        is( $recom->delete_comment(recomID => $post, commentID => $comm)
              ->is_success,
            1,
            "delete recomment ok"
        );
    }

    $recom->res_callback(sub {shift});
    is( $recom->delete_recom(recomID => $post)->is_success,
        1, "delete recom ok",
    );
}

