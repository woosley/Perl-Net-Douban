use lib './t/lib';
use Test::Douban;
use Test::More tests => 12;
use Test::Exception;

BEGIN {
    use_ok("Net::Douban", "use Net::Douban");
}

my $subject = Net::Douban->init(Roles => 'Subject');
isa_ok($subject, 'Net::Douban');
my %api_hash = %{Net::Douban::Subject::api_hash};

cmp_ok(scalar keys %api_hash, ">", 0, "api_hash defined");

can_ok($subject, keys %api_hash);

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 8
      unless $ENV{NETWORK_TEST};
    $subject->res_callback(sub {shift});
    $subject->load_token(%{pdakeys()});
    is($subject->get_book(subjectID => '2023013')->is_success,
        1, "get book by subjectID is success");
    throws_ok { $subject->get_book } qr/Missing augument/, "Missing augument";
    is($subject->get_book(isbnID => '7543639130')->is_success,
        1, "get book by isbnID is success");
    throws_ok { $subject->search_book } qr/Missing parameter/,
      "Missing parameter";
    is($subject->search_book(tag => 'cowboy')->is_success,
        1, "search book by tag is success");
    is($subject->search_book(q => 'cowboy')->is_success,
        1, "search book by keywords  is success");
    is($subject->search_movie(tag => 'cowboy')->is_success,
        1, "search movie is success");
    is($subject->search_music(tag => 'cowboy')->is_success,
        1, "search music is success");
}

