package Net::Douban::OAuth;
our $VERSION = '0.41';
use Moose;
use Net::Douban::OAuth::Consumer;

has 'apikey' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'private_key' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'consumer' => (
    is         => 'rw',
    lazy_build => 1,
);

has 'site' => (
    is      => 'rw',
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

sub build_consumer {

    my $self = shift;
    return Net::Douban::OAuth::Consumer->new(
        consumer_key       => $self->apikey,
        consumer_secret    => $self->private_key,
        request_token_path => $self->request_token_path,
        access_token_path  => $self->access_token_path,
    );
}

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

    if ($content) {
        return $self->consumer->mana_protected_resource(
            method      => 'POST',
            request_url => $request_url,
        );
    } else {
        push @{$header}, 'Content-Type' => 'application/atom+xml';
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
    push @{$header}, 'Content-Type' => 'application/atom+xml';

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

1;

__END__

=pod
=head1 NAME

    Net::Douban::OAuth;

=head1 VERSION

version 0.41

=cut
