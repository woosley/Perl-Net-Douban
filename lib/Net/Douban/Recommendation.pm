package Net::Douban::Recommendation;
our $VERSION = '1.02';

use Moose;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'recommendationID' => (
    is  => 'rw',
    isa => 'Str',
);

sub get_recommendation {
    my ($self, %args) = @_;
    $args{recommendationID} ||= $self->recommendationID;
    return Net::Douban::Atom->new(
        $self->get($self->recommendation_url . "/$args{recommendationID}"));
}

sub get_comments {
    my ($self, %args) = @_;
    $args{recommendationID} ||= $self->recommendationID;
    return Net::Douban::Atom->new(
        $self->get(
            $self->recommendation_url . "/$args{recommendationID}/comments"
        )
    );
}

sub get_user_recommendations {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/recommendations", %args));
}

sub post_recommendation {
    my ($self, %args) = @_;
    croak "post xml needed!" unless exists $args{xml};
    return $self->post($self->recommendation_url . "s", $args{xml});
}

sub delete_recommendation {
    my ($self, %args) = @_;
    $args{recommendationID} ||= $self->recommendationID;
    return $self->delete(
        $self->recommendation_url . "/$args{recommendationID}");
}

sub post_comment {
    my ($self, %args) = @_;
    croak "post xml needed!" unless exists $args{xml};
    $args{recommendationID} ||= $self->recommendationID;
    return $self->delete(
        $self->recommendation_url . "/$args{recommendationID}/comments");
}

sub delete_comment {
    my ($self, %args) = @_;
    croak "commentID needed!" unless exists $args{commentID};
    $args{recommendationID} ||= $self->recommendationID;
    return $self->delete($self->recommendation_url
          . "/$args{recommendationID}/comment/$args{commentID}");
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod
=head1 NAME

    Net::Douban::Recommendation;

=head1 VERSION

version 1.02

=cut
