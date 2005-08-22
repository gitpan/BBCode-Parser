# $Id: FONT.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::FONT;
use base qw(BBCode::Tag::Inline);
use BBCode::Util qw(encodeHTML);
use strict;
use warnings;

sub BodyPermitted($):method {
	return 1;
}

sub NamedParams($):method {
	return qw(FACE);
}

sub DefaultParam($):method {
	return 'FACE';
}

sub toHTML($):method {
	my $this = shift;
	my $ret = '';
	foreach($this->body) {
		$ret .= $_->toHTML;
	}
	my $face = $this->param('FACE');
	if(defined $face) {
		$ret = sprintf q(<span style="font-family: '%s'">%s</span>), encodeHTML($face), $ret;
	}
	return $ret;
}

1;
