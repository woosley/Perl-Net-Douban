package Net::Douban::Subject;

use Moose::Role;
use Carp qw/carp croak/;
use namespace::autoclean;
use Net::Douban::Utils;

douban_method get_book => {
    path => ['/book/subject/{subjectID}', '/book/subject/isbn/{isbnID}'],
    has_url_param => 1,
    method        => 'GET',
};
douban_method get_movie => {
    path => ['/movie/subject/{subjectID}', '/movie/subject/imdb/{imdbID}'],
    has_url_param => 1,
    method        => 'GET',
};
douban_method get_music => {
    path          => '/music/subject/{subjectID}',
    has_url_param => 1,
    method        => 'GET',
};
douban_method search_music => {
    path            => '/music/subjects',
    optional_params => [qw/start-index max-results/],
    params          => ['q', 'tag'],
    method          => 'GET',
};
douban_method search_movie => {
    path            => '/movie/subjects',
    params          => ['q', 'tag'],
    optional_params => [qw/start-index max-results/],
    method          => 'GET',
};
douban_method search_book => {
    path            => '/book/subjects',
    optional_params => [qw/start-index max-results/],
    params          => ['q', 'tag'],
    method          => 'GET',
};
1;
__END__

=pod

=head1 NAME

Net::Douban::Subject

=head1 SYNOPSIS

	my $c = Net::Douban->init(Roles => 'Subject');

=head1 DESCRIPTION

Interface to douban.com API Subject section

=head1 METHODS

=over

=item B<get_book>

argument:   subjectID | isbnID 

=item B<get_movie>

argument:   subjectID | imdbID

=item B<get_music>

argument:   subjectID

=item B<search_book>

argument: q, tag

=item B<search_music>

argument: q, tag

=item B<search_movie>

argument: q, tag

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Traits::Gift> L<Moose> 
B<http://www.douban.com/service/apidoc/reference/subject>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 - 2011 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
