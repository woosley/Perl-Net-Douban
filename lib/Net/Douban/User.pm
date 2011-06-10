package Net::Douban::User;
use Moose;
use namespace::autoclean;
with 'Net::Douban::Roles';
use Carp qw/carp croak/;
use MooseX::StrictConstructor;

has 'userID' => (is => 'rw', isa => 'Str',);

our %api_hash = (
    get_user => {
        url_param => 'userID',
        path      => '/people/{userID}',
        method    => 'GET'
    },
    get_contacts => {
        url_param => 'userID',
        path      => '/people/{userID}/contacts',
        method    => 'GET',
    },
    get_friends => {
        url_param => 'userID',
        path      => '/people/{userID}/friends',
        method    => 'GET',
    },
    search_user => {param => 'q', path => '/people/', method => 'GET'},
    me => {path => '/people/%40me', method => 'GET'},
);

__PACKAGE__->_build_method(%api_hash);
__PACKAGE__->meta->make_immutable;
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
