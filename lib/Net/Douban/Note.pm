package Net::Douban::Note;

use Moose;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'noteID' => (
    is  => 'rw',
    isa => 'Str',
);

has 'note_url' => (
	is	=> 'rw',
	isa => 'Str',
	lazy => 1,
	default => sub { shift->base_url . '/note'},
);

sub get_note {
    my ($self, %args) = @_;
    $args{noteID} ||= $self->noteID;
    return Net::Douban::Atom->new(
        $self->get($self->note_url . "/$args{noteID}"));
}

sub get_user_note {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/notes", %args));
}

sub delete_note {
    my ($self, %args) = @_;
    $args{noteID} ||= $self->noteID;
    return $self->delete($self->note_url . "/$args{noteID}");
}

sub post_note {
    my ($self, %args) = @_;
    croak 'post xml needed' unless exists $args{xml};
    return $self->post($self->note_url . "s", $args{xml});
}

sub put_note {
    my ($self, %args) = @_;
    croak 'put xml needed' unless exists $args{xml};
    $args{noteID} ||= $self->noteID;
    return $self->put($self->note_url . "/$args{noteID}", $args{xml});
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__
