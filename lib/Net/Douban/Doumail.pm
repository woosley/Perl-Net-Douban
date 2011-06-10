package Net::Douban::Doumail;

use Moose;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'doumailID' => (
    is  => 'rw',
    isa => 'Str',
);

has 'doumail_url' => (
    is      => 'rw',
    isa     => 'Url',
    lazy    => 1,
    default => sub { shift->base_url . '/doumail' },
);

before qw/inbox unread outbox get_doumail/ => sub {
    croak "oauth needed" unless $_[0]->has_oauth;
};

sub inbox {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new(
        $self->get($self->doumail_url . "/inbox", %args));
}

#sub unread {
#    my ($self, %args) = @_;
#    return Net::Douban::Atom->new(
#        $self->get($self->doumail_url . "/inbox/unread", %args));
#}
#
#sub outbox {
#    my ($self, %args) = @_;
#    return Net::Douban::Atom->new(
#        $self->get($self->doumail_url . "/outbox", %args));
#}
#
#sub get_doumail {
#    my ($self, %args) = @_;
#    $args{mailID} ||= $self->mailID;
#    croak "mailID needed" unless defined $args{mailID};
#    return Net::Douban::Atom->new(
#        $self->get($self->doumail_url . "/$args{mailID}", %args));
#}
#
#sub post_doumail {
#    my ($self, %args) = @_;
#    croak "post xml needed!" unless $args{xml};
#    return $self->post($self->doumail_url . 's', xml => $args{xml});
#}
#
#sub delete_doumail {
#    my ($self, %args) = @_;
#    $args{mailID} ||= $self->mailID;
#    croak "mailID needed" unless defined $args{mailID};
#    return $self->delete($self->doumail_url . "/$args{mailID}");
#}
#
#sub mark_read {
#    my ($self, %args) = @_;
#    $args{mailID} ||= $self->mailID;
#    croak "mailID needed" unless defined $args{mailID};
#    croak "put xml needed!" unless $args{xml};
#    return $self->put($self->doumail_url . "/$args{mailID}",
#        xml => $args{xml});
#}
#
#sub delete {
#    my ($self, %args) = @_;
#    croak "delete xml needed!" unless $args{xml};
#    return $self->delete($self->doumail_url, $args{xml});
#}
#
#sub mark {
#    my ($self, %args) = @_;
#    croak "post xml needed!" unless $args{xml};
#    return $self->put($self->doumail_url . '/delete', $args{xml},);
#}

__PACKAGE__->meta->make_immutable;
1;

=pod
=head1 NAME

    Net::Douban::Doumail

=head1 SYNOPSIS

	use Net::Douban::Doumail;
	my $mail= Net::Douban::Doumail->new(
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

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> L<http://douban.com/service/apidoc/reference/douamil>

=head1 AUTHOR

woosley.xu<woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
