package Net::Douban::Roles;
our $VERSION = '0.07';

use Any::Moose 'Role';
use LWP::UserAgent;

#use Moose::Role;

has 'oauth' => (
    is        => 'rw',
    isa       => 'OAuth::Lite::Consumer|Undef',
    predicate => 'has_oauth',
);

has 'token' => (
    is        => 'rw',
    predicate => 'has_token',
);

has 'ua' => (
    is      => 'rw',
    isa     => 'LWP::UserAgent',
    default => sub {
        my $ua = LWP::UserAgent->new(
            agent      => 'Perl-Net-Douban',
            cookie_jar => {},
            keep_alive => 4,
            timeout    => 60,
        );
        return $ua;
    }
);

has 'apikey' => (
    is  => 'rw',
    isa => 'Str',
);

has 'private_key' => (
    is  => 'rw',
    isa => 'Str',
);

has 'start-index' => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);

has 'max-results' => (
    is      => 'rw',
    isa     => 'Int',
    default => 10,
);

sub args {
    my $self = shift;
    my %ret;
    for my $arg (qw/ ua apikey start-index max-result oauth/) {
        $ret{$arg} = $self->{$arg};
    }
    return %ret;
}

no Any::Moose;
1;
__END__
