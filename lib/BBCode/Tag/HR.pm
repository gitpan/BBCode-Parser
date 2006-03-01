# $Id: HR.pm 186 2006-03-01 18:01:08Z chronos $
package BBCode::Tag::HR;
use base qw(BBCode::Tag::Block);
use strict;
use warnings;
our $VERSION = '0.01';

sub toBBCode($):method {
	return "[HR]";
}

sub toHTML($):method {
	return "<hr/>";
}

1;
