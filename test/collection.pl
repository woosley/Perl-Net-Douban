#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Smart::Comments;
use lib '../lib';
use lib '../t/lib';
use Net::Douban::Collection;
use Test::Douban qw/consumer/;


my $oauth = consumer;

my $collec = Net::Douban::Collection->new(oauth => $oauth);
my $info = $collec->get_collection(collectionID => 2154164);
say $info->title;
foreach(@{$info->entry->tags}){
    say $_;
}

$info = $collec->get_user_collection(userID => 'Net-Douban', cat =>'book');
say $info->title;

my $xml = <<'EOF';
<?xml version='1.0' encoding='UTF-8'?>
<entry xmlns:ns0="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/">
<db:status>watched</db:status>
<db:tag name="动画" />
<db:tag name="渡边信一郎" />
<db:tag name="日本" />
<gd:rating xmlns:gd="http://schemas.google.com/g/2005" value="5" />
<content>神作</content>
<db:subject>
<id>http://api.douban.com/movie/subject/1424406</id>
</db:subject>
<db:attribute name="privacy">private</db:attribute>
</entry>
EOF

my $res = $collec->add_collection(xml => $xml);

### res : $res
