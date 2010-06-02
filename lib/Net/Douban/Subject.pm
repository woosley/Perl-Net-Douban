package Net::Douban::Subject;

use Moose;
use MooseX::StrictConstructor;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'subjectID' => (is => 'rw', isa => 'Str');

has 'subject_url' => (
    is      => 'rw',
    isa     => 'Url',
    lazy    => 1,
    default => sub { shift->base_url . '/subject' },
);

before qw/search_book search_music search_movie/ => sub {
    my ($self, %args) = @_;
    if (!exists $args{q} && !exists $args{tag}) {
        croak "Missing parameters: tag or q needed";
    }
};

sub get_book {
    my ($self, %args) = @_;
    my $url = $self->base_url;

    if (exists $args{isbnID}) {
        $url .= "/book/subject/isbn/$args{isbnID}";
    } elsif (exists $args{subjectID}) {
        $url .= "/book/subject/$args{subjectID}";
    } else {
        $self->subjectID or croak "SubjectID or isbnID missing";
        $url .= "/book/subject/" . $self->subjectID;
    }

    return Net::Douban::Atom->new($self->get($url));
}

sub get_movie {
    my ($self, %args) = @_;
    my $url = $self->base_url;

    if (exists $args{imdbID}) {
        $url .= "/movie/subject/imdb/$args{imdbID}";
    } elsif (exists $args{subjectID}) {
        $url .= "/movie/subject/$args{subjectID}";
    } else {
        $self->subjectID or croak "imdbID or subjectID missing";
        $url .= "/movie/subject/" . $self->subjectID;
    }

    return Net::Douban::Atom->new($self->get($url));
}

sub get_music {
    my ($self, %args) = @_;
    $args{subjectID} ||= $self->subjectID;
    croak "subjectID missing" unless $args{subjectID};
    return Net::Douban::Atom->new(
        $self->get($self->base_url . "/music/subject/$args{subjectID}"));
}

sub search_music {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->base_url . "/music/subjects", %args));
}

sub search_book {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->base_url . "/book/subjects", %args));
}

sub search_movie {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->base_url . "/movie/subjects", %args));
}

no Moose;
__PACKAGE__->meta->make_immutable;
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
