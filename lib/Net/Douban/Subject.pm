package Net::Douban::Subject;
our $VERSION = '1.02';

use Moose;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'subjectID' => (is => 'rw', isa => 'Str');

sub get_book {
    my ($self, %args) = @_;
    my $url = $self->base_url;

    if (exists $args{isbn}) {
        $url .= "/book/subject/isbn/$args{isbn}";
    } elsif (exists $args{subjectID}) {
        $url .= "/book/subject/$args{subjectID}";
    } else {
        $self->subjectID or croak "Not enough parameter";
        $url .= "/book/subject/" . $self->subjectID;
    }

    return Net::Douban::Atom->new($self->get($url));
}

sub get_movie {
    my ($self, %args) = @_;
    my $url = $self->base_url;

    if (exists $args{imdb}) {
        $url .= "/movie/subject/isbn/$args{imdb}";
    } elsif (exists $args{subjectID}) {
        $url .= "/movie/subject/$args{subjectID}";
    } else {
        $self->subjectID or croak "Not enough parameter";
        $url .= "/movie/subject/" . $self->subjectID;
    }

    return Net::Douban::Atom->new($self->get($url));
}

sub get_music {
    my ($self, %args) = @_;
    $args{subjectID} ||= $self->subjectID;
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

=head1 VERSION

version 1.02

=cut
