#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use lib '../lib';
use lib '../t/lib';
use Net::Douban::User;
use Test::Douban qw/consumer/;

my $oauth = consumer;
my $user = Net::Douban::User->new(oauth => $oauth);
my $info = $user->get_auth_user();

say $info->title;
$info = $user->search(q => 'redicaps', start_index => 0, max_result => 5);

say $info->search_info->{totalResults};
my ($entry) = $info->entries;
say $entry->title;

$info = $user->get_user(userID => 'ahbei');
say $info->title;

$info = $user->get_contacts(userID => 'ahbei');
say $info->search_info->{totalResults};
