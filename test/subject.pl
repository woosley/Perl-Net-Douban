#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use lib '../lib';
use lib '../t/lib';
use Net::Douban::Subject;
use Test::Douban qw/consumer/;


my $oauth = consumer;

my $subject = Net::Douban::Subject->new(oauth => $oauth);
my $info = $subject->get_book(isbnID => 7543639130);
say $info->summary;

$info = $subject->get_movie(imdbID => 'tt0213338');
say $info->summary;

$info = $subject->get_music(subjectID => 2272292);
say $info->summary;

$info = $subject->search_book(q => 'cowboy');
say $info->search_info->{totalResults};
$info = $subject->search_music(q => 'cowboy');
say $info->search_info->{totalResults};
$info = $subject->search_movie(q => 'cowboy');
say $info->search_info->{totalResults};
