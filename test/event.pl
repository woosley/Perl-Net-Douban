#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Smart::Comments;
use lib '../lib';
use lib '../t/lib';
use Net::Douban::Event;
use Test::Douban qw/consumer/;

my $oauth = consumer;
my $event = Net::Douban::Event->new(oauth => $oauth);

my $atom = $event->get_event(eventID => 10069638);
say $atom->title;

$atom = $event->get_event_wishers(eventID => 10069638);
my @entries = $atom->entries;
say $atom->title;
say $atom->search_info->{totalResults};
say scalar @entries;
$atom = $event->get_event_participants(eventID => 10069638);
say $atom->title;

$atom = $event->get_user_participate(userID => 'aka');
say $atom->title;
$atom = $event->get_user_wish(userID => 'aka');
say $atom->title;
$atom = $event->get_user_initiate(userID => 'aka');
say $atom->title;
$atom = $event->get_city_events(locationID => 'beijing');
say $atom->title;
$atom = $event->search(locationID => 'beijing');
say $atom->title;
