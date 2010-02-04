package Net::Douban::OAuth::Consumer;
our $VERSION = '0.23';
use Net::OAuth;
use LWP::UserAgent;
use HTTP::Request::Common;
use HTTP::Request;
use HTTP::Headers;
use Carp qw/croak carp/;
use Moose;

has 'ua' => (
    is      => 'rw',
    default => sub {
        require LWP::UserAgent;
        LWP::UserAgent->new;
    }
);

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
    is       => 'rw',
    isa      => 'Str',
    required => 1,
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
        nonce            => $self->_get_nonce,

#        nonce            => $self->_get_nonce,
    );
    $request->sign;
### request_url : $request->{request_url}
    my $res = $self->ua->request(POST $request->{request_url},
        Content => $request->to_post_body);
    if ($res->is_success) {
        my $res_content =
          Net::OAuth->response('request token')
          ->from_post_body($res->content);

        $self->request_token($res_content->token);
        $self->request_token_secret($res_content->token_secret);
        print $self->authorize_url . '/?oauth_token=' . $self->request_token;

        <>;

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
        nonce            => $self->_get_nonce,
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

    } else {
        croak $res->status_line;
    }
}

sub get_protected_resource {

    my ($self, %args) = @_;
    my $request = Net::OAuth->request('Protected Resource')->new(
        consumer_key     => $self->consumer_key,
        consumer_secret  => $self->consumer_secret,
        token            => $self->access_token,
        token_secret     => $self->access_token_secret,
        signature_method => $self->signature_method,
        timestamp        => time(),
        nonce            => $self->_get_nonce,
        request_method   => $args{method},
        request_url      => $args{request_url},
    );
    $request->sign;
    my $header =
      HTTP::Headers->new('Authoriztion' => $request->to_authorization_header);
    my $http_request =
      HTTP::Request->new($args{method}, $args{request_url}, $header,
        $args{content});
    return $self->ua->request($http_request);
}

sub _get_nonce {
    my @charset = ('a' .. 'z', '0' .. '9');
    my $nonce = '';
    for (1 .. 30) {
        $nonce .= $charset[rand @charset];
    }
    return $nonce;
}
__PACKAGE__->meta->make_immutable;
1;
