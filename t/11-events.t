use lib './t/lib';
use Test::Douban;
use Test::More tests => 13;
use Test::Exception;

BEGIN {
    use_ok("Net::Douban::Event");
}

my $event = Net::Douban::Event->new();
isa_ok($event, 'Net::Douban::Event');
my %api_hash = %{Net::Douban::Event::api_hash};

cmp_ok(scalar keys %api_hash, ">", 0, "api_hash defined");

can_ok($event, keys %api_hash);

SKIP: {
    skip 'set $ENV{NETWORK_TEST} to enable network tests', 9
      unless $ENV{NETWORK_TEST};
    $event->res_callback(sub {shift});
    $event->load_token(%{pdakeys()});

    is($event->get_event(eventID => '10069638')->is_success,
        1, "get event ok");
    is($event->get_event_participants(eventID => '10069638')->is_success,
        1, "get event participants");
    is($event->get_event_wishers(eventID => '10069638')->is_success,
        1, "get event wishers");
    is($event->get_user_events(userID => 'redicaps')->is_success,
        1, "get user events");
    is($event->get_user_initiates(userID => 'redicaps')->is_success,
        1, "get events init by user");
    is($event->get_user_participates(userID => 'redicaps')->is_success,
        1, "get events participate by user");
    is($event->get_user_wishes(userID => 'redicaps')->is_success,
        1, "get events wish by user");
    is( $event->get_location_events(
        locationID => 'beijing', type => 'music')->is_success,
        1,
        "get event's in beijing"
    );
    is( $event->search_events(
            location => 'beijing', q => 'jazz')->is_success,
        1,
        'search events OK'
    );
}
