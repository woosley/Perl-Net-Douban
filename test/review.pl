#!/usr/bin/perl 
use strict;
use warnings;
use feature ':5.10';
use Smart::Comments;
use lib '../lib';
use lib '../t/lib';
use Net::Douban::Review;
use Test::Douban qw/consumer/;


my $oauth = consumer;

my $review = Net::Douban::Review->new(oauth => $oauth);
my $info = $review->get_review(reviewID => 1138468);
say $info->title;

$info = $review->get_user_review(userID => '2265138');
say $info->search_info->{totalResults};

$info = $review->get_book_review(isbnID => 9780596514983);
say $info->search_info->{totalResults};

$info = $review->get_movie_review(subjectID => 1424406);
say $info->search_info->{totalResults};


my $xml = <<'EOF';
<?xml version='1.0' encoding='UTF-8'?> <entry xmlns:ns0="http://www.w3.org/2005/Atom"> <db:subject xmlns:db="http://www.douban.com/xmlns/"> <id>http://api.douban.com/movie/subject/1424406</id> </db:subject> <content> 渡边唯一的仁慈，是让小鬼艾德带走了小狗爱因，然后大人们就一步步开始了清醒的葬送：斯派克一往无前义无反顾，杰特明白老搭档的臭脾气所以沉默不语，而当时的菲原本已经是第二次不辞而别——“因为分别太难受了，所以我一个人走了。”《杂烩武士》乃伊状的伤员剥桔子然后自己吃掉把桔皮留给他，却终不能坦白地承认的自己的不愿别离，不愿被抛下。...  </content> <gd:rating xmlns:gd="http://schemas.google.com/g/2005" value="4" ></gd:rating> <title>终点之后</title> </entry>
        
EOF
my $resp = $review->delete_review(reviewID => 3293918);
### $resp : $resp
