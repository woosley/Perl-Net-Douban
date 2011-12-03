package Net::Douban::Doumail;

use Moose::Role;
use Carp qw/carp croak/;
use namespace::autoclean;
use Net::Douban::Utils;

our %api_hash = (
    get_mail_inbox => {
        path   => '/doumail/inbox',
        method => 'GET',
    },

    get_mail_unread => {
        path   => '/doumail/inbox/unread',
        method => 'GET',
    },

    get_mail_outbox => {
        path   => '/doumail/outbox',
        method => 'GET',
    },

    get_mail => {
        path          => '/doumail/{doumailID}',
        has_url_param => 1,
        method        => 'GET',
    },

    post_mail => {
        path           => '/doumails',
        method         => 'POST',
        content_params => ['title', 'content', 'receiver'],
        content        => <<'EOF',
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4gPGVudHJ5IHhtbG5zPSJodHRw
Oi8vd3d3LnczLm9yZy8yMDA1L0F0b20iIHhtbG5zOmRiPSJodHRwOi8vd3d3LmRvdWJhbi5jb20v
eG1sbnMvIiB4bWxuczpnZD0iaHR0cDovL3NjaGVtYXMuZ29vZ2xlLmNvbS9nLzIwMDUiIHhtbG5z
Om9wZW5zZWFyY2g9Imh0dHA6Ly9hOS5jb20vLS9zcGVjL29wZW5zZWFyY2hyc3MvMS4wLyI+IDxk
YjplbnRpdHkgbmFtZT0icmVjZWl2ZXIiPiA8dXJpPmh0dHA6Ly9hcGkuZG91YmFuLmNvbS9wZW9w
bGUve3JlY2VpdmVyfTwvdXJpPiA8L2RiOmVudGl0eT4gPGNvbnRlbnQ+e2NvbnRlbnR9PC9jb250
ZW50PiA8dGl0bGU+e3RpdGxlfTwvdGl0bGU+IHtjYXB0Y2hhX3Rva2VufXtjYXB0Y2hhfSA8L2Vu
dHJ5Pgo=
EOF
        _build_content => \&_check_captcha,

    },

    mark_mail_as_read => {
        path          => '/doumail/{doumailID}',
        has_url_param => 1,
        method        => 'POST',
        content       => <<'EOF',
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4gPGVudHJ5IHhtbG5zPSJodHRw
Oi8vd3d3LnczLm9yZy8yMDA1L0F0b20iIHhtbG5zOmRiPSJodHRwOi8vd3d3LmRvdWJhbi5jb20v
eG1sbnMvIiB4bWxuczpnZD0iaHR0cDovL3NjaGVtYXMuZ29vZ2xlLmNvbS9nLzIwMDUiIHhtbG5z
Om9wZW5zZWFyY2g9Imh0dHA6Ly9hOS5jb20vLS9zcGVjL29wZW5zZWFyY2hyc3MvMS4wLyI+IDxk
YjphdHRyaWJ1dGUgbmFtZT0idW5yZWFkIj5mYWxzZTwvZGI6YXR0cmlidXRlPiA8L2VudHJ5Pgo=
EOF
    },

    mark_mails_as_read => {
        path    => '/doumail/',
        method  => 'PUT',
        content => <<'EOF',
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4gPGZlZWQgeG1sbnM9Imh0dHA6
Ly93d3cudzMub3JnLzIwMDUvQXRvbSIgeG1sbnM6ZGI9Imh0dHA6Ly93d3cuZG91YmFuLmNvbS94
bWxucy8iIHhtbG5zOmdkPSJodHRwOi8vc2NoZW1hcy5nb29nbGUuY29tL2cvMjAwNSIgeG1sbnM6
b3BlbnNlYXJjaD0iaHR0cDovL2E5LmNvbS8tL3NwZWMvb3BlbnNlYXJjaHJzcy8xLjAvIj4ge2Vu
dHJpZXN9IDwvZmVlZD4K
EOF
        _build_content => \&_check_mailID,
    },

    delete_mail => {
        path          => '/doumail/{doumailID}',
        has_url_param => 1,
        method        => 'DELETE',
    },

    delete_mails => {
        path          => '/doumail/delete',
        has_url_param => 1,
        method        => 'POST',
        content       => <<'EOF',
PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4gPGZlZWQgeG1sbnM9Imh0dHA6
Ly93d3cudzMub3JnLzIwMDUvQXRvbSIgeG1sbnM6ZGI9Imh0dHA6Ly93d3cuZG91YmFuLmNvbS94
bWxucy8iIHhtbG5zOmdkPSJodHRwOi8vc2NoZW1hcy5nb29nbGUuY29tL2cvMjAwNSIgeG1sbnM6
b3BlbnNlYXJjaD0iaHR0cDovL2E5LmNvbS8tL3NwZWMvb3BlbnNlYXJjaHJzcy8xLjAvIj4ge2Vu
dHJpZXN9IDwvZmVlZD4K
EOF
        _build_content => \&_delete_mails,

    },
);

sub _check_captcha {
    my ($content, $args) = @_;
    if (!exists $args->{captcha} && !exists $args->{captcha_token}) {
        $content =~ s/{captcha}//g;
        $content =~ s/{captcha_token}//g;
    } elsif (exists $args->{captcha} && exists $args->{captcha_token}) {
        $content =~ s/{captcha}/$args->{captcah}/g;
        $content =~ s/{captcha_token}/$args->{captcha_token}/g;
    } else {
        croak "Missing augument: captcha_token/captcha";
    }
    return $content;
}

sub _check_mailIDs {
    my ($content, $args) = @_;
    croak 'Missing augument: mailIDs' unless exists $args->{mailIDs};
    my @mailIDs =
      ref $args->{mailIDs} ? @{$args->{mailIDs}} : $args->{mailIDs};
    my $entries;
    for my $mail (@mailIDs) {
        $entries .= <<"EOF";
<entry> <id>http://api.douban.com/doumail/$mail</id> <db:attribute name="unread">false</db:attribute></entry>
EOF
    }
    $content =~ s/{entries}/$entries/;
    return $content;
}

sub _delete_mails {
    my ($content, $args) = @_;
    croak 'Missing augument: mailIDs' unless exists $args->{mailIDs};
    my @mailIDs =
      ref $args->{mailIDs} ? @{$args->{mailIDs}} : $args->{mailIDs};
    my $entries;
    for my $mail (@mailIDs) {
        $entries .= <<"EOF";
<entry> <id>http://api.douban.com/doumail/$mail</id>
EOF
    }
    $content =~ s/{entries}/$entries/;
    return $content;

}

_build_method(__PACKAGE__, %api_hash);
1;

__END__
=pod

=head1 NAME

    Net::Douban::Doumail

=head1 SYNOPSIS

	my $c = Net::Douban->new(Roles => 'Doumail');

=head1 DESCRIPTION

Interface to douban.com API  mail section

=head1 METHODS

=over

=item B<get_mail_inbox>

=item B<get_mail_unread>

=item B<get_mail_outbox>

=item B<get_mail>

argument:   doumailID

=item B<post_mail>

arguments:  ['title', 'content', 'receiver'],

=item B<mark_mail_as_read>

argument:   doumailID

=item B<mark_mails_as_read>

argument:   mailIDs => [ ... ]

=item B<delete_mail>

argument:   doumailID

=item B<delete_mails>

argument:   mailIDs => [ ... ]

=back

=head1 SEE ALSO

L<Net::Douban> L<Net::Douban::Gift> L<Moose>
L<http://www.douban.com/service/apidoc/reference/doumail>

=head1 AUTHOR

woosley.xu <woosley.xu@gmail.com>

=head1 COPYRIGHT
	
Copyright (C) 2010 - 2011 by Woosley.Xu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
