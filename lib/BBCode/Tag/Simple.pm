# $Id: Simple.pm 91 2005-08-27 11:00:11Z chronos $
package BBCode::Tag::Simple;
use BBCode::Util qw(encodeHTML);
use strict;
use warnings;
our $VERSION = '0.01';

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
