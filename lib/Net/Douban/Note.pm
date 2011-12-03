package Net::Douban::Note;

use Moose::Role;
use Carp qw/carp croak/;
use Net::Douban::Utils;
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

_build_method(__PACKAGE__, %api_hash);
1;

__END__

=pod

=head1 NAME

Net::Douban::Note

=head1 SYNOPSIS

    my $c = Net::Douban->init(Roles => 'Note');

=head1 DESCRIPTION

Interface to douban.com API Note section

=head1 METHODS

=over

=item B<get_note>

argument:   noteID

=item B<get_user_notes>

argument:   userID

=item B<delete_note>

argument:   noteID

=item B<post_note>

argument:   content, title 

=item B<put_note>

argument:   content, title, noteID

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Gift> L<Moose>
L<http://www.douban.com/service/apidoc/reference/note>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 - 2011 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
