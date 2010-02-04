package Net::Douban::Token;
our $VERSION = '0.23';

use Moose;
use Env qw/HOME/;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'instance' => (
    is       => 'rw',
    isa      => 'Net::Douban',
    required => 1,
);

sub check {
    my ($self, %args) = @_;
    $args{token} ||= $self->token;
    my $return = eval { $self->get($self->token_url . "/$args{token}"); };
    if ($@) {
        return $@ if $@ =~ /unauthorized/i;
        print $@;
        exit;
    } else {
        return $return;
    }
}

sub delete {
    my ($self, %args) = @_;
    $args{token} ||= $self->token;
    $self->delete($self->token_url . "/$args{token}");
}

sub store_token {
    my ($self, $file) = @_;
    croak "No oauth token found!" unless $self->token && $self->oauth;
    $file ||= $HOME . "./.doubanToken";
    my $token = {
        consumer => $self->oauth,
        token    => $self->token,
    };
    store $token, $file;
}

sub load_token {
    my ($self, $file) = @_;
    $file ||= $HOME . "./.doubanToken";
    my $token = retrieve $file;
    $self->instance->oauth($token->{consumer});
    $self->instance->token($token->{token});
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=pod
=head1 NAME

    Net::Douban::Token

=head1 VERSION

version 0.23

=cut
