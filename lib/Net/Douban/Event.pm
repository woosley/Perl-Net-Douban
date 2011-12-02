package Net::Douban::Event;

use Moose::Role;
use Carp qw/carp croak/;
use Net::Douban::Utils;
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


_build_method(__PACKAGE__, %api_hash);
1;

__END__

=pod

=head1 NAME

Net::Douban::Event

=head1 SYNOPSIS

	my $event = Net::Douban->init(Roles => 'Event');

=head1 DESCRIPTION

Interface to douban.com API Event section

=head1 METHODS

=over

=item B<get_event>

argument:   eventID

=item B<get_event_participants>

argument:   eventID

=item B<get_event_wishers>

argument:   eventID

=item B<get_user_events>

argument:   userID

=item B<get_user_wishes>

argument:   userID

=item B<get_user_participates>

argument:   userID

=item B<get_user_initiates>

argument:   userID

=item B<get_location_events>

argument:  locationID 

optional arguments: ['type'],

=item B<search_events>

argument:  [qw/q location/] 

=item B<post_event_wisher>

argument:   eventID

=item B<post_event_participant>

argument:   eventID

=item B<delete_event_wisher>

argument:   eventID

=item B<delete_event_paticipant>

argument:   eventID

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Gift> L<Moose>
L<http://www.douban.com/service/apidoc/reference/collection>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 - 2011 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
