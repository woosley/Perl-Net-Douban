package Net::Douban::Miniblog;
our $VERSION = '1.03';

use Moose;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'miniblogID' => (
    is  => 'rw',
    isa => 'Str',
);

sub get_user_miniblog {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/miniblog", %args));
}

sub get_contact_miniblog {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/miniblog/contacts", %args));
}

sub post_saying {
    my ($self, %args) = @_;
    croak "post xml needed!" unless exists $args{xml};
    return $self->post($self->miniblog_url . "/saying", %args);
}

sub delete_miniblog {
    my ($self, %args) = @_;
    $args{miniblogID} ||= $self->miniblogID;
    return $self->delete($self->miniblog_url . "/$args{miniblogID}");
}

sub get_miniblog {
    my ($self, %args) = @_;
    $args{miniblogID} ||= $self->miniblogID;
    return Net::Douban::Atom->new(
        $self->get($self->miniblog_url . "/$args{miniblogID}"));
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

=pod
=head1 NAME

    Net::Douban::Collection;

=head1 VERSION

version 1.03

=cut
