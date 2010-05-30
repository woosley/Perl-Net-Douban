package Net::Douban::Note;

use Moose;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
use Net::Douban::Atom;

with 'Net::Douban::Roles::More';

has 'noteID' => (
    is  => 'rw',
    isa => 'Str',
);

has 'note_url' => (
	is	=> 'rw',
	isa => 'Url',
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
    return $self->post($self->note_url . "s", xml => $args{xml});
}

sub put_note {
    my ($self, %args) = @_;
    croak 'put xml needed' unless exists $args{xml};
    $args{noteID} ||= $self->noteID;
    return $self->put($self->note_url . "/$args{noteID}", xml => $args{xml});
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Douban::Note

=head1 SYNOPSIS

	use Net::Douban::Note;
	$note = Net::Douban::Note->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $note->get_note(noteID => ... ) 
	$atom = $note->get_user_note(userID => 'Net-Douban');
	$atom = $note->post_note(xml => $xml);

=head1 DESCRIPTION

Interface to douban.com API Note section

=head1 METHODS

Those methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_user>

=item B<get_user_note>

=item B<delet_note>

=item B<post_note>

=item B<put_note>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/note>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
