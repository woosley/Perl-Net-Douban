package Net::Douban::Collection;

use Moose;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
with 'Net::Douban::Roles';
use namespace::autoclean;

our %api_hash = (
    get_collection => {
        path          => '/collection/{collectionID}',
        method        => 'GET',
        has_url_param => '1',
    },

    get_user_collection => {
        path            => '/people/{userID}/collection',
        optional_params => [qw/cat tag status updated-max updated-min/],
        method          => 'GET',
        has_url_param   => '1',
    },

    delete_collection => {
        path          => '/collection/{collectionID}',
        has_url_param => '1',
        method        => 'DELETE',
    },

    put_collection => {
        path          => '/collection/{collectionID}',
        has_url_param => '1',
        method        => 'PUT',
        _build_content => \&__check_private_tag,
        content_params =>
          ['rating', 'content', 'subjectID', 'status', 'collectionID'],
        content => <<'EOF',
PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4gPGVudHJ5IHhtbG5zOm5zMD0i
aHR0cDovL3d3dy53My5vcmcvMjAwNS9BdG9tIiB4bWxuczpkYj0iaHR0cDovL3d3dy5kb3ViYW4u
Y29tL3htbG5zLyI+IDxpZD5odHRwOi8vYXBpLmRvdWJhbi5jb20vY29sbGVjdGlvbi97Y29sbGVj
dGlvbklEfTwvaWQ+IDxkYjpzdGF0dXM+e3N0YXR1c308L2RiOnN0YXR1cz4ge3RhZ3N9IDxnZDpy
YXRpbmcgeG1sbnM6Z2Q9Imh0dHA6Ly9zY2hlbWFzLmdvb2dsZS5jb20vZy8yMDA1IiB2YWx1ZT0i
e3JhdGluZ30iIC8+IDxjb250ZW50Pntjb250ZW50fTwvY29udGVudD4gPGRiOnN1YmplY3Q+IDxp
ZD5odHRwOi8vYXBpLmRvdWJhbi5jb20vbW92aWUvc3ViamVjdC97c3ViamVjdElEfTwvaWQ+IDwv
ZGI6c3ViamVjdD4ge3ByaXZhdGV9IDwvZW50cnk+Cg==
EOF

    },

    post_collection => {
        path           => '/collection',
        method         => 'POST',
        content_params => ['rating', 'content', 'subjectID', 'status'],
        _build_content => \&__check_private_tag,
        content        => <<'EOF',
PD94bWwgdmVyc2lvbj0nMS4wJyBlbmNvZGluZz0nVVRGLTgnPz4gPGVudHJ5IHhtbG5zOm5zMD0i
aHR0cDovL3d3dy53My5vcmcvMjAwNS9BdG9tIiB4bWxuczpkYj0iaHR0cDovL3d3dy5kb3ViYW4u
Y29tL3htbG5zLyI+IDxkYjpzdGF0dXM+e3N0YXR1c308L2RiOnN0YXR1cz4ge3RhZ3N9IDxnZDpy
YXRpbmcgeG1sbnM6Z2Q9Imh0dHA6Ly9zY2hlbWFzLmdvb2dsZS5jb20vZy8yMDA1IiB2YWx1ZT0i
e3JhdGluZ30iIC8+IDxjb250ZW50Pntjb250ZW50fTwvY29udGVudD4gPGRiOnN1YmplY3Q+IDxp
ZD5odHRwOi8vYXBpLmRvdWJhbi5jb20vbW92aWUvc3ViamVjdC97c3ViamVjdElEfTwvaWQ+IDwv
ZGI6c3ViamVjdD4ge3ByaXZhdGV9IDwvZW50cnk+IAo=
EOF
    },
);

sub __check_private_tag {
    my ($content, $args) = @_;
    if ($args->{private}) {
        my $entry = '<db:attribute name="privacy">private</db:attribute>';
        $content =~ s/{private}/$entry/g;
    }else{
        my $entry = '<db:attribute name="privacy">public</db:attribute>';
        $content =~ s/{private}/$entry/g;
    }
    if (my $tags = $args->{tags}) {
        my @tags = ref $args ? @$tags : ($tags);
        my $entry = join " ", map { '<db:tag name="' . $_ . '" />' } @tags;
        $content =~ s/{tags}/$entry/;
    }
    return $content;
}

__PACKAGE__->_build_method(%api_hash);
__PACKAGE__->meta->make_immutable;
1;

__END__

=pod

=head1 NAME

    Net::Douban::Collection

=head1 SYNOPSIS

	use Net::Douban::Collection;
	my $coll = Net::Douban::Collection->new(
        
		collectionID => '....',
        # or
        oauth => $consumer,
	);

=head1 DESCRIPTION

Interface to douban.com API collection section

=head1 METHODS

=over

=item B<get_collection>

=item B<get_user_collection>

=item B<add_collection>

=item B<put_collection>

=item B<delete_collection>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> L<http://www.douban.com/service/apidoc/reference/collection>

=head1 AUTHOR

woosley.xu<woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
