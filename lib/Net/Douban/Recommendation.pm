package Net::Douban::Recommendation;

use Moose;
use MooseX::StrictConstructor;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles::More';

has 'recomID' => (
    is  => 'rw',
    isa => 'Str',
);

has 'recom_url' => (
    is      => 'rw',
    isa     => 'Url',
    lazy    => 1,
    default => sub { shift->base_url . '/recommendation' },
);

sub get_recom {
    my ($self, %args) = @_;
    $args{recomID} ||= $self->recomID;
    croak "recomID needed!" unless exists $args{recomID};
    return Net::Douban::Atom->new(
        $self->get($self->recom_url . "/$args{recomID}"));
}

sub get_comments {
    my ($self, %args) = @_;
    $args{recomID} ||= $self->recomID;
    croak "recomID needed!" unless $args{recomID};
    return Net::Douban::Atom->new(
        $self->get($self->recom_url . "/$args{recomID}/comments"));
}

sub get_user_recom {
    my ($self, %args) = @_;
    my $uid = delete $args{userID} or croak "userID needed";
    return Net::Douban::Atom->new(
        $self->get($self->user_url . "/$uid/recommendations", %args));
}

sub post_recom {
    my ($self, %args) = @_;
    croak "post xml needed!" unless exists $args{xml};
    return $self->post($self->recom_url . "s", xml => $args{xml});
}

sub delete_recom {
    my ($self, %args) = @_;
    $args{recomID} ||= $self->recomID;
    croak "recomID needed!" unless $args{recomID};
    return $self->delete($self->recom_url . "/$args{recomID}");
}

sub post_comment {
    my ($self, %args) = @_;
    croak "post xml needed!" unless exists $args{xml};
    $args{recomID} ||= $self->recomID;
    croak "recomID needed!" unless $args{recomID};
    return $self->post($self->recom_url . "/$args{recomID}/comments",
        xml => $args{xml});
}

sub delete_comment {
    my ($self, %args) = @_;
    $args{recomID} ||= $self->recomID;
    croak "commentID needed!" unless exists $args{commentID};
    return $self->delete(
        $self->recom_url . "/$args{recomID}/comment/$args{commentID}");
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

Net::Douban::Recommendation

=head1 SYNOPSIS

	use Net::Douban::Recommendation;
	my $recom = Net::Douban::Recommendation->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $recom->get_recom(recomID => ...);
	$atom = $event->get_user_recom(userID => ...);

=head1 DESCRIPTION

Interface to douban.com API Event section

=head1 METHODS

Most of the get methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_recom>

=item B<get_comments>

=item B<get_user_recom>

=item B<post_recom>

=item B<delete_recom>

=item B<post_comment>

=item B<delete_comment>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/recommendation>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
