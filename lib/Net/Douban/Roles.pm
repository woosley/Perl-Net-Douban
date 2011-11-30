package Net::Douban::Roles;

use Carp qw/carp croak/;
use Moose::Role;
use namespace::autoclean;
use MIME::Base64;
use JSON::Any;

requires '_restricted_request';

our $VERSION = '1.08';

has 'apikey'      => (is => 'rw', isa => 'Str');
has 'private_key' => (is => 'rw', isa => 'Str');
has 'start_index' => (is => 'rw', default => 0);
has 'max_results' => (is => 'rw', default => 10);
has 'api_base' =>
  (is => 'ro', isa => 'Str', default => 'http://api.douban.com');
has 'res_callback' => (
    is      => 'rw',
    isa     => 'CodeRef',
    clearer => 'clear_res_callback',
    lazy    => 1,
    default => sub { \&_wrape_response },
);

sub _wrape_response {
    my $res = shift;
    croak $res->status_line unless $res->is_success;
    return $res->decoded_content unless $res->content_type =~ /json/i;
    my $j = JSON::Any->new();
    return $j->from_json($res->decoded_content);
}

sub __build_path {
    my ($self, $api, $args) = @_;

    return $api->{path} unless $api->{has_url_param};
    my $path = $api->{path};
    my (@no, @path_list);
    if (ref $path) {
        push @path_list, @$path;
    } else {
        push @path_list, $path;
    }

    FOO: for my $path (@path_list) {
        my $p;
        while (1) {
            my ($type, $ele) = do {
                if ($path =~ /\G([^{]+)/gc) {
                    (0, $1);
                } elsif ($path =~ /\G{(\w+)}/gc) {
                    ('param', $1);
                } else {
                    last;
                }
            };
            if ($type) {
                if (!exists $args->{$ele}) {
                    push @no, $ele;
                    next FOO;
                }
                $p .= $args->{$ele};
            } else {
                $p .= $ele;
            }
        }
        return $p;
    }
    croak "Missing augument: ", join("/", @no);
}

sub __build_content {
    my ($self, $api, $args) = @_;
    return unless $api->{content} && $api->{content_params};
    my $decoded_content = decode_base64($api->{content});

    $decoded_content = $api->{_build_content}->($decoded_content, $args)
      if $api->{_build_content};

    foreach my $param (@{$api->{content_params}}) {
        croak "Missing augument: $param" unless exists $args->{$param};
        my $escaped = __escape($args->{$param});
        $decoded_content =~ s/\Q{$param}\E/$escaped/g;
    }

    return (
        Content      => $decoded_content,
        Content_Type => 'application/atom+xml'
    );
}

sub __escape {
    my $c   = shift;
    my %foo = (
        '\'' => '&apos;',
        '"'  => "&quot;",
        '&'  => '&amp;',
        '<'  => "&lt;",
        ">"  => '&gt'
    );
    for my $key (keys %foo) {
        $c =~ s/$key/$foo{$key}/g;
    }
    return $c;
}

has 'realm' => (is => 'ro', default => 'http://www.douban.com');

package Net::Douban::Types;
use Moose::Util::TypeConstraints;

## url
subtype
  'Url' => as 'Str',
  => where { $_ =~ m/^https?:\/\/.*\w$/ },
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
