
use strict;
use warnings;



use ExtUtils::MakeMaker 6.11;



my %WriteMakefileArgs = (
                       'test' => {
                                   'TESTS' => 't/*.t'
                                 },
                       'NAME' => 'Perl::Net::Douban',
                       'DISTNAME' => 'Perl-Net-Douban',
                       'AUTHOR' => 'woosley.xu',
                       'ABSTRACT' => 'Perl-Net-Douban based on Moose and XML::Atom',
                       'EXE_FILES' => [],
                       'VERSION' => '1.02',
                       'LICENSE' => 'perl',
                       'PREREQ_PM' => {
                                        'Scalar::Util' => '0',
                                        'ExtUtils::MakeMaker' => '6.11',
                                        'XML::Atom' => '0.35',
                                        'HTTP::Request::Common' => '0',
                                        'Test::More' => '0',
                                        'LWP::UserAgent' => '0',
                                        'Net::OAuth' => '0',
                                        'HTTP::Request' => '0',
                                        'Moose' => '0'
                                      }
                     );


delete $WriteMakefileArgs{LICENSE}
  unless eval { ExtUtils::MakeMaker->VERSION(6.31) };

WriteMakefile(%WriteMakefileArgs);



