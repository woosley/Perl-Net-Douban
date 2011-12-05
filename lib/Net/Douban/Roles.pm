package Net::Douban::Roles;

use Carp qw/carp croak/;
use Moose::Role;
use namespace::autoclean;
use MIME::Base64;
use JSON::Any;

requires '_restricted_request';

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


1;
__END__

=pod

=head1 NAME

Net::Douban::Roles - basic Moose role for Net::Douban

=head1 SYNOPSIS
	
	with 'Net::Douban::Roles'

=head1 SEE ALSO
    
L<Net::Douban>  L<Moose> L<http://douban.com/service/apidoc>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 - 2011 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
