package Net::Douban::Recommendation;

use Moose::Role;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
requires '_build_method';
use namespace::autoclean;

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

__PACKAGE__->_build_method(%api_hash);
1;

__END__

=pod

=head1 NAME

Net::Douban::Recommendation

=head1 SYNOPSIS

	use Net::Douban::Recommendation;
	my $recom = Net::Douban::Recommendation->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $recom->get_recom(recomID => ...);
	$atom = $event->get_user_recom(userID => ...);

=head1 DESCRIPTION

Interface to douban.com API Event section

=head1 METHODS

Most of the get methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_recom>

=item B<get_comments>

=item B<get_user_recom>

=item B<post_recom>

=item B<delete_recom>

=item B<post_comment>

=item B<delete_comment>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/recommendation>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
