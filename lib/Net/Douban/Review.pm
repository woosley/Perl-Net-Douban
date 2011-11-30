package Net::Douban::Review;

use Moose::Role;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
use namespace::autoclean;
requires '_build_method';

our %api_hash = (
    get_review => {
        path          => '/review/{reviewID}',
        has_url_param => 1,
        method        => 'GET',
    },
    get_user_review => {
        path          => '/people/{userID}/reviews',
        method        => 'GET',
        has_url_param => 1,
    },
    get_movie_review => {
        path => [
            '/movie/subject/{subjectID}/reviews',
            '/movie/subject/imdb/{imdbID}/reviews'
        ],
        has_url_param => 1,
        method        => 'GET',
    },
    get_book_review => {
        path => [
            '/book/subject/{subjectID}/reviews',
            '/book/subject/isbn/{isbn}/reviews'
        ],
        has_url_param => 1,
        method        => 'GET',
    },
    get_music_review => {
        path          => '/music/subject/{subjectID}/reviews',
        has_url_param => 1,
        method        => 'GET',
    },
    post_review => {
        path           => '/reviews',
        method         => 'POST',
        content_params => ['subjectID', 'content', 'rating', 'title'],
        content        => <<'EOF',
PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4gPGVudHJ5IHhtbG5zOm5zMD0i
aHR0cDovL3d3dy53My5vcmcvMjAwNS9BdG9tIj4gPGRiOnN1YmplY3QgeG1sbnM6ZGI9Imh0dHA6
Ly93d3cuZG91YmFuLmNvbS94bWxucy8iPiA8aWQ+aHR0cDovL2FwaS5kb3ViYW4uY29tL21vdmll
L3N1YmplY3Qve3N1YmplY3RJRH08L2lkPiA8L2RiOnN1YmplY3Q+IDxjb250ZW50Pntjb250ZW50
fTwvY29udGVudD4gPGdkOnJhdGluZyB4bWxuczpnZD0iaHR0cDovL3NjaGVtYXMuZ29vZ2xlLmNv
bS9nLzIwMDUiIHZhbHVlPSJ7cmF0aW5nfSIgPjwvZ2Q6cmF0aW5nPiA8dGl0bGU+e3RpdGxlfTwv
dGl0bGU+PC9lbnRyeT4K
EOF
    },

    put_review => {
        path          => '/reviews/{reviewID}',
        method        => 'POST',
        has_url_param => 1,
        content_params =>
          ['subjectID', 'reviewID', 'title', 'content', 'rating'],
        content => <<'EOF',
PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz48ZW50cnkgeG1sbnM6bnMwPSJo
dHRwOi8vd3d3LnczLm9yZy8yMDA1L0F0b20iPjxpZD5odHRwOi8vYXBpLmRvdWJhbi5jb20vcmV2
aWV3L3tyZXZpZXdJRH08L2lkPjxkYjpzdWJqZWN0IHhtbG5zOmRiPSJodHRwOi8vd3d3LmRvdWJh
bi5jb20veG1sbnMvIj48aWQ+aHR0cDovL2FwaS5kb3ViYW4uY29tL21vdmllL3N1YmplY3Qve3N1
YmplY3RJRH08L2lkPjwvZGI6c3ViamVjdD48Y29udGVudD57Y29udGVudH08L2NvbnRlbnQ+IDxn
ZDpyYXRpbmcgeG1sbnM6Z2Q9Imh0dHA6Ly9zY2hlbWFzLmdvb2dsZS5jb20vZy8yMDA1IiB2YWx1
ZT0ie3JhdGluZ30iID48L2dkOnJhdGluZz4gPHRpdGxlPnt0aXRsZX08L3RpdGxlPjwvZW50cnk+
Cg==
EOF
    },

    delete_review => {
        path          => '/reviews/{reviewID}',
        method        => 'DELETE',
        has_url_param => 1,
    },
);

__PACKAGE__->_build_method(%api_hash);
1;

__END__

=pod

=head1 NAME

Net::Douban::Review

=head1 SYNOPSIS

	use Net::Douban::Review;
	my $review = Net::Douban::Review->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $review->get_review(reviewID => 1138468);
    $atom = $review->get_user_review(userID => '2265138', start_index => 5, max_results => 10);

=head1 DESCRIPTION

Interface to douban.com API Review section

=head1 METHODS

Those get methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_review>

=item B<get_user_review>

userID required

=item B<get_book_review>

=item B<get_moview_review>

=item B<get_music_review>

=item B<post_review>

post XML required

=item B<put_review>

modify your review, reviewID and put XML required

=item B<delete_review>

reviewID required

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/review>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
