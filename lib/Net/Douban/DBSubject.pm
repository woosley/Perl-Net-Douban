package Net::Douban::DBSubject;

use Moose;
use MooseX::StrictConstructor;
extends 'Net::Douban::Entry';

sub BUILD {
    my $self = shift;
    print "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
    $self->ns($self->namesapce->{main});
}

1;
