package Net::Douban::Collection;
our $VERSION = '1.03';

use Moose;
use Carp qw/carp croak/;
use Net::Douban::Atom;
with 'Net::Douban::Roles::More';

has 'collectionID' => (
    is  => 'rw',
    isa => 'Str',
);

sub get_collection {
    my ($self, %args) = @_;
    $args{collectionID} ||= $self->collectionID;
    return Net::Douban::Atom->new(
        $self->collection_url . "/$args{collectionID}");
}

sub get_user_collection {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed!";
    exists $args{cat} or croak "cat needed!";
    return Net::Douban::Atom->new($self->user_url . "/$uid/collection", %args,
    );
}

sub add_collection {
    my ($self, %args) = @_;
    croak "post xml needed" unless exists $args{xml};
    return $self->post($self->collection_url, $args{xml},);
}

sub put_collection {
    my ($self, %args) = @_;
    $args{collectionID} ||= $self->collectionID;
    croak "put xml needed" unless exists $args{xml};
    return $self->put($self->collection_url . "/$args{collectionID}",
        $args{xml},);
}

sub delete_collection {
    my ($self, %args) = @_;
    $args{collectionID} ||= $self->collectionID;
    return $self->delete($self->collection_url . "/$args{collectionID}");

}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

    Net::Douban::Collection

=head1 VERSION

version 1.03

=head1 SYNOPSIS

	use Net::Douban::Collection;
	my $user = Net::Douban::Collection->new(
        
		collectionID => '....',
        # or
        oauth => $consumer,
	);

=head1 DESCRIPTION

Interface to douban.com API collection section

=head1 METHODS

=over

=item B<get_collection>

=item B<get_user_collection>

=item B<add_collection>

=item B<put_collection>

=item B<delete_collection>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> L<http://douban.com/service/apidoc>

=head1 AUTHOR

woosley.xu<woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
