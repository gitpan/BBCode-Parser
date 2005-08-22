# $Id: OL.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::OL;
use base qw(BBCode::Tag::LIST);
use strict;
use warnings;

sub ListDefault($):method {
	return qw(ol);
}

1;
