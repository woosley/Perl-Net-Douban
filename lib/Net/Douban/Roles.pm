package Net::Douban::Roles;
our $VERSION = '1.02';

use Carp qw/carp croak/;
use Moose::Role;
use Scalar::Util qw/blessed/;

has 'oauth' => (is => 'rw');

#around 'oauth'  => sub {
#    my $orig = shift;
#    my $self = shift;
#    if (@_) {
#        $self->$orig(shift);
#    }else{
#        my $oauth = $self->$orig;
#        $oauth = ${$oauth} unless blessed $oauth;
#        return $oauth;
#    }
#};

has 'ua' => (
    is         => 'rw',
    lazy_build => 1,
);

sub _build_ua {
    eval { require LWP::UserAgent };
    die $@ if $@;
    my $ua = LWP::UserAgent->new(
        agent        => 'perl-net-douban-',
        timeout      => 30,
        max_redirect => 5
    );
    $ua->env_proxy;
    $ua;
}

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
    for my $arg (qw/ ua apikey start-index max-results oauth/) {
        if (defined $self->$arg) {
            $ret{$arg} = $self->$arg;
        }
    }

    #	croak "api key needed" unless $self->apikey;
    return %ret;
}

#around 'BUILDARGS' => sub {
#    my $orig = shift;
#    my $self = shift;
#    my %args = @_;
#    unless ($args{oauth} || $args{apikey}){
#        croak "oauth or apikey needed";
#    }
#}

no Moose::Role;
1;

__END__

=pod
=head1 NAME

    Net::Douban::Roles

=head1 VERSION

version 1.02

=cut
