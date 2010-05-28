#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Smart::Comments;
use lib '../lib';
use lib '../t/lib';
use Net::Douban::Note;
use Test::Douban qw/consumer/;

my $oauth = consumer;
my $note = Net::Douban::Note->new(oauth => $oauth);

my $atom = $note->get_note(noteID => 73471700);
say $atom->title;
$atom = $note->get_user_note(userID => 'Net-Douban');
my @entries = $atom->entries;
say $entries[0]->title;

my $xml = <<EOF;
<?xml version="1.0" encoding="UTF-8"?>
<entry xmlns="http://www.w3.org/2005/Atom"
xmlns:db="http://www.douban.com/xmlns/">
<title>ABOUT ME</title>
<content>
        在失去勇气的日子里，要提醒自己的好！  我从来不寻找任何避风港，20多年的日子里每个选择都来自我自己，我比你们想象的都要坚强。我为我的坚强付出了很多，却到现在依然没有后悔过任何。 我从不觉得牺牲自己是件多伟大的事，没有人是需要别人来成全的，从来不想以自己的付出作为最后的救命稻草，这种付出委实是在出卖尊严......
</content>
<db:attribute name="privacy">private</db:attribute>
<db:attribute name="can_reply">yes</db:attribute>
</entry>
EOF
#my $res = $note->post_note(xml => $xml);

my $xml1 = <<EOF;
<?xml version="1.0" encoding="UTF-8"?>
<entry xmlns="http://www.w3.org/2005/Atom"
xmlns:db="http://www.douban.com/xmlns/">
<title>ABOUT ME</title>
<content>
change change with Net-Douban
</content>
<db:attribute name="privacy">private</db:attribute>
<db:attribute name="can_reply">yes</db:attribute>
</entry>
EOF

my $res = $note->put_note(noteID => 73474596, xml => $xml1);
$res = $note->delete_note(noteID => 73475321);
