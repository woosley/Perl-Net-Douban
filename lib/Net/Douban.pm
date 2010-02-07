package Net::Douban;
our $VERSION = '0.91';

use Moose;
use Env qw/HOME/;
use Carp qw/carp croak/;

with 'Net::Douban::Roles';
has 'oauth' => (is => 'rw');

#my $oauth;    ## magic global variable
## use this to enable globle value
#sub oauth {
#    my $self = shift;
#    if (@_) {
#        $oauth = shift;
#        return \$oauth;
#    } else {
#        return \$oauth;
#    }
#}

#around 'oauth' => sub {
#    my $orig = shift;
#    my $self = shift;
#    if(@_){
#        $oauth = shift;
#        return \$oauth;
#    }else{
#        return \$oauth;
#    }
#};

our $AUTOLOAD;

sub AUTOLOAD {
    my $self = shift;
    (my $name = $AUTOLOAD) =~ s/.*:://g;
    return if $name eq 'DESTORY';
    if ($name eq 'OAuth') {
        require Net::Douban::OAuth;
        return "Net::Douban::OAuth"->new(
            $self->args,
            instance => $self,
            @_,
        );
    }
    if (grep {/^$name$/}
        qw/User Note Tag Collection Recommendation Event Review Subject Doumail Miniblog OAuth/
      )
    {
        my $class = "Net::Douban::$name";
        eval "require $class";
        my $obj = "Net::Douban::$name"->new($self->args, @_,);
        return $obj;
    }
    croak "Unknow Method!";
}

sub DESTORY { }

#deprecated in order to keep it simple
#around 'BUILDARGS' => sub {
#    my $orig = shift;
#    my $self = shift;
#    my %args = @_;
#    my $auth = delete $args{oauth} if exists $args{oauth};
#    $oauth = $auth;
#    $self->$orig(%args);
#};
#
no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=pod

=head1 NAME1

Net::Douban

=head1 VERSION

version 0.91

=cut
