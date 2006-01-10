# $Id: OL.pm 112 2006-01-09 16:52:08Z chronos $
package BBCode::Tag::OL;
use base qw(BBCode::Tag::LIST);
use strict;
use warnings;
our $VERSION = '0.01';

sub ListDefault($):method {
	return qw(ol);
}

1;
