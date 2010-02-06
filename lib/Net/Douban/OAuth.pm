package Net::Douban::OAuth;
our $VERSION = '0.61';
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

####不能new?
#sub new_authorized {
#    my ($self, %args) = @_;
#    $self->BUILD(%args);
#    $args{consumer_key} = delete $args{apikey};
#    $args{consumer_secret} = delete $args{private_key};
#    my $consumer = Net::Douban::OAuth::Consumer->new(
#        authorized => 1,
#        %args,
#    );
#    $self->consumer($consumer);
#    $self->authorized(1);
#    return $self;
#}

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

1;

__END__

=pod
=head1 NAME

    Net::Douban::OAuth;

=head1 VERSION

version 0.61

=cut
