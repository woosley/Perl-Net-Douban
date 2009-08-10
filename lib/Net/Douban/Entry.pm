package Net::Douban::Entry;
our $VERSION = '0.01';

use Moose;
extends qw/XML::Atom::Entry/;

has 'namespace' => (
    is       => 'ro',
    isa      => 'HashRef',
    requried => 1,
);

sub new {
    my $class = shift;
    my %args  = @_;
    my $ns    = delete $args{namespace};
    my $obj   = $class->SUPER::new(%args);
    return $class->meta->new_object( __INSTANCE__ => $obj, namespace => $ns );
}

sub get {
    my $obj = shift;
    my $ns;
    if ( @_ == 1 ) {
        $ns = $obj->{ns};
    }
    else {
        $ns = shift;
    }
    $obj->SUPER::get( $ns, shift );
}

sub content {
    return $_[0]->SUPER::content->body;
}

sub attributes {
    my $obj = shift;
    my $ns  = $obj->namespace->{db};
    my %attr;
    foreach my $node ( $obj->elem->getChildrenByTagNameNS( $ns, 'attribute' ) )
    {
        $attr{ $node->getAttribute('name') } = $node->textContent;
    }
    \%attr;
}
1;
