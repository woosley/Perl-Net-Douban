package Net::Douban::Roles::More;
our $VERSION = '0.11';

use Carp qw/carp croak/;
use Scalar::Util qw/blessed/;
use Any::Moose 'Role';

#use Moose::Role;
with 'Net::Douban::Roles';

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

sub get {
    my $self = shift;
    my $url  = shift;
    my %args = @_;
    croak "Use get on a unblessed value" unless blessed $self;
    my $response;
    if ( $self->oauth && $self->token ) {
        $url = $self->build_url( $url, %args );
        $response = $self->oauth->request(
            method => 'GET',
            url    => $url,
            token  => $self->token,
        ) or croak $!;
    }
    else {
        $args{apikey} ||= $self->apikey;
        $url = $self->build_url( $url, %args );
        $response = $self->ua->get($url);
    }
    croak $response->status_line unless $response->is_success;
    my $xml = $response->decoded_content;
    return \$xml;
}

sub build_url {
    my $self = shift;
    my $url  = shift;
    my %args = @_;
    my $mark = $url =~ /\?/ ? '&' : '?';
    while ( my ( $key, $value ) = each %args ) {
        $url .= $mark . "$key=$value";
        $mark = '&';
    }
    return $url;
}

no Any::Moose;
1;
