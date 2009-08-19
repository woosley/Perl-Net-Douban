package Net::Douban;
our $VERSION = '0.07';

use Any::Moose;

#use Moose;
use Carp qw/carp croak/;
use Net::Douban::User;

with 'Net::Douban::Roles';

#has 'User' => (
#    is      => 'rw',
#    isa     => 'Net::Douban::User',
#    lazy    => 1,
#    default => sub {
#        my $self = shift;
#        my $user = Net::Douban::User->new( $self->args,@_ );
#		print $user;
#		return $user;
#      }
#);

sub User {
    my $self = shift;
    return Net::Douban::User->new( $self->args, @_ );
}

sub authen {
    eval { require OAuth::Lite::Consumer };
    if ($@) {
        croak "Failed to load OAuth::Lite::Consumer.\n";
    }
    my $self        = shift;
    my %args        = @_;
    my $api_key     = $args{apikey} || $self->apikey;
    my $private_key = $args{private_key} || $self->private_key;

    my $consumer = OAuth::Lite::Consumer->new(
        consumer_key       => $api_key,
        consumer_secret    => $private_key,
        site               => q{http://www.douban.com},
        request_token_path => q{/service/auth/request_token},
        access_token_path  => q{/service/auth/access_token},
        authorize_path     => q{/service/auth/authorize},
    ) or die "$!";
    my $request_token = $consumer->get_request_token();

    print
"sent this url to anybody whoes you want to access, ask them to click 'Agree'\n";
    print $consumer->url_to_authorize . "?"
      . $consumer->oauth_response->{'_content'} . "\n\n";
    print "Then press any key to Continue\n";
    <STDIN>;
    print "Please Wait...\n";

    my $access_token = $consumer->get_access_token( token => $request_token );
    $self->oauth($consumer);
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=pod

=head1 NAME1

Net::Douban

=head1 VERSION

version 0.01

=cut
