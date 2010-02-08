package Net::Douban::Tag;
our $VERSION = '1.03';

use Moose;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

sub get_movie_tag {
    my ($self, %args) = @_;
    croak "subjectID needed" unless exists $args{subjectID};
    return Net::Douban::Atom->new(
        $self->get($self->base_url . "/movie/subject/$args{subjectID}/tags"));
}

sub get_book_tag {
    my ($self, %args) = @_;
    croak "subjectID needed" unless exists $args{subjectID};
    return Net::Douban::Atom->new(
        $self->get($self->base_url . "/book/subject/$args{subjectID}/tags"));
}

sub get_music_tag {
    my ($self, %args) = @_;
    croak "subjectID needed" unless exists $args{subjectID};
    return Net::Douban::Atom->new(
        $self->get($self->base_url . "/music/subject/$args{subjectID}/tags"));
}

sub get_tag {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    croak "cat needed" unless exists $args{cat};
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$args{userID}/tags", %args));
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=pod

=head1 NAME

    Net::Douban::Tag

=head1 VERSION

version 1.03

=cut
