# $Id: Q.pm 91 2005-08-27 11:00:11Z chronos $
package BBCode::Tag::Q;
use base qw(BBCode::Tag::Simple BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

1;
