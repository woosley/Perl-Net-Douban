package Test::Douban;
our $VERSION = '1.06';
use strict;
use warnings;
use base qw/Exporter/;

our @EXPORT    = qw/pdurls pdkeys pdtokens pdakeys consumer gtxml/;
our @EXPORT_OK = qw//;

#use Test::Builder;
#my $test = Test::Builder->new();

## Net-Douban Test Predefined Vars
my $site = 'http:://www.douban.com/';
my $pdks = {
    apikey     => '04e6b457934823350eb41d06b9d8699f',
    api_secret => '6c65bcfad7d5a558',
};
my $pdts = {
    access_token         => '1147368bb57790f133d5a3a32066b2d3',
    access_token_secret  => '9510ef5f07fd50fe',
    request_token        => '2d37444a40bd462187a5ccdec237d263',
    request_token_secret => '71ed13ccf69a79f3',
};
my $pdus = {
    site               => $site,
    request_token_path => '/service/auth/request_token',
    access_token_path  => '/service/auth/access_token',
    authorize_url      => $site . '/service/auth/authorize',
};

sub pdkeys {
    return $pdks;
}

sub pdtokens {
    return $pdts;
}

sub pdurls {
    return $pdus;
}

sub pdakeys {
    my $pdtsb = $pdts;
    $pdtsb->{consumer_key}    = $pdks->{apikey};
    $pdtsb->{consumer_secret} = $pdks->{api_secret};
    return $pdtsb;
}

sub consumer {

    my $all_tokens = pdakeys;
    my $urls       = pdurls;
    require Net::Douban::OAuth;
    my $oauth =
      Net::Douban::OAuth->new(%{$all_tokens}, %{$urls}, authorized => 1,);
    return $oauth;
}

sub gtxml {
	local $/ = undef;
	my $xml = <DATA>;
	return $xml;
}
1;

__DATA__
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom"
xmlns:gd="http://schemas.google.com/g/2005"
xmlns:opensearch="http://a9.com/-/spec/opensearchrss/1.0/"
xmlns:db="http://www.douban.com/xmlns/">
<title>Cowboy Bebop 的评论</title>
<opensearch:totalResults>24</opensearch:totalResults>
<link rel="alternate"
    href="http://movie.douban.com/subject/1424406/reviews" />
<opensearch:startIndex>1</opensearch:startIndex>
<entry>
    <updated>2007-03-27T08:54:43+08:00</updated>
    <author>
        <link rel="self"
            href="http://api.douban.com/people/iserlohnwind" />
        <link rel="alternate"
            href="http://www.douban.com/people/iserlohnwind/" />
        <link rel="icon"
            href="http://www.douban.com/icon/u1360856.jpg" />
        <uri>http://api.douban.com/people/iserlohnwind</uri>
        <name>伊谢尔伦的风</name>
    </author>
    <title>终点之后</title>
    <summary>
        我还是忍不住要说菲。 　　
        渡边唯一的仁慈，是让小鬼艾德带走了小狗爱因，然后大人们就一步步开始了清醒的葬送：斯派克一往无前义无反顾，杰特明白老搭档的臭脾气所以沉默不语，而当时的菲原本已经是第二次不辞而别——“因为分别太难受了，所以我一个人走了。”《杂烩武士》里15岁的风这样告诉仁和无幻——可又找不到回去的地方，终于还是把自己扔给了BEBOP号，却被告知终曲即将奏响。然而菲不是风，她能悠然...
    </summary>
    <link rel="self" href="http://api.douban.com/review/1138468" />
    <link rel="alternate"
        href="http://www.douban.com/review/1138468/" />
    <link rel="http://www.douban.com/2007#subject"
        href="http://api.douban.com/movie/subject/1424406" />
    <id>http://api.douban.com/review/1138468</id>
    <gd:rating min="1" value="4" max="5" />
</entry>
<entry>
    <updated>2007-03-02T20:09:02+08:00</updated>
    <author>
        <link rel="self"
            href="http://api.douban.com/people/iserlohnwind" />
        <link rel="alternate"
            href="http://www.douban.com/people/iserlohnwind/" />
        <link rel="icon"
            href="http://www.douban.com/icon/u1360856.jpg" />
        <uri>http://api.douban.com/people/iserlohnwind</uri>
        <name>伊谢尔伦的风</name>
    </author>
    <title>BEBOP号没有情人节</title>
    <summary>
        http://9.douban.com/site/entry/14995731/
        那个NPC说：菲·瓦伦丁（Faye Valentine），这个名字是我起的，取自情人节（Valentine's
        Day），一年中我最喜欢的节日。
        在民用宇宙飞船BEBOP号，有不加肉的青椒肉丝，有变异到可以跑还能蜇人的松坂牛肉，有龙宫的礼物，有奇妙的蘑菇，有聪明的小狗和四肢像面条的天才儿童……唯独没有情人节。
        ...
    </summary>
    <link rel="self" href="http://api.douban.com/review/1129490" />
    <link rel="alternate"
        href="http://www.douban.com/review/1129490/" />
    <link rel="http://www.douban.com/2007#subject"
        href="http://api.douban.com/movie/subject/1424406" />
    <id>http://api.douban.com/review/1129490</id>
    <gd:rating min="1" value="4" max="5" />
</entry>
<opensearch:itemsPerPage>2</opensearch:itemsPerPage>
</feed>
__END__
