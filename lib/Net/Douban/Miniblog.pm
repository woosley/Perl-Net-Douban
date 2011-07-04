package Net::Douban::Miniblog;

use Moose;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
with 'Net::Douban::Roles';
use namespace::autoclean;

our %api_hash = (
    get_user_miniblog => {
        has_url_param => 'userID',
        path          => '/people/{userID}/miniblog',
        method        => 'GET',
    },

    get_contact_miniblog => {
        has_url_param => 'userID',
        path          => '/people/{userID}/miniblog/contacts',
        method        => 'GET',
    },

    post_miniblog=> {
        path    => '/miniblog/saying',
        method  => 'POST',
        content_params => ['content'],
        content => <<'EOF',
PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4gPGVudHJ5IHhtbG5zOm5zMD0i
aHR0cDovL3d3dy53My5vcmcvMjAwNS9BdG9tIiB4bWxuczpkYj0iaHR0cDovL3d3dy5kb3ViYW4u
Y29tL3htbG5zLyI+IDxjb250ZW50Pntjb250ZW50fTwvY29udGVudD4gPC9lbnRyeT4K
EOF
    },

    delete_miniblog=> {
        has_url_param => 'miniblogID',
        path          => '/miniblog/{miniblogID}',
        method        => 'DELETE',
    },

    get_miniblog_comments => {
        has_url_param => 'miniblogID',
        path          => '/miniblog/{miniblogID}/comments',
        method        => 'POST',
    },

    post_miniblog_comment => {
        has_url_param => 'miniblogID',
        path          => '/miniblog/{miniblogID}/comments',
        method        => 'POST',
        content_params => ['content'],
        content       => <<'EOF',
PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4gPGVudHJ5PiA8Y29udGVudD57
Y29udGVudH08L2NvbnRlbnQ+IDwvZW50cnk+IAo=
EOF
    },
);

__PACKAGE__->_build_method(%api_hash);
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Douban::Miniblog

=head1 SYNOPSIS

	use Net::Douban::Miniblog;
	$miniblog = Net::Douban::Miniblog->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $miniblog->get_user_miniblog(userID => 'Net-Douban');
	$atom = $miniblog->get_contact_miniblog(userID => 'Net-Douban');

=head1 DESCRIPTION

Interface to douban.com API Miniblog section

=head1 METHODS

Those methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_user_miniblog>

=item B<get_contact_miniblog>

=item B<post_saying>

=item B<delete_miniblog>

=item B<get_reply>

=item B<post_reply>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/miniblog>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
