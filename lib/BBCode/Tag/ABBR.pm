# $Id: ABBR.pm 116 2006-01-10 16:41:53Z chronos $
package BBCode::Tag::ABBR;
use base qw(BBCode::Tag::Inline);
use BBCode::Util qw(encodeHTML);
use strict;
use warnings;
our $VERSION = '0.02';

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
