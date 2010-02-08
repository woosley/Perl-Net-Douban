package Net::Douban::Event;
our $VERSION = '1.03';

use Moose;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'eventID' => (
    is  => 'rw',
    isa => 'Str',
);

sub get_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return Net::Douban::Atom->new(
        $self->get($self->event_url . "/$args{eventID}"));
}

sub get_event_wishers {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return Net::Douban::Atom->new(
        $self->get($self->event_url . "/$args{eventID}/wishers"));
}

sub get_event_participants {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return Net::Douban::Atom->new(
        $self->get($self->event_url . "/$args{eventID}/participants"));
}

sub get_user_participate {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/events/participate", %args));
}

sub get_user_initiate {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/events/initiate", %args));
}

sub get_user_wish {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/events/wish", %args));
}

sub get_user_event {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/events", %args));
}

sub get_city_events {
    my ($self, %args) = @_;
    my $locationID = delete $args{locationID} or croak "LocationID needed!";
    return Net::Douban::Atom->new(
        $self->get($self->event_url . "/location/$locationID", %args));
}

sub search {
    my ($self, %args) = @_;
    croak "locationID needed!" unless exists $args{locationID};
    return Net::Douban::Atom->new($self->get($self->event_url . "s", %args));
}

sub post_event {
    my ($self, %args) = @_;
    croak "post xml needed!" unless exists $args{xml};
    return $self->post($self->event_url . "s", $args{xml});
}

sub put_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    croak "post xml needed!" unless exists $args{xml};
    return $self->put($self->event_url . "/$args{eventID}", $args{xml});
}

sub join_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return $self->post($self->event_url . "$args{eventID}/participants");
}

sub wish_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return $self->post($self->event_url . "$args{eventID}/wishers");
}

sub delete_event {
    my ($self, %args) = @_;
    croak "post xml needed" unless exists $args{xml};
    $args{eventID} ||= $self->eventID;
    return $self->post($self->event_url . "/$args{eventID}/delete",
        $args{xml});
}

sub leave_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return $self->delete($self->event_url . "/$args{eventID}/participants");
}

sub quit_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return $self->delete($self->event_url . "/$args{eventID}/wishers");
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
