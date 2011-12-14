use lib './t/lib';
use Test::Douban;
use Test::More tests => 8;
use Test::Exception;

BEGIN {
    use_ok("Net::Douban");
}

my $note = Net::Douban->init(Roles => 'Note');
isa_ok($note, 'Net::Douban');

can_ok($note, 'get_user_notes');

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 5
      unless $ENV{NETWORK_TEST};
    $note->res_callback(sub {shift});
    $note->load_token(%{pdakeys()});

    is($note->get_note(noteID => '73471700')->is_success, 1, "get note ok");
    is($note->get_user_notes(userID => 'Net-Douban')->is_success,
        1, "get user note ok");

    $note->clear_res_callback;
    my $post;
    like(
        $post = $note->post_note(
            content   => "test net-douban at " . scalar localtime(time),
            title     => "hello world",
            can_reply => 1,
          )->{id}{'$t'},
        qr{^http://api.douban.com/note/\d+$},
        'post note ok',
    );

    $post = (split /\//, $post)[-1];
    $note->res_callback(sub {shift});

    is( $note->put_note(
            content   => "test net-douban at " . scalar localtime(time),
            title     => "hello world",
            can_reply => 1,
            noteID    => $post,
          )->is_success,
        1,
        'update note ok'
    );

    is($note->delete_note(noteID => $post)->is_success, 1, "delete note ok",);
}
