# $Id: LI.pm 158 2006-02-04 19:12:54Z chronos $
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
