package Net::Douban::OAuth;

use Moose;
use Carp qw/carp croak/;
use Net::Douban::OAuth::Consumer;

has 'consumer_key' => (
    is  => 'ro',
    isa => 'Str',
);

has 'access_token_url' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://api.douban.com/access_token',
);

has 'consumer_secret' => (
    is  => 'ro',
    isa => 'Str',
);

has 'consumer' => (
    is      => 'rw',
    lazy    => 1,
    default => \&_build_consumer,
);

has 'site' => (
    is      => 'rw',
    isa     => 'Maybe[Str]',
    default => 'http://www.douban.com',
);

has 'request_token_path' => (
    is      => 'rw',
    isa     => 'Maybe[Str]',
    default => '/service/auth/request_token',
);

has 'authorize_path' => (
    is      => 'rw',
    isa     => 'Maybe[Str]',
    default => '/service/auth/authorize',
);

has 'access_token_path' => (
    is      => 'rw',
    isa     => 'Maybe[Str]',
    default => '/service/auth/access_token',
);

has 'authorize_url' => (
    is       => 'rw',
    isa      => 'Maybe[Str]',
    init_arg => undef,
);

has 'callback_url' => (
    is        => 'rw',
    isa       => 'Maybe[Str]',
    predicate => 'has_callback',
);

sub _build_consumer {

    my $self = shift;

    return Net::Douban::OAuth::Consumer->new(
        consumer_key       => $self->consumer_key,
        consumer_secret    => $self->consumer_secret,
        request_token_path => $self->request_token_path,
        access_token_path  => $self->access_token_path,
        site               => $self->site,
    );
}

sub BUILD {
    my ($self, $arg) = @_;
    my %args = %{$arg};

    if (   $args{access_token}
        || $args{access_token_secret}
        || $args{request_token}
        || $args{request_token_secret})
    {
        $args{request_token_path} ||= $self->request_token_path;
        $args{access_token_path}  ||= $self->access_token_path;
        $args{site}               ||= $self->site;
        my $consumer = Net::Douban::OAuth::Consumer->new(%args);
        $self->consumer($consumer);
    }
}

sub request_token {
    my $self = shift;
    $self->consumer->get_request_token;
    my $url =
        $self->site
      . $self->authorize_path
      . '?oauth_token='
      . $self->consumer->request_token;
    $url .= '&oauth_callback=' . $self->callback_url if $self->has_callback;
    $self->authorize_url($url);
}

sub access_token {
    shift->consumer->get_access_token;
}

sub get {
    my $self = shift;
    croak "unauthorized" unless $self->consumer->authorized;
    (my $request_url = shift) or croak "url needed";

    my $res = $self->consumer->mana_protected_resource(
        method      => 'GET',
        request_url => $request_url,
    );
    croak $res->status_line unless $res->is_success;
    return $res;
}

sub post {
    my $self = shift;
    croak "unauthorized" unless $self->consumer->authorized;
    my ($request_url, $content, $header) = @_;
    croak "Url needed" unless $request_url;

    my $res;
    unless ($content) {
        $res = $self->consumer->mana_protected_resource(
            method      => 'POST',
            request_url => $request_url,
        );
    } else {
        $res = $self->consumer->mana_protected_resource(
            method      => 'POST',
            request_url => $request_url,
            content     => $content,
            headers     => $header,
        );
    }

    croak $res->status_line unless $res->is_success;
    return $res;
}

sub put {
    my $self = shift;
    croak "unauthorized" unless $self->consumer->authorized;
    my ($request_url, $content, $header) = @_;
    croak "Url/content needed" unless $request_url && $content;

    my $res = $self->consumer->mana_protected_resource(
        method      => 'PUT',
        request_url => $request_url,
        content     => $content,
        headers     => $header,

    );

    croak $res->status_line unless $res->is_success;
    return $res;
}

sub delete {
    my ($self, $request_url) = @_;
    croak "unauthorized" unless $self->consumer->authorized;
    croak "Url needed"   unless $request_url;

    my $res = $self->consumer->mana_protected_resource(
        method      => 'DELETE',
        request_url => $request_url,
    );

    croak $res->status_line unless $res->is_success;
    return $res;
}

sub validate {
    my $self = shift;
    my $token = shift || $self->consumer->access_token;
    eval { $self->get($self->access_token_url . "/$token") };
    return if $@;
    return 1;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

    Net::Douban::OAuth - OAuth object for Net::Douban

=head1 SYNOPSIS
    
    my $oauth = Net::Douban::OAuth->new(
        consumer_key => ,
        consumer_secret => ,
    );

    $oauth->callback_url($url);
    $oauth->request_token;
    print $oauth->authorize_url; # paste this url to your user
    $oauth->access_token; # now this object is authorized 
    $agent = Net::Douban->new(oauth => $oauth);

=head1 DESCRIPTION
    
OAuth object for douban.com base on L<Net::OAuth>

=head1 METHOD

=over 4

=item B<new>

Create the OAuth object for authentication. If the authenticated tokens are passed as the arguments, do remember to pass authorized => 1 too.

=item B<request_token>

get request token into $oauth->consumer

=item B<access_token>
    
get access_token into $oauth->consumer

=item B<HTTP Request Methods>
    
    get
    post
    put
    delete

=back

=head1 SEE ALSO
    
L<Net::Douban> L<Moose> L<Net::OAuth> L<http://douban.com/service/apidoc/auth>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT & LICENSE

This software is copyright (c) 2010 by woosley.xu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
