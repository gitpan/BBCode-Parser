# $Id: OL.pm 161 2006-02-05 17:31:00Z chronos $
package BBCode::Tag::OL;
use base qw(BBCode::Tag::LIST);
use strict;
use warnings;
our $VERSION = '0.01';

sub ListDefault($):method {
	return qw(ol);
}

1;
