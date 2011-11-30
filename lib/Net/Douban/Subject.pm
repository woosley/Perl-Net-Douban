package Net::Douban::Subject;

use Moose::Role;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
use namespace::autoclean;
requires '_build_method';

our %api_hash = (
    get_book => {
        path => ['/book/subject/{subjectID}', '/book/subject/isbn/{isbnID}'],
        has_url_param => 1,
        method        => 'GET',
    },
    get_movie => {
        path =>
          ['/movie/subject/{subjectID}', '/movie/subject/imdb/{imdbID}'],
        has_url_param => 1,
        method        => 'GET',
    },
    get_music => {
        path          => '/music/subject/{subjectID}',
        has_url_param => 1,
        method        => 'GET',
    },
    search_music => {
        path   => '/music/subjects',
        params => ['q', 'tag'],
        method => 'GET',
    },
    search_movie => {
        path   => '/movie/subjects',
        params => ['q', 'tag'],
        method => 'GET',
    },
    search_book => {
        path   => '/book/subjects',
        params => ['q', 'tag'],
        method => 'GET',
    },
);

__PACKAGE__->_build_method(%api_hash);
1;
__END__

=pod

=head1 NAME

Net::Douban::Subject

=head1 SYNOPSIS

	use Net::Douban::Subject;
	my $subject = Net::Douban::Subject->new(
        subjectID => 2023013,
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $subject->get_book(isbnID => 7543639103);
    $atom = $subject->search_book(tag => 'cowboy', start_index => 5, max_results => 10);

=head1 DESCRIPTION

Interface to douban.com API Subject section

=head1 METHODS

Those methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_book>

=item B<get_movie>

=item B<get_music>

=item B<search_book>

parameter q(keyword) or tag needed for the search methods

=item B<search_music>

=item B<search_movie>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/subject>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
