package Net::Douban::Utils;
use Carp qw/carp croak/;
use MIME::Base64;
use JSON::Any;
use namespace::autoclean;
use Moose::Exporter;

Moose::Exporter->setup_import_methods(with_meta => ['douban_method']);

sub _meta_method_obj {
    my $meta = shift;
    Moose::Meta::Class->create_anon_class(
        superclasses => [$meta->method_metaclass],
        roles        => ['Net::Douban::Utils::Role'],
        cache        => 1,
    )->name;
}

sub douban_method {
    my ($meta, $name, @args) = @_;
    my $code = _gen_method(@args);
    $meta->add_method(
        $name => _meta_method_obj($meta)->wrap(
            $code,
            name                => $name,
            package_name        => $meta->name,
            associate_metaclass => $meta,
        ),
    );
}

sub _gen_method {
    my $options = shift;
    return sub {
        my $self        = shift;
        my %args        = @_;
        my $method      = $options->{method};
        my $params      = $options->{params};
        my $request_url = $self->api_base;
        my @args        = ($method);

        #my $res         = delete $args{res_callback};

        ## try to build request url
        $request_url->path_query($self->__build_path($options, \%args));

        push @args, $self->__build_content($options, \%args);

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
        my $optional = $options->{'optional_params'};
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

    package Foo;
    use Net::Douban::Utils
    # set up 'get_user' method for package Foo
    douban_method 'get_user' => {
        has_url_param => 'userID',
        path          => '/people/{userID}',
        method        => 'GET'
    };
    
=head1 DESCRIPTION

M<Net::Douban::Utils> has just one exported function B<douban_method>,

=head1 SEE ALSO
    
L<Net::Douban> L<Net::Douban::Traits::Gift> L<Net::Douban::User>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT & LICENSE

This software is copyright (c) 2010 - 2011 by woosley.xu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

