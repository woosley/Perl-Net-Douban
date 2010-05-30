#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Smart::Comments;
use lib '../lib';
use lib '../t/lib';
use Net::Douban::Doumail;
use Test::Douban qw/consumer/;

my $oauth = consumer;
my $mail= Net::Douban::Doumail->new(oauth => $oauth);

my $atom = $mail->inbox();
say $atom->title;
$atom = $mail->unread;
say $atom->title;
$atom = $mail->outbox;
say $atom->title;
$atom = $mail->get_doumail(mailID => 65568683);
say $atom->title;
