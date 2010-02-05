package Net::Douban::Roles;
our $VERSION = '0.41';

use Carp qw/carp croak/;
use Moose::Role;
use Scalar::Util qw/blessed/;

has 'oauth' => (
    is        => 'rw',
    predicate => 'has_oauth',
);

around 'oauth' => sub {
    my $orig = shift;
    my $self = shift;
    if (@_) {
        return $self->$orig(shift);
    } else {
        my $oauth = ${$self->$orig()};
        $oauth = ${$oauth} unless blessed $oauth;
        return $oauth;
    }
};

has 'ua' => (
    is      => 'rw',
    default => sub {
        eval { require LWP::UserAgent };
        croak $@ if $@;
        my $ua = LWP::UserAgent->new(
            agent      => 'perl-net-douban',
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
        if (defined $self->{$arg}) {
            $ret{$arg} = $self->{$arg};
        }
    }

    #	croak "api key needed" unless $self->apikey;
    return %ret;
}

no Moose::Role;
1;

__END__

=pod
=head1 NAME

    Net::Douban::Roles

=head1 VERSION

version 0.41

=cut
