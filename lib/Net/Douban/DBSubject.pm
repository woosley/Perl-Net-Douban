package Net::Douban::DBSubject;
our $VERSION = '0.41';

use Moose;
extends 'Net::Douban::Entry';

sub BUILD {
    my $self = shift;
    print "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    $self->ns($self->namesapce->{main});
}

1;

=pod
=head1 NAME

    Net::Douban::Collection;

=head1 VERSION

version 0.41

=cut
