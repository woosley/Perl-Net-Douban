package Net::Douban::Entry;
our $VERSION = '1.02';

use Moose;
use Net::Douban::DBSubject;
use Carp qw/carp croak/;

#use Smart::Comments;
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
    my $self  = $class->SUPER::new(%args);
    return $class->meta->new_object(__INSTANCE__ => $self, namespace => $ns);
}

sub get {
    my $self = shift;
    my ($ns, $field);
    if (@_ == 1) {
        $field = shift;
        if ($field =~ /^(.*?):(.*)$/) {
            $ns    = $self->namespace->{$1};
            $field = $2;
        } else {
            $ns = $self->{ns};
        }
    } else {
        ($ns, $field) = @_;
        $ns = $self->namespace->{$ns} unless $ns =~ m{^http://};
    }
    $ns or croak "No Namespace found!";
    $self->SUPER::get($ns, $field);
}

sub content {
    return $_[0]->SUPER::content->body;
}

sub attributes {
    my $self = shift;
    my $ns   = $self->namespace->{db};
    my %attr;
    foreach my $node ($self->elem->getChildrenByTagNameNS($ns, 'attribute')) {
        $attr{$node->getAttribute('name')} = $node->textContent;
    }
    \%attr;
}

sub tags {
    my $self = shift;
    my $ns   = $self->namespace->{db};
    my @tags;
    foreach my $node ($self->elem->getChildrenByTagNameNS($ns, 'tag')) {
        push @tags, $node->getAttribute('name');
    }
    \@tags;
}

sub rating {
    my $self = shift;
    my %rating;
    my $rate =
      ($self->elem->getChildrenByTagNameNS($self->namespace->{gd}, 'rating'))
      [0];
    foreach my $attr ($rate->attributes) {
        $rating{$attr->nodeName} = $attr->value;
    }
    \%rating;
}

sub subject {
    my $self    = shift;
    my $subject = (
        $self->elem->getChildrenByTagNameNS(
            $self->namespace->{db}, 'subject'
        )
    )[0];
    ### subject: $subject
    return unless ref $subject eq 'XML::LibXML::Element';
    my $k = Net::Douban::DBSubject->new(
        Elem      => $subject,
        namespace => $self->namespace,
    );
    $k->{ns} = $self->namespace->{main};
    return $k;
}

sub DESTROY { }
our $AUTOLOAD;

sub AUTOLOAD {

    #	my $self = shift;
    #	my $class = ref $self ? ref $self : $self;
    (my $name = $AUTOLOAD) =~ s/.*:://g;
    return if $name eq 'DESTROY';
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

=head1 VERSION

version 1.02

=head1 SYNOPSIS
	
	use Net::Douban::Atom;
	my $feed = Net::Douban::Atom->new(\$xml);
	my @entries = $feed->entries;
	$entry->get('title');
	$entry->content;
	$entry->attributes;
	$entry->tags;

=head1 DESCRIPTION

This is the parser of douban.com xml entry based on L<<<<<<XML::Atom::Entry>>>>>> and L<<<<<<Moose>>>>>

Many functions not listed here are documented in L<<<<<<XML::Atom::Entry>>>>>>

=over 4

=item get

see L<<<<<<Net::Douban::Atom>>>>>>

=item AUTOLOAD

see L<<<<<<Net::Douban::Atom>>>>>>

=item content

	$entry->content();

返回content内容	

=item attributes
	
	$entry->attributes;

返回包含所有attribute的hash引用

=item tags

	$entry->tags;

返回包括所有tag的数组引用

=item rating

	$entry->rating;

返回一个rating的hash引用

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<douban.com/service/apidoc>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.
