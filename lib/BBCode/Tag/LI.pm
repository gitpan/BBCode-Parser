# $Id: LI.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::LI;
use base qw(BBCode::Tag::Simple BBCode::Tag);
use strict;
use warnings;

sub BodyPermitted($):method {
	return 1;
}

sub BodyTags($):method {
	return qw(:LIST :INLINE);
}

sub toHTML($):method {
	return shift->SUPER::toHTML(@_)."\n";
}

1;
