use strict;
use warnings;

use Test::More tests => 9;
use_ok('Net::Douban::Subject') or exit;
my $subject =
  Net::Douban::Subject->new(apikey => '04e6b457934823350eb41d06b9d8699f');
isa_ok($subject, 'Net::Douban::Subject');
my $book = $subject->get_book('subjectID' => 2023013);
isa_ok($book, 'Net::Douban::Atom');
is($book->id, 'http://api.douban.com/book/subject/2023013');
my $rate = $book->entry->rating;
isa_ok($rate, 'HASH');
is($rate->{max}, 10, 'test rating ok');
my $attri = $book->entry->attributes;
is($attri->{isbn10}, 7543639130, 'test attributes ok');
my $tag = $book->entry->tags;
is(scalar @{$tag}, 8, 'test tag ok');

my $movies = $subject->search_movie(tag => 'cowboy');
isa_ok($movies, 'Net::Douban::Atom');
