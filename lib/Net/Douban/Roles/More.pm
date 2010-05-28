package Net::Douban::Roles::More;

use Carp qw/carp croak/;
use Scalar::Util qw/blessed/;
use Moose::Role;

with 'Net::Douban::Roles';

has 'base_url' => (
    is      => 'rw',
	isa 	=> 'Url',
    default => 'http://api.douban.com',
);

has 'user_url' => (
    is      => 'rw',
	isa		=> 'Url',
    default => 'http://api.douban.com/people',
);

sub get {
    my $self = shift;
    my $url  = shift;
    my %args = @_;
    my $response;
    if ($self->has_oauth) {
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
    if ($self->has_oauth) {
        my $response;
        if ($args{xml}) {
            $response =
              $self->oauth->post($url, $args{xml},
                ['Content-Type' => q{application/atom+xml}],
              ) or croak $!;
            croak $response->status_line unless $response->is_success;
        } else {
            $response = $self->oauth->post(url => $url) or croak $!;
            croak $response->status_line unless $response->is_success;
        }
        return $response;
    } else {
        croak "Authen needed!";
    }
}

sub put {
    my ($self, $url, %args) = @_;
    if ($self->has_oauth) {
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
    if ($self->has_oauth) {
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
		$key =~ s/-/_/g;
        $url .= $mark . "$key=$value";
        $mark = '&';
    }
    return $url;
}

no Moose::Role;
1;
__END__


