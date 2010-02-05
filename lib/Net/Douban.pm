package Net::Douban;
our $VERSION = '0.41';

use Moose;
use Env qw/HOME/;
use Carp qw/carp croak/;
with 'Net::Douban::Roles' => {excludes => ['oauth']};

my $oauth;    ## magic global variable
has 'oauth' => (is => 'rw',);

## use this to enable globle value
around 'oauth' => sub {
    my $orgi = shift;
    my $self = shift;
    if (@_) {
        $oauth = shift;
        return \$oauth;
    } else {
        return \$oauth;
    }
};

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

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=pod

=head1 NAME1

Net::Douban

=head1 VERSION

version 0.41

=cut
