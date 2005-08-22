# $Id: ABBR.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::ABBR;
use base qw(BBCode::Tag::Inline);
use BBCode::Util qw(encodeHTML);
use strict;
use warnings;

sub MinArgs($):method {
	return 0;
}

sub MaxArgs($):method {
	return 1;
}

sub BodyPermitted($):method {
	return 1;
}

sub NamedParams($):method {
	return qw(FULL);
}

sub RequiredParams($):method {
	return ();
}

sub DefaultParam($):method {
	return 'FULL';
}

sub toHTML($):method {
	my $this = shift;
	my $full = $this->param('FULL');
	my $ret = '<'.lc($this->Tag);
	if(defined $full) {
		$ret .= ' title="'.encodeHTML($full).'"';
	}
	$ret .= '>'.$this->bodyHTML.'</'.lc($this->Tag).'>';
	return $ret;
}

1;
