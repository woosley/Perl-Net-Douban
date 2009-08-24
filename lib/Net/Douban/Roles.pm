package Net::Douban::Roles;
our $VERSION = '0.17';

use Carp qw/carp croak/;
use Any::Moose 'Role';
use LWP::UserAgent;

#use Moose::Role;
#use Smart::Comments;

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
    for my $arg (qw/ ua apikey start-index max-results oauth token/) {
        if ( defined $self->{$arg} ) {
            $ret{$arg} = $self->{$arg};
        }
    }

    #	croak "api key needed" unless $self->apikey;
    return %ret;
}

no Any::Moose;
1;
__END__
