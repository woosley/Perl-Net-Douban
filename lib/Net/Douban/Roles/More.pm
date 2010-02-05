package Net::Douban::Roles::More;
our $VERSION = '0.41';

use Carp qw/carp croak/;
use Scalar::Util qw/blessed/;
use Moose::Role;

with 'Net::Douban::Roles' => {excludes => ['apikey']};

has 'apikey' => (
    is       => 'rw',
    required => 1,
    isa      => 'Str',
);

has 'wo' => (is => 'ro',);

has 'base_url' => (
    is      => 'ro',
    default => 'http://api.douban.com',
);

has 'user_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/people',
);

has 'collection_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/collection',
);

has 'subject_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/subject',
);

has 'review_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/review',
);

has 'miniblog_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/miniblog',
);

has 'note_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/note',
);

has 'event_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/event',
);

has 'recommendation_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/recommendation',
);

has 'doumail_url' => (
    is      => 'ro',
    default => "http://api.douban.com/doumail",
);

has 'token_url' => (
    is      => 'ro',
    default => 'http://api.douban.com/access_token',
);

sub get {
    my $self = shift;
    my $url  = shift;
    my %args = @_;
    my $response;
    if ($self->has_oauth) {
        $url = $self->build_url($url, %args);
        $response = $self->oauth->get(url => $url) or croak $!;
    } else {
        $args{apikey} ||= $self->apikey;
        $url = $self->build_url($url, %args);
        $response = $self->ua->get($url);
    }
    croak $response->status_line unless $response->is_success;
    my $xml = $response->decoded_content;
    return \$xml;
}

sub post {
    my ($self, $url, $xml) = @_;
    if ($self->has_oauth) {
        my $response;
        if (definded $xml) {
            $response = $self->oauth->post(
                url     => $url,
                headers => ['Content-Type' => q{application/atom+xml}],
                content => $xml,
            ) or croak $!;
            croak $response->status_line unless $response->is_success;
            return $response->status_line;
        } else {
            $response = $self->oauth->post(url => $url,) or croak $!;
            croak $response->status_line unless $response->is_success;
            return $response->status_line;
        }
    } else {
        croak "Authen needed!";
    }
}

sub put {
    my ($self, $url, $xml) = @_;
    if ($self->has_oauth) {
        my $response = $self->oauth->put(
            url     => $url,
            headers => ['Content-Type' => q{application/atom+xml}],
            content => $xml,
        ) or croak $!;
        croak $response->status_line unless $response->is_success;
        return $response->status_line;
    } else {
        croak "Authen needed!";
    }
}

sub delete {
    my ($self, $url) = @_;
    if ($self->has_oauth) {
        my $response = $self->oauth->delete(url => $url,) or croak $!;
        croak $response->status_line unless $response->is_success;
        return $response->status_line;
    } else {
        croak "Authen needed!";
    }
}

sub build_url {
    my $self = shift;
    my $url  = shift;
    my %args = @_;
    my $mark = $url =~ /\?/ ? '&' : '?';
    while (my ($key, $value) = each %args) {
        $url .= $mark . "$key=$value";
        $mark = '&';
    }
    return $url;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=pod
=head1 NAME

    Net::Douban::Roles::More

=head1 VERSION

version 0.41

=cut
