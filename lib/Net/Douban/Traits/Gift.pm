package Net::Douban::Traits::Gift;
use Moose::Role;
with "Net::Douban::User";
with "Net::Douban::Review";
with "Net::Douban::Collection";
with "Net::Douban::Subject";
with "Net::Douban::Miniblog";
with "Net::Douban::Note";
with "Net::Douban::Event";
with "Net::Douban::Recommendation";
with "Net::Douban::Doumail";
with "Net::Douban::Tag";

has 'uid' => (isa => 'Str', is => 'rw', predicate => 'has_uid');

before qw/my_reviews my_collections my_miniblogs my_contact_miniblogs
  my_notes my_events my_recoms/ => sub {

    my $self = shift;
    if (!$self->has_uid) {
        my $json = $self->me;
        $self->uid($json->{"db:uid"}->{'$t'});
    }
};

sub my_reviews {
    my $self = shift;
    return $self->get_user_review(userID => $self->uid);
}

sub my_collections {
    my $self = shift;
    return $self->get_user_collection(userID => $self->uid);
}

sub my_miniblogs {
    my $self = shift;
    return $self->get_user_miniblog(userID => $self->uid);
}

sub my_contact_miniblogs {
    my $self = shift;
    return $self->get_contact_miniblog(userID => $self->uid);
}

sub my_notes {
    my $self = shift;
    return $self->get_user_notes(userID => $self->uid);
}

sub my_events {
    my $self = shift;
    return $self->get_user_events(userID => $self->uid);
}

sub my_recoms {
    my $self = shift;
    return $self->get_user_recom(userID => $self->uid);
}

1;

__END__
=pod

=head1 NAME

Net::Douban::Traits::Gift - Gift for Traits

=head1 SYNOPSIS

	my $c = Net::Douban->init(Traits => 'Gift');

=head1 DESCRIPTION

Role for Gift, everything for Net::Douban API

=head1 METHODS

All methods in the API package are imported here. with extra methods listed below

=over

=item B<my_reviews>

=item B<my_events>

=item B<my_collections>

=item B<my_recoms>

=item B<my_notes>

=item B<my_contact_miniblogs>

=item B<my_miniblogs>


=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::*> L<Moose> 

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 - 2011 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
