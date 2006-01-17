# $Id: HR.pm 90 2005-08-27 10:58:31Z chronos $
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
