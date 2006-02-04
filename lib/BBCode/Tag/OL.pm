# $Id: OL.pm 158 2006-02-04 19:12:54Z chronos $
package BBCode::Tag::OL;
use base qw(BBCode::Tag::LIST);
use strict;
use warnings;
our $VERSION = '0.01';

sub ListDefault($):method {
	return qw(ol);
}

1;
