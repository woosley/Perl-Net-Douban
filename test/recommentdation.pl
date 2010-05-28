#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Smart::Comments;
use lib '../lib';
use lib '../t/lib';
use Net::Douban::Recommendation;
use Test::Douban qw/consumer/;

my $oauth = consumer;
my $recom = Net::Douban::Recommendation->new(oauth => $oauth);

my $atom = $recom->get_recom(recomID => 25171200);
say $atom->title;
$atom = $recom->get_user_recom(userID => 'Net-Douban');
say $atom->title;
$atom = $recom->get_comments(recomID => 25171200);
say $atom->title;
my $xml = <<EOF;
<?xml version="1.0" encoding="UTF-8"?>
<entry xmlns="http://www.w3.org/2005/Atom"
        xmlns:gd="http://schemas.google.com/g/2005"
        xmlns:opensearch="http://a9.com/-/spec/opensearchrss/1.0/"
        xmlns:db="http://www.douban.com/xmlns/">
        <title>标题</title>
        <db:attribute name="comment">神作</db:attribute>
        <link href="http://api.douban.com/movie/subject/1424406" rel="related" />
</entry>
EOF

#my $res = $recom->post_recom(xml => $xml);

#my $res = $recom->delete_recom(recomID => 25172389);
## res : $res
#
my $xml1 = <<EOF;
<?xml version='1.0' encoding='UTF-8'?>
<entry>
    <content>一些话</content>
</entry>
EOF
my $res = $recom->post_comment(xml => $xml1, recomID => 25172290);
