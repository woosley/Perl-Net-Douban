package Net::Douban::Doumail;
our $VERSION = '1.03';

use Moose;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'doumailID' => (
    is  => 'rw',
    isa => 'Str',
);

sub inbox {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/inbox", %args));
}

sub unread {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/inbox/unread", %args));
}

sub outbox {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/outbox", %args));
}

sub get_doumail {
    my ($self, %args) = @_;
    $args{doumailID} ||= $self->doumailID;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/$args{doumailID}", %args));
}

sub post_doumail {
    my ($self, %args) = @_;
    croak "post xml needed!" unless $args{xml};
    return $self->post($self->doumail_url . 's', $args{xml},);
}

sub delete_doumail {
    my ($self, %args) = @_;
    $args{doumailID} ||= $self->doumailID;
    return $self->delete($self->doumail_url . "/$args{doumailID}",);
}

sub mark_read {
    my ($self, %args) = @_;
    $args{doumailID} ||= $self->doumailID;
    croak "post xml needed!" unless $args{xml};
    return $self->put($self->doumail_url . "/$args{doumailID}", $args{xml},);
}

sub delete {
    my ($self, %args) = @_;
    croak "post xml needed!" unless $args{xml};
    return $self->delete($self->doumail_url, $args{xml});
}

sub mark {
    my ($self, %args) = @_;
    croak "post xml needed!" unless $args{xml};
    return $self->put($self->doumail_url . '/delete', $args{xml},);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

=pod
=head1 NAME

    Net::Douban::Collection;

=head1 VERSION

version 1.03

=head1 SYNOPSIS

	use Net::Douban::Doumail;
	my $user = Net::Douban::Doumail->new(
        ...
	);

=head1 DESCRIPTION

Interface to douban.com API  mail section

=head1 METHODS

=over

=item B<inbox>

=item B<unread>

=item B<outbox>

=item B<get_doumail>

=item B<post_doumail>

=item B<delete_doumail>

=item B<mark_read>

=item B<delete>

=item B<mark>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<douban.com/service/apidoc>

=head1 AUTHOR

woosley.xu<woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
