package Net::Douban::User;

use Moose::Role;
use Carp qw/carp croak/;
use Net::Douban::Utils;
use namespace::autoclean;

our %api_hash = (
    get_user => {
        has_url_param => 'userID',
        path      => '/people/{userID}',
        method    => 'GET'
    },
    get_user_contacts => {
        has_url_param => 'userID',
        path      => '/people/{userID}/contacts',
        method    => 'GET',
    },
    get_user_friends => {
        has_url_param => 'userID',
        path      => '/people/{userID}/friends',
        method    => 'GET',
    },
    search_user => {params => 'q', path => '/people', method => 'GET'},
    me => {path => '/people/%40me', method => 'GET'},
);

_build_method(__PACKAGE__, %api_hash);

1;

__END__

=pod

=head1 NAME

Net::Douban::User

=head1 SYNOPSIS

	use Net::Douban::User;
	my $user = Net::Douban::User->new(
		userID => 'Net-Douban',
		apikey => '....',
        # or
        oauth => $consumer,
	);
	$user->userID('abei');

	$atom = $user->get_user;
	$atom = $user->get_friends;
	$atom = $user->get_contacts;
    $atom = $user->search(q => 'douban', start_index => 5, max_results => 10);

=head1 DESCRIPTION

Interface to douban.com API User section

=head1 METHODS

Those methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_user>

=item B<get_contacts>

=item B<get_friends>

=item B<get_auth_user>

=item B<search>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/user>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
