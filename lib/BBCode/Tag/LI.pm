# $Id: LI.pm 91 2005-08-27 11:00:11Z chronos $
package BBCode::Tag::LI;
use base qw(BBCode::Tag::Simple BBCode::Tag);
use strict;
use warnings;
our $VERSION = '0.01';

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
