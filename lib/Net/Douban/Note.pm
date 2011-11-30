package Net::Douban::Note;

use Moose::Role;
use MooseX::StrictConstructor;
use Carp qw/carp croak/;
requires '_build_method';
use namespace::autoclean;

our %api_hash = (

    get_note => {
        path      => '/note/{noteID}',
        has_url_param => 1,
        method    => 'GET',
    },

    get_user_notes => {
        has_url_param => 1,
        path      => '/people/{userID}/notes',
        method    => 'GET',
    },

    post_note => {
        path           => '/notes',
        method         => 'POST',
        content_params => ['content', 'title'],
        _build_content => \&__check_private_reply,
        content        => <<'EOF',
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4gPGVudHJ5IHhtbG5zPSJodHRw
Oi8vd3d3LnczLm9yZy8yMDA1L0F0b20iIHhtbG5zOmRiPSJodHRwOi8vd3d3LmRvdWJhbi5jb20v
eG1sbnMvIj4gPHRpdGxlPnt0aXRsZX08L3RpdGxlPiA8Y29udGVudD57Y29udGVudH08L2NvbnRl
bnQ+IHtwcml2YXRlfXtjYW5fcmVwbHl9PC9lbnRyeT4K
EOF
    },

    put_note => {
        path           => '/note/{noteID}',
        has_url_param => 1,
        method         => 'PUT',
        content_params => ['content', 'title'],
        _build_content => \&__check_private_reply,
        content        => <<'EOF',
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4gPGVudHJ5IHhtbG5zPSJodHRw
Oi8vd3d3LnczLm9yZy8yMDA1L0F0b20iIHhtbG5zOmRiPSJodHRwOi8vd3d3LmRvdWJhbi5jb20v
eG1sbnMvIj4gPHRpdGxlPnt0aXRsZX08L3RpdGxlPiA8Y29udGVudD57Y29udGVudH08L2NvbnRl
bnQ+IHtwcml2YXRlfXtjYW5fcmVwbHl9PC9lbnRyeT4K
EOF
    },

    delete_note => {
        path      => '/note/{noteID}',
        has_url_param => 1,
        method    => 'DELETE',
    },
);

sub __check_private_reply {
    my ($content, $args) = @_;
    if ($args->{private}) {
        my $entry = '<db:attribute name="privacy">private</db:attribute>';
        $content =~ s/{private}/$entry/g;
    } else{
        my $entry = '<db:attribute name="privacy">public</db:attribute>';
        $content =~ s/{private}/$entry/g;
    }
    if (!exists $args->{can_reply} || $args->{can_reply}) {
        my $entry = '<db:attribute name="can_reply">yes</db:attribute>';
        $content =~ s/{can_reply}/$entry/g;
    } else {
        my $entry = '<db:attribute name="can_reply">no</db:attribute>';
        $content =~ s/{can_reply}/$entry/g;
    }
    return $content;
}

__PACKAGE__->_build_method(%api_hash);
1;

__END__

=pod

=head1 NAME

Net::Douban::Note

=head1 SYNOPSIS

	use Net::Douban::Note;
	$note = Net::Douban::Note->new(
		apikey => '....',
        # or
        oauth => $consumer,
	);

	$atom = $note->get_note(noteID => ... ) 
	$atom = $note->get_user_note(userID => 'Net-Douban');
	$atom = $note->post_note(xml => $xml);

=head1 DESCRIPTION

Interface to douban.com API Note section

=head1 METHODS

Those methods return a Net::Douban::Atom object which can be use to get data conveniently

=over

=item B<get_user>

=item B<get_user_note>

=item B<delet_note>

=item B<post_note>

=item B<put_note>

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Atom> L<Moose> L<XML::Atom> B<http://www.douban.com/service/apidoc/reference/note>

=head1 AUTHOR

woosley.xu<redicaps@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
