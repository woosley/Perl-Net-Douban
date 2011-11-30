package Net::Douban::Traits::Gift;
use Moose::Role;
with "Net::Douban::User";
with "Net::Douban::Review";
with "Net::Douban::Collection";
with "Net::Douban::Subject";
with "Net::Douban::Miniblog";
with "Net::Douban::Note";
with "Net::Douban::Event";
with "Net::Douban::Recommendation";
with "Net::Douban::Doumail";
with "Net::Douban::Tag";
has 'uid' => (isa => 'Str', is => 'rw');


sub my_reviews {}
sub my_collections {}
sub my_miniblog {}
sub my_contact_miniblog {}
sub my_notes {}
sub my_events {}
sub my_recom {}

1;

__END__

=pod

=head1 NAME

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

=head1 COYPRIGHT

=cut



