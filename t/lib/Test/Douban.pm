package Test::Douban;
our $VERSION = '1.03';
use strict;
use warnings;
use base qw/Exporter/;

our @EXPORT    = qw/pdurls pdkeys pdtokens pdakeys/;
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

1;
__DATA__
a big xml file
__END__
