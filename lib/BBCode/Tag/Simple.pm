# $Id: Simple.pm 186 2006-03-01 18:01:08Z chronos $
package BBCode::Tag::Simple;
use BBCode::Util qw(encodeHTML multilineText);
use strict;
use warnings;
our $VERSION = '0.30';

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
	return multilineText $ret;
}

1;
