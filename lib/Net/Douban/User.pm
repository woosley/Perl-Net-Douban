package Net::Douban::User;
our $VERSION = '0.07';

use Any::Moose;

#use Moose;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'uid' => ( is => 'rw', isa => 'Str', );

sub get_user {
    my $self = shift;
    my %args = @_;
    my $uid  = $args{uid} || $self->uid;
    return Net::Douban::Atom->new( $self->get( $self->user_url . "/$uid" ) );
}

sub search {
    my $self = shift;
    my %args = @_;
    croak "no query found in the parameters" unless exists $args{q};
    return Net::Douban::Atom->new( $self->get( $self->user_url, %args ) );
}

sub get_auth_user {
    my $self = shift;
    return Net::Douban::Atom->new( $self->get( $self->user_url . '/@me' ) );
}

sub get_contacts {
    my $self = shift;
    my %args = shift;
    my $uid  = delete $args{uid} || $self->uid;
    return Net::Douban::Atom->new(
        $self->get( $self->user_url . "/$uid/contacts", %args ) );
}

sub get_friends {
    my $self = shift;
    my %args = shift;
    my $uid  = delete $args{uid} || $self->uid;
    return Net::Douban::Atom->new(
        $self->get( $self->user_url . "/$uid/friends", %args ) );
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Douban::User

=head1 SYNOPSIS

	use Net::Douban::User;
	my $user = Net::Douban::User->new(
		uid => 'redicaps',
		apikey => '....',
		private_key => '....',
	);
	$user->get_user;
	$user->get_friends;
	$user->get_contacts;
	$user->uid('abei');

=head1 DESCRIPTION

Interface to douban.com api User section

=head1 VERSION

0.07

=head1 AUTHOR

woosley.xu

=head1 COPYRIGHT
	
Copyright (C) 2009 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
