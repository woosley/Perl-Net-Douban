package Net::Douban::Review;

use Moose;
use MooseX::StrictConstructor;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'reviewID' => (
    is  => 'rw',
    isa => 'Str',
);

has 'review_url' => (
    is      => 'rw',
    isa     => 'Url',
    lazy    => 1,
    default => sub { shift->base_url . '/review' }
);

sub get_review {
    my ($self, %args) = @_;
    $args{reviewID} ||= $self->reviewID;
    croak "reviewID missing" unless exists $args{reviewID};
    return Net::Douban::Atom->new(
        $self->get($self->review_url . "/$args{reviewID}"));
}

sub get_user_review {
    my ($self, %args) = @_;
    my $uid = delete $args{userID};
    croak "userID missing" unless defined $uid;
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/reviews", %args));
}

sub get_book_review {
    my ($self, %args) = @_;
    my $subjectID = delete $args{subjectID};
    my $isbnID    = delete $args{isbnID};
    my $url       = $self->base_url . "/book/subject";
    croak "Missing parameters: isbnID or subjectID needed"
      unless defined $subjectID
          or defined $isbnID;
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
    croak "Missing parameters: imdbID or subjectID needed"
      unless defined $subjectID
          or defined $imdbID;
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
    croak "Missing parameters:  subjectID needed"
      unless defined $subjectID;
    return Net::Douban::Atom->new(
        $self->get(
            $self->base_url . "/music/subject/$subjectID/reviews", %args
        )
    );
}

sub post_review {
    my ($self, %args) = @_;
    croak "post xml needed!" unless $args{xml};
    return $self->post($self->review_url . 's', xml => $args{xml},);
}

sub delete_review {
    my ($self, %args) = @_;
    $args{reviewID} ||= $self->reviewID;
    croak "reviewID missing" unless $args{reviewID};
    return $self->delete($self->review_url . "/$args{reviewID}",);
}

sub put_review {
    my ($self, %args) = @_;
    $args{reviewID} ||= $self->reviewID;
    croak "reviewID missing" unless $args{reviewID};
    croak "put xml needed!" unless $args{xml};
    return $self->put($self->review_url . "/$args{reviewID}", xml => $args{xml});
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Douban::Review

=head1 SYNOPSIS

	use Net::Douban::Review;
	my $user = Net::Douban::Review->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $user->get_review(reviewID => 1138468);
    $atom = $user->get_user_review(userID => '2265138', start_index => 5, max_results => 10);

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
