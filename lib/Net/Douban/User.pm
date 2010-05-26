package Net::Douban::User;

use Moose;
with 'Net::Douban::Roles::More';
use Net::Douban::Atom;
use Carp qw/carp croak/;
use MooseX::StrictConstructor;

has 'userID' => (is => 'rw', isa => 'Str',);

sub get_user {
    my ($self, %args) = @_;
    my $userID = $args{userID} || $self->userID;
    croak "no userId found!" unless $userID;
    return Net::Douban::Atom->new($self->get($self->user_url . "/$userID"));
}

sub search {
    my ($self, %args) = @_;
    croak "no query found in the parameters" unless exists $args{q};
    return Net::Douban::Atom->new($self->get($self->user_url, %args));
}

sub get_auth_user {
    my ($self, %args) = @_;
    return Net::Douban::Atom->new($self->get($self->user_url . '/%40me'));
}

sub get_contacts {
    my ($self, %args) = @_;
    my $userID = delete $args{userID} || $self->userID;
    croak "no userId found!" unless $userID;
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$userID/contacts", %args));
}

sub get_friends {
    my ($self, %args) = @_;
    my $userID = delete $args{userID} || $self->userID;
    croak "no userId found!" unless $userID;
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$userID/friends", %args));
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Douban::User

=head1 SYNOPSIS

	use Net::Douban::User;
	my $user = Net::Douban::User->new(
		userID => 'Net-Douban',
		apikey => '....',
        # or
        oauth => $consumer,
	);
	$user->userID('abei');

	$atom = $user->get_user;
	$atom = $user->get_friends;
	$atom = $user->get_contacts;
    $atom = $user->search(q => 'douban', start_index => 5, max_results => 10);

=head1 DESCRIPTION

Interface to douban.com API User section

=head1 METHODS

Those methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_user>

=item B<get_contacts>

=item B<get_friends>

=item B<get_auth_user>

=item B<search>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<douban.com/service/apidoc>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
