package Net::Douban::Roles;

use Carp qw/carp croak/;
use Moose::Role;
use namespace::autoclean;
use MIME::Base64;

with "Net::Douban::OAuth";
our $VERSION = '1.08';
has 'apikey'      => (is => 'rw', isa => 'Str');
has 'private_key' => (is => 'rw', isa => 'Str');
has 'start_index' => (is => 'rw', isa => 'PInt', default => 0);
has 'max_results' => (is => 'rw', isa => 'PInt', default => 10);
has 'api_base' =>
  (is => 'ro', isa => 'Str', default => 'http://api.douban.com');
has 'res_callback' => (
    is      => 'rw',
    isa     => 'CodeRef',
    lazy    => 1,
    default => sub { \&_wrape_response },
);

sub args {
    my $self = shift;
    return unless blessed($self) && $self->isa("Net::Douban");
    my %ret;
    for my $arg (qw/apikey start_index max_results/) {
        if (defined $self->$arg) {
            $ret{$arg} = $self->$arg;
        }
    }
    return %ret;
}

sub _build_method {
    my ($self, %api_hash) = @_;
    for my $key (keys %api_hash) {

        my $sub = sub {
            my $self        = shift;
            my %args        = @_;
            my $url_param   = $api_hash{$key}{url_param};
            my $method      = $api_hash{$key}{method};
            my $content     = $api_hash{$key}{content};
            my $params      = $api_hash{$key}{params};
            my $request_url = $self->api_base . $api_hash{$key}{path};
            my @args        = ($method);

            ## try to build request url
            if ($url_param) {
                croak "Argument $url_param missing"
                  if (!exists $args{$url_param});
                my $x = '{' .  $url_param . '}';
                $request_url =~ s/\Q$x\E/$args{$url_param}/g;
            }

            if ($params) {
                croak "Argument $params missing" if (!exists $args{$params});
                push @args, $params => $args{$params};
            }

#push @args, 'alt' => 'json' if $method eq 'GET';
            push @args, 'alt' => 'json';

            if ($content && $method eq 'POST') {
                croak 'Missing param' unless @_;
                my $decoded_content = decode_base64($content);
                my $c               = $self->escape($_[0]);
                my $mark            = '${CONTENT}';
                $decoded_content =~ s/\Q$mark\E/$c/g;
                push @args,
                  Content      => $decoded_content,
                  Content_Type => q{application/atom+xml};
            }
            push @args, request_url => $request_url;
            $self->res_callback->($self->_restricted_request(@args));
        };
        $self->meta->add_method($key, $sub);
    }
}

sub _wrape_response {
    my $res = shift;
    croak $res->status_line unless $res->is_success;
    return $res->decoded_content;
}

sub build_url {
    my $self = shift;
    my $url  = shift;
    my %args = @_;
    my $mark = $url =~ /\?/ ? '&' : '?';
    while (my ($key, $value) = each %args) {
        $key =~ s/-/_/g;
        $url .= $mark . "$key=$value";
        $mark = '&';
    }
    return $url;
}

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
