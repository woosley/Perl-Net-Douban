package Net::Douban::OAuth::Consumer;
our $VERSION = '1.03';
use Net::OAuth;
use HTTP::Request::Common;
use HTTP::Request;
use HTTP::Headers;
use Carp qw/croak carp/;
use Moose;

has 'ua' => (
    is         => 'rw',
    lazy_build => 1,
);

sub _build_ua {
    eval { require LWP::UserAgent };
    die $@ if $@;
    my $ua = LWP::UserAgent->new(
        agent        => 'perl-net-douban-',
        timeout      => 30,
        max_redirect => 5
    );
    $ua->env_proxy;
    $ua;
}

has 'consumer_key' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'consumer_secret' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'request_method' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'POST',
);

has 'site' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'request_token_path' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'access_token_path' => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has 'authorize_url' => (
    is  => 'rw',
    isa => 'Str',
);

has 'request_token' => (
    is  => 'rw',
    isa => 'Str',
);

has 'request_token_secret' => (
    is  => 'rw',
    isa => 'Str',
);

has 'access_token' => (
    is  => 'rw',
    isa => 'Str',
);

has 'access_token_secret' => (
    is  => 'rw',
    isa => 'Str',
);

has 'signature_method' => (
    is      => 'rw',
    isa     => 'Str',
    default => 'HMAC-SHA1',

);

has 'authorized' => (
    is      => 'rw',
    isa     => 'Int',
    default => 0,
);
### required realm for api.douban.com
has 'realm' => (
    is      => 'rw',
    isa     => 'Str',
    default => " ",
);

sub _gen_nonce {

    my @charset = ('a' .. 'z', '0' .. '9');
    my $nonce = '';
    for (1 .. 30) {
        $nonce .= $charset[rand @charset];
    }
    return $nonce;
}

sub get_request_token {

    my ($self, %args) = @_;
    my $callback_url = delete $args{callback_url};

    my $request = Net::OAuth->request("request token")->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => $self->consumer_secret,
        request_url      => $self->site . $self->request_token_path,
        request_method   => $self->request_method,
        signature_method => $self->signature_method,
        timestamp        => time(),
        nonce            => $self->_gen_nonce,
    );
    $request->sign;

    my $res = $self->ua->request(POST $request->{request_url},
        Content => $request->to_post_body);
    if ($res->is_success) {
        my $res_content =
          Net::OAuth->response('request token')
          ->from_post_body($res->content);

        $self->request_token($res_content->token);
        $self->request_token_secret($res_content->token_secret);

    } else {
        croak $res->status_line;
    }
}

sub get_access_token {

    my $self    = shift;
    my $request = Net::OAuth->request("Access Token")->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => $self->consumer_secret,
        token            => $self->request_token,
        token_secret     => $self->request_token_secret,
        signature_method => $self->signature_method,
        timestamp        => time(),
        nonce            => $self->_gen_nonce,
        request_method   => 'POST',
        request_url      => $self->site . $self->access_token_path,
    );
    $request->sign;

    my $res = $self->ua->request(POST $request->{request_url},
        Content => $request->to_post_body);
    if ($res->is_success) {
        my $res_content =
          Net::OAuth->response('access token')->from_post_body($res->content);

        $self->access_token($res_content->token);
        $self->access_token_secret($res_content->token_secret);
        $self->authorized(1);

    } else {
        croak $res->status_line;
    }
}

sub mana_protected_resource {

    my ($self, %args) = @_;
    my $request = Net::OAuth->request('Protected Resource')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => $self->consumer_secret,
        token            => $self->access_token,
        token_secret     => $self->access_token_secret,
        signature_method => $self->signature_method,
        timestamp        => time(),
        nonce            => $self->_gen_nonce,
        request_method   => $args{method},
        request_url      => $args{request_url},
    );
    $request->sign;

    if ($args{method} eq 'GET') {
        my $http_request =
          HTTP::Request->new($args{method}, $request->to_url);
        return $self->ua->request($http_request);

    } else {

        my $header = HTTP::Headers->new(
            'Authorization' =>
              $request->to_authorization_header($self->realm),
            @{$args{headers}},
        );

        my $http_request =
          HTTP::Request->new($args{method}, $request->request_url, $header,
            $args{content});
        return $self->ua->request($http_request);
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

Net::Douban::OAuth::Consumer

=head1 VERSION

version 1.03

=head1 DESCRIPTION

consumer client for Net::Douban

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.
