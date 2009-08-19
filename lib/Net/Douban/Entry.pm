package Net::Douban::Entry;
our $VERSION = '0.07';

use Moose;
use Carp qw/carp croak/;
extends qw/XML::Atom::Entry/;

has 'namespace' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
);

sub new {
    my $class = shift;
    my %args  = @_;
    my $ns    = delete $args{namespace};
    my $obj   = $class->SUPER::new(%args);
    return $class->meta->new_object( __INSTANCE__ => $obj, namespace => $ns );
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

Net::Douban::Entry

=head1 SYNOPSIS
	
	use Net::Douban::Atom;
	my $feed = Net::Douban::Atom->new(\$xml);
	my @entries = $feed->entries;
	$entry->get('title');
	$entry->content;
	$entry->attributes;

=head1 DESCRIPTION

This is the parser of douban.com xml entry based on L<<<<<<XML::Atom::Entry>>>>>> and L<<<<<<Moose>>>>>

Many functions not listed here are documented in L<<<<<<XML::Atom::Entry>>>>>>

=head1 VERSION

0.07

=over 4

=item get

see L<<<<<<Net::Douban::Atom>>>>>>

=item AUTOLOAD

see L<<<<<<Net::Douban::Atom>>>>>>

=item content

	$entry->content();

=back

=head1 AUTHOR

woosley.xu

=head1 COPYRIGHT

Copyright (C) 2009 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.
