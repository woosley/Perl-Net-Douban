#!/usr/bin/perl 
use strict;
use warnings;
use Modern::Perl;
use Net::Douban::OAuth::Consumer;
my $key      = '04e6b457934823350eb41d06b9d8699f';
my $sec_key  = '6c65bcfad7d5a558';
my $site     = 'http://www.douban.com';
my $consumer = Net::Douban::OAuth::Consumer->new(
    consumer_key       => $key,
    consumer_secret    => $sec_key,
    site               => $site,
    request_token_path => '/service/auth/request_token',
    access_token_path  => '/service/auth/access_token',
    authorize_url      => $site . '/service/auth/authorize',
);
$consumer->get_request_token;
$consumer->get_access_token;
say $consumer->access_token;
say $consumer->access_token_secret;
say $consumer->request_token;
say $consumer->request_token_secret;
my $res = $consumer->get_protected_resource(
    'request_url' => 'http://api.douban.com/people/Net-Douban/miniblog',
    method        => 'GET'
);
print $res->decoded_content;
