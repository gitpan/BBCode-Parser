# $Id: Block.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::Block;
use base qw(BBCode::Tag);
use strict;
use warnings;

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
