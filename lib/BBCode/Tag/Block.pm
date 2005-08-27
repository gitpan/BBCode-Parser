# $Id: Block.pm 91 2005-08-27 11:00:11Z chronos $
package BBCode::Tag::Block;
use base qw(BBCode::Tag);
use strict;
use warnings;
our $VERSION = '0.01';

sub Class($):method {
	return qw(BLOCK);
}

sub BodyTags($):method {
	return qw(:BLOCK :INLINE);
}

sub bodyHTML($):method {
	local $_ = shift->SUPER::bodyHTML();
	s#^\s* (?: <br/> \s* )*  ##x;
	s# \s* (?: <br/> \s* )* $##x;
	return $_;
}

1;
