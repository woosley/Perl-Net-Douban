package Net::Douban::Doumail;
our $VERSION = '0.41';

use Moose;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'doumailID' => (
    is  => 'rw',
    isa => 'Str',
);

sub inbox {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/inbox", %args));
}

sub unread {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/inbox/unread", %args));
}

sub outbox {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/outbox", %args));
}

sub get_doumail {
    my ($self, %args) = @_;
    $args{doumailID} ||= $self->doumailID;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/$args{doumailID}", %args));
}

sub post_doumail {
    my ($self, %args) = @_;
    croak "post xml needed!" unless $args{xml};
    return $self->post($self->doumail_url . 's', $args{xml},);
}

sub delete_doumail {
    my ($self, %args) = @_;
    $args{doumailID} ||= $self->doumailID;
    return $self->delete($self->doumail_url . "/$args{doumailID}",);
}

sub mark_read {
    my ($self, %args) = @_;
    $args{doumailID} ||= $self->doumailID;
    croak "post xml needed!" unless $args{xml};
    return $self->put($self->doumail_url . "/$args{doumailID}", $args{xml},);
}

sub delete {
    my ($self, %args) = @_;
    croak "post xml needed!" unless $args{xml};
    return $self->delete($self->doumail_url, $args{xml});
}

sub mark {
    my ($self, %args) = @_;
    croak "post xml needed!" unless $args{xml};
    return $self->put($self->doumail_url . '/delete', $args{xml},);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

=pod
=head1 NAME

    Net::Douban::Collection;

=head1 VERSION

version 0.41

=cut
