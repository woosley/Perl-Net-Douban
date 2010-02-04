#!/usr/bin/perl 
use strict;
use warnings;
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
print $consumer->access_token;
