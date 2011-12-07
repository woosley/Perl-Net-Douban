package Net::Douban::Utils;

use Carp qw/carp croak/;
use Moose ();
use MIME::Base64;
use JSON::Any;
use base 'Exporter';
use namespace::autoclean;
our @EXPORT = ('_build_method');

sub _build_method {
    my ($self, %api_hash) = @_;
    for my $key (keys %api_hash) {

        my $sub = sub {
            my $self        = shift;
            my %args        = @_;
            my $method      = $api_hash{$key}{method};
            my $params      = $api_hash{$key}{params};
            my $request_url = $self->api_base;
            my @args        = ($method);

            #my $res         = delete $args{res_callback};

            ## try to build request url
            $request_url->path_query($self->__build_path($api_hash{$key}, \%args));

            push @args, $self->__build_content($api_hash{$key}, \%args);

            ## at list on params needed
            if ($params) {
                my @p = ref $params ? @$params : ($params);
                my $exists = 0;
                for my $pp (@p) {
                    if (exists $args{$pp}) {
                        push @args, $pp => $args{$pp};
                        $exists++;
                    }
                }
                croak "Missing parameters: ", join('/'), @p unless $exists;
            }

            push @args, 'alt'       => 'json';
            push @args, request_url => $request_url;

            ## pass optional auguments to _restricted_request
            my $optional = $api_hash{$key}{'optional_params'};
            my @others =
              $optional
              ? (
                grep {$_}
                map { exists $args{$_} && $_ => $args{$_} } @$optional
              )
              : ();

           #return $res->($self->_restricted_request(@args, @others)) if $res;
            $self->res_callback->($self->_restricted_request(@args, @others));
        };
        $self->meta->add_method($key, $sub);
    }
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
1;

__END__

=pod

=head1 NAME

Net::Douban::Utils - Utils for Net::Douban

=head1 SYNOPSIS

    use Net::Douban::Utils

=head1 DESCRIPTION

M<Net::Douban::Utils> has just one exported function B<__build_method>

=head1 SEE ALSO
    
L<Net::Douban> L<Net::Douban::Traits::Gift> L<Net::Douban::User>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT & LICENSE

This software is copyright (c) 2010 - 2011 by woosley.xu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

