#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Net::Douban;
use Data::Dumper;

#my $douban = Net::Douban->new(apikey => '04e6b457934823350eb41d06b9d8699f',private_key => '6c65bcfad7d5a558');
my $douban = Net::Douban->new();

#$douban->authen;
#say $use->oauth;
#say $use->token;
#my $use = $douban->User(uid => 'redicaps')->get_auth_user;
#print Dumper $douban->args;

my $search =
  $douban->Subject->search_movie( tag => 'cowboy', 'max-result' => 10 );
print Dumper $search->search_info;
foreach my $entry ( $search->entries ) {
    say Dumper $entry->summary;
}
