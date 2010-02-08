package Net::Douban::Review;
our $VERSION = '1.02';

use Moose;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'reviewID' => (
    is  => 'rw',
    isa => 'Str',
);

sub get_review {
    my ($self, %args) = @_;
    $args{reviewID} ||= $self->reviewID;
    return Net::Douban::Atom->new(
        $self->get($self->review_url . "/$args{reviewID}"));
}

sub get_user_review {
    my ($self, %args) = @_;
    my $uid = delete $args{userID};
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/reviews", %args));
}

sub get_book_review {
    my ($self, %args) = @_;
    my $subjectID = delete $args{subjectID};
    my $isbnID    = delete $args{isbnID};
    my $url       = $self->base_url . "/book/subject";
    if ($isbnID) {
        $url .= "/isbn/$isbnID/reviews";
    } else {
        $url .= "/$subjectID/reviews";
    }
    return Net::Douban::Atom->new($self->get($url, %args));
}

sub get_movie_review {
    my ($self, %args) = @_;
    my $subjectID = delete $args{subjectID};
    my $imdbID    = delete $args{imdbID};
    my $url       = $self->base_url . "/movie/subject";
    if ($imdbID) {
        $url .= "/imdb/$imdbID/reviews";
    } else {
        $url .= "/$subjectID/reviews";
    }
    return Net::Douban::Atom->new($self->get($url, %args));
}

sub get_music_review {
    my ($self, %args) = @_;
    my $subjectID = delete $args{subjectID};
    return Net::Douban::Atom->new(
        $self->get(
            $self->base_url . "/music/subject/$subjectID/reviews", %args
        )
    );
}

sub post_review {
    my ($self, %args) = @_;
    croak "post xml needed!" unless $args{xml};
    return $self->post($self->review_url, $args{xml},);
}

sub delete_review {
    my ($self, %args) = @_;
    $args{reviewID} ||= $self->reviewID;
    return $self->delete($self->review_url . "/$args{reviewID}",);
}

sub put_review {
    my ($self, %args) = @_;
    $args{reviewID} ||= $self->reviewID;
    croak "put xml needed!" unless $args{xml};
    return $self->put($self->reviewID . "/$args{reviewID}", $args{xml});
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod
=head1 NAME

    Net::Douban::Review

=head1 VERSION

version 1.02

=cut
