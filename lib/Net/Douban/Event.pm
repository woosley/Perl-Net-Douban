package Net::Douban::Event;

use Moose::Role;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
requires '_build_method';
use namespace::autoclean;

our %api_hash = (
    get_event => {
        path => '/event/{eventID}',
        has_url_param => 1,
        method => 'GET',
    },

    get_event_participants => {
        path => '/event/{eventID}/participants',
        has_url_param => 1,
        method => 'GET',
    },

    get_event_wishers => {
        path => '/event/{eventID}/wishers',
        has_url_param => 1,
        method => 'GET',
    },

    get_user_events => {
        path => '/people/{userID}/events',
        has_url_param => 1,
        method => 'GET',
    },

    get_user_participates => {
        path => '/people/{userID}/events/participate',
        has_url_param => 1,
        method => 'GET',
    },

    get_user_wishes => {
        path => '/people/{userID}/events/wish',
        has_url_param => 1,
        method => 'GET',
    },

    get_user_initiates => {
        path => '/people/{userID}/events/initiate',
        has_url_param => 1,
        method => 'GET',
    },

    get_location_events => {
        path => '/event/location/{locationID}',
        has_url_param => 1,
        optional_params => ['type'],
        method => 'GET',
    },

    search_events => {
        path => '/events',
        params => ['q', 'location'],
        method => 'GET',
    },

# nothing but stupid to do post  
#   post_event => {
#        path => '/events',
#        method => 'POST',
#        stupid => 1,
#    },
    
    post_event_participant => {
        path => '/event/{eventID}/participants',
        method => 'POST',
        has_url_param => 1,
    },
    
    post_event_wisher => {
        path => '/event/{eventID}/wishers',
        method => 'POST',
        has_url_param => 1,
    },

    delete_event_paticipant => {
        path => '/event/{eventID}/participants',
        method => 'DELETE',
        has_url_param => 1,
    },

    delete_event_wisher => {
        path => '/event/{eventID}/wishers',
        method => 'DELETE',
        has_url_param => 1,
    },
);


__PACKAGE__->_build_method(%api_hash);
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
