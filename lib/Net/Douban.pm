package Net::Douban;
use URI;
use Moose;
use Moose::Util::TypeConstraints;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
with 'Net::Douban::OAuth';
with 'MooseX::Traits';
with "Net::Douban::Roles";
use namespace::autoclean;

subtype 'Net::Douban::URI' => as class_type('URI');
coerce 'Net::Douban::URI' => from 'Str' => via { URI->new($_, 'http') };

has 'realm' => (is => 'ro', default => 'www.douban.com');

has 'api_base' => (
    is      => 'rw',
    isa     => 'Net::Douban::URI',
    default => sub { URI->new('http://api.douban.com') },
);

has '+request_url' => (
    is  => 'rw',
    isa => 'Net::Douban::URI',
    default =>
      sub { URI->new('http://www.douban.com/service/auth/request_token') },
);
has '+access_url' => (
    is  => 'rw',
    isa => 'Net::Douban::URI',
    default =>
      sub { URI->new('http://www.douban.com/service/auth/access_token') },
);
has '+authorize_url' => (
    is  => 'rw',
    isa => 'Net::Douban::URI',
    default =>
      sub { URI->new('http://www.douban.com/service/auth/authorize') },
);

sub init {
    my $class = shift;
    my %args  = @_;
    if ($args{Traits} && $args{Roles}) {
        warn "Roles will be ignored when we have Traits";
    }
    if ($args{Traits}) {
        my @traits = ref $args{Traits} ? @{$args{Traits}} : ($args{Traits});
        for my $t (@traits) {
            if ($t =~ s/^\+//g) {
                $class = $class->with_traits($t);
            } else {
                $class = $class->with_traits("Net::Douban::Traits::$t");
            }
        }
    } elsif ($args{Roles}) {
        my @roles = ref $args{Roles} ? @{$args{Roles}} : ($args{Roles});
        $class = $class->with_traits("Net::Douban::$_") foreach @roles;
    } else {
        croak "Without Traits or Roles, I can not do anything";
    }
    delete $args{Roles};
    delete $args{Traits};
    return $class->new(%args);
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=pod

=head1 NAME

Net::Douban - Perl client for douban.com

=head1 SYNOPSIS
    
    use Net::Douban;
    my $client = Net::Douban->init(Traits => 'Gift');
    my $client = Net::Douban->init(Roles => [qw/User Review .../]);
    $client->res_callback(sub{shift});
    
    print $client->get_user_contact(userID => 'Net-Douban')->decoded_content;

=head1 DESCRIPTION

Net::Douban is a perl client wrapper on the Chinese website 'douban.com' API.

=head1 METHODS

=over

=item B<init>

B<init> is the B<new> for C<Net::Douban>. it is here because of
C<MooseX::Traits> limits

    $client = Net::Douban->init(Traits => 'Gift');
    $client = Net::Douban->init(Roles  => 'User');

=back

=head1 OAuth

Here is how to get the tokens before you can access the website
    
    my $c = Net::Douban->init(consumer_key =>'...', consumer_secret =>'...');
    $c->get_request_token;
    ## ask your customer go to this url to allow the access to his account
    print $c->paste_url();
    <>;
    $c->get_access_token;
    ## now you can save those tokens 
    say $c->request_token, $c->request_token_secret, $c->access_token,
        $c->access_token_secret;
   
    ## next time you can load tokens,all tokens are needed, the key for
    the hash is the name of the method.
    $c->load_token(%token_hash);

=head1 API

=head2 Roles

    $client = Net::Douban->init(Roles  => [qw/User Review/]);

B<Roles> are just individual douban  API sections. You can pass B<Roles>
to the constructure, then those sections are loaded to the object.
Avalable roles are qw/User Subject Review Collection Miniblog Note Event
Recommendation Review Doumail Tag/


=head2 Traits

Traits are special Roles, Right now just there is just a
L<Net::Douban::Traits::Gift>, you can write your own trait, refer to
L<Net::Douban::Traits::Gift> to see how to do it.

When you want to use Traits under your own namespace(that is not under
Net::Douban), you should pass it with a '+' in front of the name;

    $c = Net::Douban->init("Traits" => '+My::Trait');

=head2 res_callback

You can use your own res_callback to handle the returned
L<HTTP::Response> object by:

    $client->res_callback(sub{....});

The only argument for this callback is B<$res> return from
L<LWP::UserAgent>. By default, res_callback will return the decoded JSON
hash.

=head2 Paging

Paging is support by passing argments 'start-index' and 'max-results' to
search and get functions.

=head1 SEE ALSO
    
L<Net::Douban::OAuth> L<Net::Douban::Traits::Gift> L<Net::Douban::User>
L<Net::Douban::Utils>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT & LICENSE

This software is copyright (c) 2010 - 2011 by woosley.xu.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
