#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Net::Douban;
use Data::Dumper qw/Dumper/;

my $douban = Net::Douban->new(
    apikey      => '04e6b457934823350eb41d06b9d8699f',
    private_key => '6c65bcfad7d5a558'
);

#$douban->authen;
#say $use->oauth;
#say $use->token;
#my $use = $douban->User(uid => 'redicaps')->get_auth_user;

my $subj = $douban->Subject( subjectID => '1424406' )->get_movie;
print Dumper $subj->entry->rating;
