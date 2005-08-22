# $Id: Simple.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::Simple;
use BBCode::Util qw(encodeHTML);
use strict;
use warnings;

sub toHTML($):method {
	my $this = shift;
	my $ret = "<".lc($this->Tag);

	my @p = $this->params;
	while(@p) {
		my($k,$v) = splice @p, 0, 2;
		$ret .= sprintf ' %s="%s"', lc($k), encodeHTML($v);
	}
	if($this->BodyPermitted) {
		$ret .= '>'.$this->bodyHTML.'</'.lc($this->Tag).'>';
	} else {
		$ret .= ' />';
	}
	return $ret;
}

1;
