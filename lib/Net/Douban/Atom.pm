package Net::Douban::Atom;

use Moose;
use MooseX::NonMoose;
use Carp qw/carp croak/;
use Net::Douban::Entry;

extends qw/XML::Atom::Feed/; 

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
        foreach ($elem->getNamespaces) {
            my $prefix = $_->nodeName;
            my $value  = $_->value;
            $prefix =~ s/^xmlns(:)?//g;
            $prefix = 'main' unless $prefix;
            $ns{$prefix} = $value;
        }
        \%ns;
    }
);
#
#sub new {
#    my $class = shift;
#    my $self  = $class->SUPER::new(@_);
#    return $class->meta->new_object(__INSTANCE__ => $self);
#}

sub FOREIGNBUILDARGS {
	my ($self, %args) = @_;
	return ($args{xml});
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

sub entries {
    my $self = shift;
    my $class = ref $self ? ref $self : shift;

    #	$class .= '::entry';
    my @entries;
    if ($self->elem->nodeName eq 'entry') {
        push @entries,
          Net::Douban::Entry->new(
            Elem      => $self->elem,
            namespace => $self->namespace
          );
        return @entries;
    }
    my @res = $self->SUPER::entries;
    foreach my $entry (@res) {
        push @entries,
          Net::Douban::Entry->new(
            Elem      => $entry->elem,
            namespace => $self->namespace,
          );
    }
    @entries;
}

sub entry {
    my $self = shift;
    if ($self->elem->nodeName eq 'entry') {
        return Net::Douban::Entry->new(
            Elem      => $self->elem,
            namespace => $self->namespace,
            ns        => $self->namespace->{main},
        );
    }
    return;
}

sub search_info {
    my $self = shift;
    return if $self->elem->nodeName eq 'entry';
    my $ns = $self->namespace->{opensearch};
    my %search_info;
    $search_info{'title'} = $self->get('title');
    $search_info{'totalResults'} = $self->get($ns, 'totalResults');
    return \%search_info;
}

#our $AUTOLOAD;
#
#sub AUTOLOAD {
#
#    (my $name = $AUTOLOAD) =~ s/.*:://g;
#    return if $name eq 'DESTROY';
#    my $sub = <<SUB;
#	sub $name {
#		my \$self =  shift;
#		return \$self->get($name);
#	}
#SUB
#    eval($sub);    ## the same as *$name = $sub;
#    goto &$name;
#}
#sub DESTROY { }

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=encoding utf8

=head1 NAME

Net::Douban::Atom - Atom parser

=head1 SYNOPSIS
	
	use Net::Douban::Atom;
	my $feed = Net::Douban::Atom->new(\$xml);
	$feed->title;
	$feed->id;
	$feed->get('db:uid');
	$feed->content;
	my @entries = $feed->entries;

=head1 DESCRIPTION

This is the parser of douban.com xml based on L<XML::Atom::Feed> and L<Moose>

Many functions not listed here are documented in L<XML::Atom::Feed>

=head1 METHODS

=over 4

=item B<new>
	
	$feed = Net::Douban::Atom->new(\$xml);

Constructor, even though XML::Atom::Feed support feed auto-discovery from internet, I do not recommend to do that.

=item B<get>
	
	$feed->get('title');
	$feed->get('db:uid');
	$feed->get('db','uid');
	$feed->get($ns,'uid');

XML::Atom::Base::get的重载，当没有NS给出时，尽量‘聪明的’猜测对应NS 

=item B<search_info>

	$feed->search_info();

返回搜索结果的信息	

=item  B<entries>

	$feed->entries;

返回当前feed的所有entry

=item B<entry>

	$feed->entry;

返回根entry，应用与情况为feed的root note是entry，即只是获得单个结果的情况(如获得一部电影信息，获得一个用户的信息等)。尽管这时$feed->whaterver也能获得相当多的结果，但仍然强烈建议使用$feed->entry->whatever来获得对应结果。此外，Net::Douban::Entry提供了比Atom更多的特性

=back

=head1 SEE ALSO

L<Net::Douban> L<Moose> L<XML::Atom> L<http://douban.com/service/apidoc>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
