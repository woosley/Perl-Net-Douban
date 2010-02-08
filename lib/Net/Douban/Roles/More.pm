package Net::Douban::Roles::More;
our $VERSION = '1.03';

use Carp qw/carp croak/;
use Scalar::Util qw/blessed/;
use Moose::Role;

with 'Net::Douban::Roles';

#has 'wo' => (is => 'ro',);

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
    if ($self->oauth) {
        $url = $self->build_url($url, %args);
        $response = $self->oauth->get($url) or croak $!;
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
    my ($self, $url, %args) = @_;
    if ($self->oauth) {
        my $response;
        if ($args{xml}) {
            $response =
              $self->oauth->post($url, $args{xml},
                ['Content-Type' => q{application/atom+xml}],
              ) or croak $!;
            croak $response->status_line unless $response->is_success;
        } else {
            $response = $self->oauth->post(url => $url,) or croak $!;
            croak $response->status_line unless $response->is_success;
        }
        return $response;
    } else {
        croak "Authen needed!";
    }
}

sub put {
    my ($self, $url, %args) = @_;
    if ($self->oauth) {
        my $response =
          $self->oauth->put($url, $args{xml},
            ['Content-Type' => q{application/atom+xml}],
          ) or croak $!;
        croak $response->status_line unless $response->is_success;
        return $response;
    } else {
        croak "Authen needed!";
    }
}

sub delete {
    my ($self, $url, %args) = @_;
    if ($self->oauth) {
        my $response = $self->oauth->delete($url,) or croak $!;
        croak $response->status_line unless $response->is_success;
        return $response;
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

no Moose::Role;
1;
__END__

=pod

=head1 NAME

    Net::Douban::Roles::More

=head1 VERSION

version 1.03

=cut
