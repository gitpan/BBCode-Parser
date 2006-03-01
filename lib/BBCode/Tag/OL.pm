# $Id: OL.pm 186 2006-03-01 18:01:08Z chronos $
package BBCode::Tag::OL;
use base qw(BBCode::Tag::LIST);
use strict;
use warnings;
our $VERSION = '0.01';

sub ListDefault($):method {
	return qw(ol);
}

1;
