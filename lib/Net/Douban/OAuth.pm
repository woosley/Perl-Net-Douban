package Net::Douban::OAuth;
our $VERSION = '0.23';
use Moose;
use OAuth::Lite::Consumer;

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

has 'oauth' => (
    is  => 'rw',
    isa => 'OAuth::Lite::Consumer||Undef',
);

# do the authentication
sub authen {
    my $self        = shift;
    my $api_key     = $self->apikey;
    my $private_key = $self->private_key;

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

    my $access_token = $consumer->get_access_token(token => $request_token);
    $self->oauth($consumer);
    $self->token($access_token);

#my $res = $consumer->request(
#    method  => 'POST',
#    url     => qq{http://api.douban.com/miniblog/saying},
#    token   => $access_token,
#    headers => [ 'Content-Type' => q{application/atom+xml} ],
#    content => qq{<entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/"><content>Perl OAuth 认证成功</content></entry>},
#);
#

}
