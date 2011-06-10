use Test::More tests => 2;

{   package OAuth;
    use Moose;
    with 'Net::Douban::OAuth';
}


my $oauth = OAuth->new();
isa_ok($oauth, 'OAuth');
isa_ok($oauth->ua, 'LWP::UserAgent');


