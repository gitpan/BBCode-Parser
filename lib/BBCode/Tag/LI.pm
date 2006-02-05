# $Id: LI.pm 161 2006-02-05 17:31:00Z chronos $
package BBCode::Tag::LI;
use base qw(BBCode::Tag::Simple BBCode::Tag);
use strict;
use warnings;
our $VERSION = '0.30';

sub BodyPermitted($):method {
	return 1;
}

sub BodyTags($):method {
	# Despite previous reports to the contrary, :BLOCK is fine here
	return qw(:BLOCK :INLINE);
}

sub toHTML($):method {
	return shift->SUPER::toHTML(@_)."\n";
}

1;
