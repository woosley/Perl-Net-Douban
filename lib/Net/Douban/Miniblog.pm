package Net::Douban::Miniblog;

use Moose::Role;
use Carp qw/carp croak/;
use namespace::autoclean;
use Net::Douban::Utils;

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

_build_method(__PACKAGE__, %api_hash);
1;

__END__

=pod

=head1 NAME

Net::Douban::Miniblog

=head1 SYNOPSIS

    my $c = Net::Douban->init(Roles => 'Miniblog');

=head1 DESCRIPTION

Interface to douban.com API Miniblog section

=head1 METHODS

=over

=item B<get_user_miniblog>

argument:   userID

=item B<get_contact_miniblog>

argument:   userID

=item B<post_miniblog>

argument:   content 

=item B<delete_miniblog>

argument:   miniblogID 

=item B<get_miniblog_comments>

argument:   miniblogID 

=item B<post_miniblog_comment>

argument:  ['miniblogID', 'content']

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
