package Net::Douban::DBSubject;
our $VERSION = '1.03';

use Moose;
extends 'Net::Douban::Entry';

sub BUILD {
    my $self = shift;
    print "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    $self->ns($self->namesapce->{main});
}

1;
