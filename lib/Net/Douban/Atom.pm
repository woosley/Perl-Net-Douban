package Net::Douban::Atom;

use Moose;
use Net::Douban::Entry;

#extends qw/XML::Atom::Feed XML::Atom::Entry Moose::Object/;
extends qw/XML::Atom::Feed Moose::Object/;
our $VERSION =;
has 'feed' => (
    is => 'ro',

    #    isa     => 'XML::LibXML::Element',
    default => sub {
        $_[0]->{feed};
    },
);

has 'namespace' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {
        my $elem = $_[0]->elem;
        $elem = $_[0]->{feed} if $_[0]->{feed};
        my %ns;
        foreach ( $elem->getNamespaces ) {
            my $prefix = $_->nodeName;
            my $value  = $_->value;
            $prefix =~ s/^xmlns(:)?//g;
            $prefix = 'main' unless $prefix;
            $ns{$prefix} = $value;
        }
        \%ns;
    }
);

sub new {
    my $class = shift;
    my $obj   = $class->SUPER::new(@_);
    return $class->meta->new_object( __INSTANCE__ => $obj );
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

sub entries {
    my $obj = shift;
    my $class = ref $obj ? ref $obj : shift;

    #	$class .= '::entry';
    my @entries;
    print $obj->namespace;
    if ( $obj->elem->nodeName eq 'entry' ) {
        push @entries,
          Net::Douban::Entry->new(
            Elem      => $obj->elem,
            namespace => $obj->namespace
          );
        return @entries;
    }
    my @res = $obj->SUPER::entries;
    foreach (@res) {
        push @entries,
          Net::Douban::Entry->new(
            Elem      => $obj->elem,
            namespace => $obj->namespace
          );
    }
    @entries;
}

sub search_info {
    my $obj = shift;
    return if $obj->elem->nodeName eq 'entry';
    my $ns = $obj->namespace->{opensearch};
    my %search_info;
    $search_info{'title'} = $obj->get('title');
    $search_info{'totalResults'} = $obj->get( $ns, 'totalResults' );
    return \%search_info;
}

1;
