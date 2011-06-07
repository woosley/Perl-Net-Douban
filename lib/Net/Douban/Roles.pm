package Net::Douban::Roles;

use Carp qw/carp croak/;
use Moose::Role;
use Scalar::Util qw/blessed/;

has 'oauth' => (is => 'rw', predicate => 'has_oauth', lazy_build => 1);
has 'ua' => (is => 'rw', lazy_build => 1,);
has 'apikey'      => (is => 'rw', isa => 'Str');
has 'private_key' => (is => 'rw', isa => 'Str');
has 'start_index' => (is => 'rw', isa => 'PInt', default => 0,);
has 'max_results' => (is => 'rw', isa => 'PInt', default => 10);

sub _build_oauth {
    eval { require Net::Douban::OAuth};
    croak $@ if $@;
    Net::Douban::OAuth->new();
}

sub _build_ua {
    eval { require LWP::UserAgent };
    croak $@ if $@;
    my $ua = LWP::UserAgent->new(
        agent        => 'perl-net-douban-' . $VERSION,
        timeout      => 30,
        max_redirect => 5
    );
    $ua->env_proxy;
    $ua;
}

sub args {
    my $self = shift;
    return unless blessed($self) && $self->isa("Net::Douban");
    my %ret;
    for my $arg (qw/ ua apikey start_index max_results oauth/) {
        if (defined $self->$arg) {
            $ret{$arg} = $self->$arg;
        }
    }
    return %ret;
}

no Moose::Role;

package Net::Douban::Types;
use Moose::Util::TypeConstraints;

## url
subtype
  'Url' => as 'Str',
  => where { $_ =~ m/^http:\/\/.*\w$/ },
  => message {"invalid url!"};

## positive int
subtype
  'PInt' => as 'Int',
  => where { $_ >= 0 },
  => message {"not a positive int"};
1;
__END__

=pod

=head1 NAME

Net::Douban::Roles - basic Moose role for Net::Douban

=head1 SYNOPSIS
	
	with 'Net::Douban::Roles'

=head1 DESCRIPTION

This PM file includes Net::Douban::Roles and Net::Douban::Types. Net::Douban::Roles provides most of the attributes for Net::Douban::*; Net::Douban::Types is the type constraint system for Net::Douban 

=head1 ATTRIBUTES

=over 4

=item B<oauth>

oauth object for Net::Douban

=item B<ua>

user-agent object for Net::Douban, provided by default

=item B<apikey>

=item B<private_key>

=item B<start_index>

url start-index argument, set to 0 by default

=item B<max_results>

url max-results argument, set to 10 by default

=back

=head1 SEE ALSO
    
L<Net::Douban> L<Net::Douban::Roles::More> L<Moose> L<http://douban.com/service/apidoc>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT & LICENSE

This software is copyright (c) 2010 by woosley.xu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
