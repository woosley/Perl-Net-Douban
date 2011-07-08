package Net::Douban::Tag;

use Moose;
use MooseX::StrictConstructor;
use Net::Douban::Atom;
use Carp qw/carp croak/;
with 'Net::Douban::Roles';
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
__PACKAGE__->meta->make_immutable;

1;
__END__
