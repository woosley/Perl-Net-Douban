#!/usr/bin/perl 
use strict;
use warnings;
use Modern::Perl;
use Net::Douban;
use Net::Douban::Miniblog;
use Net::Douban::OAuth;
my $key      = '04e6b457934823350eb41d06b9d8699f';
my $sec_key  = '6c65bcfad7d5a558';
my $site     = 'http://www.douban.com';
my $consumer = Net::Douban::OAuth->new(
    consumer_key         => $key,
    consumer_secret      => $sec_key,
    site                 => $site,
    request_token_path   => '/service/auth/request_token',
    access_token_path    => '/service/auth/access_token',
    authorize_url        => $site . '/service/auth/authorize',
    access_token         => '1147368bb57790f133d5a3a32066b2d3',
    access_token_secret  => '9510ef5f07fd50fe',
    request_token        => '2d37444a40bd462187a5ccdec237d263',
    request_token_secret => '71ed13ccf69a79f3',
    authorized           => 1,
);
my $douban = Net::Douban->new(
    oauth      => $consumer,
    apikey     => $key,
    api_secret => $sec_key,
);
print $douban->oauth();
my $content = <<'EOF';
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
<content>test from junxter</content>
</entry>
EOF
my $res = $douban->Miniblog->post_saying(xml => $content);

#my $res = $consumer->mana_protected_resource(request_url => 'http://api.douban.com/miniblog/saying', method => 'POST',content => $content, headers => ['Content-Type' => q{application/atom+xml}]);

print $res->decoded_content;
