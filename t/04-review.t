use strict;
use warnings;
use lib 't/lib';
use Test::Douban;

use Test::More tests => 6;
use_ok('Net::Douban::Review');

my $keys = pdkeys();

my $review = Net::Douban::Review->new(apikey => $keys->{apikey});
isa_ok($review, 'Net::Douban::Review');

my $atom = $review->get_review(reviewID => '1138468');
isa_ok($atom, 'Net::Douban::Atom');

my $subject = $atom->entry->subject;
isa_ok($subject, 'Net::Douban::DBSubject');
like($subject->id, qr{^http://api.douban.com/}, 'subject id is like a url');

my $movie_review = $review->get_movie_review(subjectID => '1424406');
isa_ok($movie_review, 'Net::Douban::Atom');
