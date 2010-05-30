package Net::Douban::Event;

use Moose;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
use Net::Douban::Atom;
with 'Net::Douban::Roles::More';

has 'eventID' => (
    is  => 'rw',
    isa => 'Str',
);

has 'event_url' => (
    is      => 'rw',
    isa     => 'Url',
    lazy    => 1,
    default => sub { shift->base_url . '/event' },
);

sub get_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    croak "eventID need!" unless exists $args{eventID};
    return Net::Douban::Atom->new(
        $self->get($self->event_url . "/$args{eventID}"));
}

sub get_event_wishers {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    croak "eventID need!" unless exists $args{eventID};
    return Net::Douban::Atom->new(
        $self->get($self->event_url . "/$args{eventID}/wishers"));
}

sub get_event_participants {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    croak "eventID need!" unless exists $args{eventID};
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

sub get_user_events {
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
    return $self->post($self->event_url . "s", xml => $args{xml});
}

sub put_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    croak "eventID need!" unless exists $args{eventID};
    croak "post xml needed!" unless exists $args{xml};
    return $self->put($self->event_url . "/$args{eventID}", xml => $args{xml});
}

sub join_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return $self->post($self->event_url . "/$args{eventID}/participants");
}

sub wish_event {
    my ($self, %args) = @_;
    $args{eventID} ||= $self->eventID;
    return $self->post($self->event_url . "/$args{eventID}/wishers");
}

sub delete_event {
    my ($self, %args) = @_;
    croak "post xml needed" unless exists $args{xml};
    $args{eventID} ||= $self->eventID;
    return $self->post($self->event_url . "/$args{eventID}/delete",
        xml => $args{xml});
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

__END__

=pod

=head1 NAME

Net::Douban::Event

=head1 SYNOPSIS

	use Net::Douban::Event;
	my $event = Net::Douban::Event->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $event->get_event;
	$atom = $event->get_event_wishers;
    $atom = $event->search(q => 'douban', locationID => 'all', start_index => 5, max_results => 10);

=head1 DESCRIPTION

Interface to douban.com API Event section

=head1 METHODS

Most of the get methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_event>

=item B<get_event_wishers>

=item B<get_event_participants>

=item B<get_user_participants>

=item B<get_user_wish>

=item B<get_user_event>

=item B<get_city_events>

=item B<search>

=item B<post_event>

=item B<join_event>

=item B<put_event>

=item B<wish_event>

=item B<delete_event>

=item B<leave_event>

=item B<quit_event>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/event>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
