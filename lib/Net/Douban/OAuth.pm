package Net::Douban::OAuth;
use Moose::Role;
use Carp qw/carp croak/;
use Net::OAuth;
#use namespace::autoclean;
use HTTP::Request::Common qw/PUT DELETE POST GET/;

for my $rw_attr (
    qw/consumer_key consumer_secret request_token request_token_secret
    access_token access_token_secret paste_url oauth_version extra_params/
  )
{
    has $rw_attr => (is => 'rw');
}

for my $ro_attr (qw/request_url access_url authorize_url/) {
    has $ro_attr => (is => 'ro');
}

has 'ua' => (is => 'rw', lazy_build => 1);


sub get_request_token {
    my $self = shift;
    my %args = @_;
    $self->_get_token(
        'request token',
        consumer_secret => $self->consumer_secret,
        request_url     => $self->request_url,
        (@_),
    );
    $self->paste_url(
            $self->authorize_url 
          . '/?oauth_token=' 
          . $self->request_token
          . (
            $args{callback_url}
            ? '&oauth_callback=' . $args{callback_url}
            : ""
          )
    );
}

sub get_access_token {
    my $self = shift;
    $self->_get_token(
        'access token',
        consumer_secret => $self->consumer_secret,
        token           => $self->request_token,
        token_secret    => $self->request_token_secret,
        request_url     => $self->access_url,
        (@_),
    );
}

sub _get_token {
    my $self    = shift;
    my $type    = shift;
    my $request = $self->_get_request($type, 'POST', @_);
    my $res     = $self->ua->request(POST $request->to_url);
    if (!$res->is_success) {
        croak $res->status_line;
        return;
    } else {
        $self->_store_token($type, $res);
    }
}

sub _get_request {
    my $self = shift;
    my ($type, $method, %args) = @_;

    my $request = Net::OAuth->request($type)->new(
        consumer_key => $self->consumer_key,
        %args,
        timestamp        => time,
        nonce            => _gen_nonce(),
        signature_method => 'HMAC-SHA1',
        request_method   => $method,
        protocal_version => $self->oauth_version
          && $self->oauth_version eq '1.0a'
        ? Net::OAuth::PROTOCOL_VERSION_1_0A
        : Net::OAuth::PROTOCOL_VERSION_1_0,
    );
    $request->sign;
    $request;
}

sub _gen_nonce {
    return time ^ $$ ^ int(rand 2 ^ 32);
}

sub load_token {
    my ($self, %tokens) = @_;
    for my $token_name (keys %tokens) {
        eval { $self->$token_name($tokens{$token_name}) };
        carp "Warninng: skipped $token_name, $@" if $@;
    }
}

sub _store_token {
    my ($self, $type, $res) = @_;
    my $mesg = Net::OAuth->response($type)->from_post_body($res->content);
    $type =~ s/\s+/_/g;
    $self->$type($mesg->token);
    $type .= '_secret';
    $self->$type($mesg->token_secret);
}

sub _restricted_request {
    my $self        = shift;
    my $method      = uc shift;
    my %args        = @_;
    my $request_url = delete $args{request_url};

    #my $extra   = $self->_tip_extra(\%args);
    my $request = $self->_get_request(
        'protected resource', $method,
        consumer_secret => $self->consumer_secret,
        token           => $self->access_token,
        token_secret    => $self->access_token_secret,
        request_url     => $request_url,
        extra_params    => $method eq 'GET' ? \%args : {},
    );

    my $http_request;
    if ($method eq 'GET') {
        $http_request = HTTP::Request->new($method, $request->to_url);
    } else {
        no strict 'refs';
        $http_request = $method->(
            $request->request_url,
            Authorization =>
              $request->to_authorization_header($self->realm),
            %args,
        );
    }
    $self->ua->request($http_request);
}

sub _build_ua {
    eval { require LWP::UserAgent };
    if ($@) {
        croak "LWP::UserAgent not found $@";
    }
    my $ua = LWP::UserAgent->new();
    $ua->env_proxy;
    $ua;
}

1;
__END__

=pod

=head1 NAME

Net::Douban::OAuth - OAuth for Net::Douban

=head1 SYNOPSIS

    use Net::Douban;
    
    my $c = Net::Douban->new(
        consumer_key => 'CONSUMER_KEY',
        consumer_secret => 'CONSUMER_SECRET',
    );

    $social->get_request_token(callback_url = $callback_url);

    ## get you user to this url
    print $social->paste_url;
    <>;

    $social->get_access_token;

    #then you can use this object to access user data
    
    
=head1 METHODS

=head2 get_request_token

=head2 get_access_token

=head1 AUTHOR

woosley.xu, C<< <woosley.xu at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2010 - 2011 woosley.xu.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.

=cut
