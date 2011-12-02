package Net::Douban::Recommendation;

use Moose::Role;
use Carp qw/carp croak/;
use namespace::autoclean;
use Net::Douban::Utils;

our %api_hash = (
    get_recom => {
        path => '/recommendation/{recomID}',
        has_url_param => 1,
        method => 'GET',
    },

    get_user_recom => {
        path => '/people/{userID}/recommendations',
        has_url_param => 1,
        method => 'GET',
    },

    get_recom_comments => {
        path => '/recommendation/{recomID}/comments',
        has_url_param => 1,
        method => 'GET',
    },

    post_recom => {
        path => '/recommendations',
        method => 'POST',
        content_params => ['title', 'comment', 'link'],
        content => <<'EOF',
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4gPGVudHJ5IHhtbG5zPSJodHRw
Oi8vd3d3LnczLm9yZy8yMDA1L0F0b20iIHhtbG5zOmdkPSJodHRwOi8vc2NoZW1hcy5nb29nbGUu
Y29tL2cvMjAwNSIgeG1sbnM6b3BlbnNlYXJjaD0iaHR0cDovL2E5LmNvbS8tL3NwZWMvb3BlbnNl
YXJjaHJzcy8xLjAvIiB4bWxuczpkYj0iaHR0cDovL3d3dy5kb3ViYW4uY29tL3htbG5zLyI+IDx0
aXRsZT57dGl0bGV9PC90aXRsZT4gPGRiOmF0dHJpYnV0ZSBuYW1lPSJjb21tZW50Ij57Y29tbWVu
dH08L2RiOmF0dHJpYnV0ZT4gPGxpbmsgaHJlZj0ie2xpbmt9IiByZWw9InJlbGF0ZWQiIC8+PC9l
bnRyeT4gCg==
EOF
    },

    delete_recom => {
        path => '/recommendation/{recomID}',
        method => 'DELETE',
        has_url_param => 1,
    },

    post_comment => {
        path => '/recommendation/{recomID}/comments',
        method => 'POST',
        has_url_param => 1,
        content_params => ['content'],
        content => <<'EOF',
PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4gPGVudHJ5PiA8Y29udGVudD57
Y29udGVudH08L2NvbnRlbnQ+IDwvZW50cnk+IAo=
EOF
    },
    delete_comment => {
        path => '/recommendation/{recomID}/comment/{commentID}/',
        has_url_param => 1,
        method => 'DELETE',
    },
);

_build_method(__PACKAGE__, %api_hash);
1;

__END__

=pod

=head1 NAME

Net::Douban::Recommendation

=head1 SYNOPSIS

    my $c = Net::Douban->init(Roles => 'Recommendation');

=head1 DESCRIPTION

Interface to douban.com API Event section

=head1 METHODS

=over

=item B<get_recom>

argument:   recomID

=item B<get_user_recom>

argument:   userID 

=item B<get_recom_comments >

argument:   recomID 

=item B<post_recom>

arguments:  ['title', 'comment', 'link'],

=item B<delete_recom>

argument:   recomID 

=item B<post_comment>

argument:   recomID, content

=item B<delete_comment>

argument:   recomID, commentID

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Gift> L<Moose>
L<http://www.douban.com/service/apidoc/reference/recommendation>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 - 2011 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
