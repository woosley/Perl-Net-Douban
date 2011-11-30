package Net::Douban::Tag;

use Moose::Role;
use MooseX::StrictConstructor;
use Net::Douban::Atom;
use Carp qw/carp croak/;
requires '_build_method';
use namespace::autoclean;


our %api_hash = (
    get_tags => {
        path => '/{cat}/subject/{subjectID}/tags',
        method => 'GET',
        has_url_param => 1,
    },

    get_user_tags => {
        path => '/people/{userID}/tags?cat={cat}',
        method => 'GET',
        has_url_param => 1,
    },
);

__PACKAGE__->_build_method(%api_hash);

1;
__END__
