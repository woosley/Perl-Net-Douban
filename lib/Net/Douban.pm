package Net::Douban;
our $VERSION = '0.23';

use Moose;
use Env qw/HOME/;
use Carp qw/carp croak/;

with 'Net::Douban::Roles';

our $AUTOLOAD;

sub AUTOLOAD {
    my $self = shift;
    (my $name = $AUTOLOAD) =~ s/.*:://g;
    return if $name eq 'DESTORY';
    if ($name eq 'Token') {
        require Net::Douban::Token;
        return "Net::Douban::$name"->new(
            $self->args,
            instance => $self,
            @_,
        );
    }
    if (grep {/^$name$/}
        qw/User Note Tag Collection Recommendation Event Review Subject Doumail Miniblog/
      )
    {
        my $class = "Net::Douban::$name";
        eval " require  $class ";
        return "Net::Douban::$name"->new($self->args, @_,);
    }
    croak "Unknow Method!";
}

sub DESTORY { }

sub authen {
    eval { require OAuth::Lite::Consumer };
    if ($@) {
        croak "Failed to load OAuth::Lite::Consumer.\n";
    }
    my $self        = shift;
    my %args        = @_;
    my $api_key     = $args{apikey} || $self->apikey;
    my $private_key = $args{private_key} || $self->private_key;
    croak "key needed\n" unless $api_key || $private_key;

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
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=pod

=head1 NAME1

Net::Douban

=head1 VERSION

version 0.01

=cut
