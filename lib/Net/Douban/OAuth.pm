package Net::Douban::OAuth;
use Moose;
use Carp qw/carp croak/;
use Net::Douban::OAuth::Consumer;

has 'comsumer_key' => (
    is  => 'ro',
    isa => 'Str',
);

has 'consumer_secret' => (
    is  => 'ro',
    isa => 'Str',
);

has 'consumer' => (
    is      => 'rw',
    default => \&_build_consumer,
);

has 'site' => (
    is      => 'rw',
	isa		=> 'Str',
    default => 'http://www.douban.com',
);

has 'request_token_path' => (
    is      => 'rw',
    default => '/service/auth/request_token',
);

has 'access_token_path' => (
    is      => 'rw',
    default => '/service/auth/access_token',
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

around 'BUILDARGS' => sub {
    my $orig = shift;
    my $self = shift;
    my %args = @_;

    if (   $args{access_token}
        || $args{access_token_secret}
        || $args{request_token}
        || $args{request_token_secret})
    {
        my $consumer = Net::Douban::OAuth::Consumer->new(%args);
        return $self->$orig(@_, consumer => $consumer);
    }
    return $self->$orig(@_);
};

sub request_token {
    shift->consumer->get_request_token;
}

sub access_token {
    shift->consumer->get_access_token;
}

sub get {
    my $self = shift;
    croak "unauthorized" unless $self->consumer->authorized;
    (my $request_url = shift) or croak "url needed";

    return $self->consumer->mana_protected_resource(
        method      => 'GET',
        request_url => $request_url,
    );
}

sub post {
    my $self = shift;
    croak "unauthorized" unless $self->consumer->authorized;
    my ($request_url, $content, $header) = @_;
    croak "Url needed" unless $request_url;

    unless ($content) {
        return $self->consumer->mana_protected_resource(
            method      => 'POST',
            request_url => $request_url,
        );
    } else {
        return $self->consumer->mana_protected_resource(
            method      => 'POST',
            request_url => $request_url,
            content     => $content,
            headers     => $header,
        );
    }
}

sub put {
    my $self = shift;
    croak "unauthorized" unless $self->consumer->authorized;
    my ($request_url, $content, $header) = @_;
    croak "Url/content needed" unless $request_url && $content;

    return $self->consumer->mana_protected_resource(
        method      => 'PUT',
        request_url => $request_url,
        content     => $content,
        headers     => $header,

    );
}

sub delete {
    my ($self, $request_url) = @_;
    croak "unauthorized" unless $self->consumer->authorized;
    croak "Url needed"   unless $request_url;

    return $self->consumer->mana_protected_resource(
        method      => 'DELETE',
        request_url => $request_url,
    );
}

sub validate {

    # to do
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
        site => ,
        request_token_path => ,
        access_token_path =>, 
    );

    $oauth->request_token;
    $oauth->access_token;


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
    
L<Net::Douban> L<Moose> L<Net::OAuth> L<http://douban.com/service/apidoc>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT & LICENSE

This software is copyright (c) 2010 by woosley.xu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
