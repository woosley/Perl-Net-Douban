package Net::Douban::Atom;
use Moose;
use Carp qw/carp croak/;
use Net::Douban::Entry;

extends qw/XML::Atom::Feed Moose::Object/;
our $VERSION = 0.07;

has 'feed' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        $_[0]->{feed};
    },
);

has 'namespace' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
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
    my $self  = $class->SUPER::new(@_);
    return $class->meta->new_object( __INSTANCE__ => $self );
}

sub get {
    my $self = shift;
    my ( $ns, $field );
    if ( @_ == 1 ) {
        $field = shift;
        if ( $field =~ /^(.*?):(.*)$/ ) {
            $ns    = $self->namespace->{$1};
            $field = $2;
        }
        else {
            $ns = $self->{ns};
        }
    }
    else {
        ( $ns, $field ) = @_;
        $ns = $self->namespace->{$ns} unless $ns =~ m{ ^http : // };
    }

    $ns or croak "No Namespace found!";
    $self->SUPER::get( $ns, $field );
}

sub entries {
    my $self = shift;
    my $class = ref $self ? ref $self : shift;

    #	$class .= '::entry';
    my @entries;
    print $self->namespace;
    if ( $self->elem->nodeName eq 'entry' ) {
        push @entries,
          Net::Douban::Entry->new(
            Elem      => $self->elem,
            namespace => $self->namespace
          );
        return @entries;
    }
    my @res = $self->SUPER::entries;
    foreach (@res) {
        push @entries,
          Net::Douban::Entry->new(
            Elem      => $self->elem,
            namespace => $self->namespace
          );
    }
    @entries;
}

sub search_info {
    my $self = shift;
    return if $self->elem->nodeName eq 'entry';
    my $ns = $self->namespace->{opensearch};
    my %search_info;
    $search_info{'title'} = $self->get('title');
    $search_info{'totalResults'} = $self->get( $ns, 'totalResults' );
    return \%search_info;
}

sub DESTORY { }
our $AUTOLOAD;

sub AUTOLOAD {

    #	my $self = shift;
    #	my $class = ref $self ? ref $self : $self;
    ( my $name = $AUTOLOAD ) =~ s/.*:://g;
    return if $name eq 'DESTORY';
    my $sub = <<SUB;
	sub $name {
		my \$self =  shift;
		return \$self->get($name);
	}
SUB
    eval($sub);    ## the same as *$name = $sub;
    goto &$name;
}

1;

__END__


=pod

=head1 NAME

Net::Douban::Atom

=head1 SYNOPSIS
	
	use Net::Douban::Atom;
	my $feed = Net::Douban::Atom->new(\$xml);
	$feed->title;
	$feed->id;
	$feed->get('db:uid');
	$feed->content;
	my @entries = $feed->entries;

=head1 DESCRIPTION

This is the parser of douban.com xml based on L<<<<<<XML::Atom::Feed>>>>>> and L<<<<<<Moose>>>>>

Many functions not listed here are documented in L<<<<<<XML::Atom::Feed>>>>>>

=head1 VERSION

0.07

=over 4

=item new
	
	$feed = Net::Douban::Atom->new(\$xml);

Constructor, even though XML::Atom::Feed support feed auto-discovery from internet, I do not recommend to do that.

=item get
	
	$feed->get('title');
	$feed->get('db:uid');
	$feed->get('db','uid');
	$feed->get($ns,'uid');

Overrider of XML::Atom::Base::get. If no NS spcefied, try to guess the correct NS from the parameter.

=item AUTOLOAD

	$feed->whatever;

Use $feed->get('whatever') internally;


=item search_info

	$feed->searchInfo();

return the search result information

=item 

	$feed->entries;

return Net::Douban::Entries instances

=back

=head1 AUTHOR

woosley.xu

=head1 COPYRIGHT

Copyright (C) 2009 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.
