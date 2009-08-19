#!/usr/bin/perl 
use strict;
use warnings;
use Net::Douban;
use Data::Dumper qw/Dumper/;

my $douban = Net::Douban->new(
    apikey      => '04e6b457934823350eb41d06b9d8699f',
    private_key => '6c65bcfad7d5a558'
);
my $use = $douban->User( uid => 'redicaps' )->get_user;

#my $use = $douban->User(uid => 'redicaps');
print Dumper $use;
print Dumper $use->namespace;
print $use->get('db:uid');
