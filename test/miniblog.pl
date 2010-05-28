#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Smart::Comments;
use lib '../lib';
use lib '../t/lib';
use Net::Douban::Miniblog;
use Test::Douban qw/consumer/;

my $oauth = consumer;
my $blog = Net::Douban::Miniblog->new(oauth => $oauth);

my $atom = $blog->get_user_miniblog(userID => 'Net-Douban');
say $atom->title;
my @entries = $atom->entries;
say $entries[0]->content;
say $entries[0]->id;

$atom = $blog->get_contact_miniblog(userID => 'Net-Douban');

@entries = $atom->entries;
say scalar @entries;
say $entries[2]->content;
say $entries[2]->id;


my $xml = <<EOF;
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
<content>收拾屋子就是把书从床头搬到书架的过程</content>
</entry>
EOF

my $xml1 = <<EOF;
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
<content>收拾屋子就是把书从床头搬到书架的过程/修改版</content>
</entry>
EOF

$blog->post_saying(xml => $xml);
$blog->post_reply(miniblogID => 351062405, xml => $xml1);
