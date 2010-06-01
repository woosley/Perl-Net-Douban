package Net::Douban::Miniblog;

use Moose;
use MooseX::StrictConstructor;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'miniblogID' => (
    is  => 'rw',
    isa => 'Str',
);

has 'miniblog_url' => (
    is      => 'rw',
    isa     => 'Url',
    lazy    => 1,
    default => sub { shift->base_url . '/miniblog' }
);

sub get_user_miniblog {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/miniblog", %args));
}

sub get_contact_miniblog {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/miniblog/contacts", %args));
}

sub post_saying {
    my ($self, %args) = @_;
    croak "post xml needed!" unless exists $args{xml};
    return $self->post($self->miniblog_url . "/saying", %args);
}

sub delete_miniblog {
    my ($self, %args) = @_;
    $args{miniblogID} ||= $self->miniblogID;
    croak "miniblogID needed!" unless exists $args{miniblogID};
    return $self->delete($self->miniblog_url . "/$args{miniblogID}");
}

sub get_reply{
    my ($self, %args) = @_;
    $args{miniblogID} ||= $self->miniblogID;
    croak "miniblogID needed!" unless exists $args{miniblogID};
    return Net::Douban::Atom->new(
        $self->get($self->miniblog_url . "/$args{miniblogID}/". "comments"));
}

sub post_reply {
    my ($self, %args) = @_;
    $args{miniblogID} ||= $self->miniblogID;
    my $mid = delete $args{miniblogID} or croak "miniblogID needed!";
    croak "post xml needed!" unless exists $args{xml};
    return $self->post($self->miniblog_url . "/$mid/comments", %args);
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Douban::Miniblog

=head1 SYNOPSIS

	use Net::Douban::Miniblog;
	$miniblog = Net::Douban::Miniblog->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $miniblog->get_user_miniblog(userID => 'Net-Douban');
	$atom = $miniblog->get_contact_miniblog(userID => 'Net-Douban');

=head1 DESCRIPTION

Interface to douban.com API Miniblog section

=head1 METHODS

Those methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_user_miniblog>

=item B<get_contact_miniblog>

=item B<post_saying>

=item B<delete_miniblog>

=item B<get_reply>

=item B<post_reply>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/miniblog>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
