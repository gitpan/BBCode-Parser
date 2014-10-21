# $Id: LI.pm 117 2006-01-17 14:36:56Z chronos $
package BBCode::Tag::LI;
use base qw(BBCode::Tag::Simple BBCode::Tag);
use strict;
use warnings;
our $VERSION = '0.23';

sub BodyPermitted($):method {
	return 1;
}

sub BodyTags($):method {
	# Despite previous reports to the contrary, :BLOCK is fine here
	return qw(:LIST :BLOCK :INLINE);
}

sub toHTML($):method {
	return shift->SUPER::toHTML(@_)."\n";
}

1;
