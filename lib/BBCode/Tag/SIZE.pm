# $Id: SIZE.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::SIZE;
use base qw(BBCode::Tag::Inline);
use BBCode::Util qw(:parse);
use strict;
use warnings;

sub BodyPermitted($):method {
	return 1;
}

sub NamedParams($):method {
	return qw(VAL);
}

sub DefaultParam($):method {
	return 'VAL';
}

sub validateParam($$$):method {
	my($this,$param,$val) = @_;

	if($param eq 'VAL') {
		my $size = parseFontSize($val);
		if(defined $size) {
			return $size;
		} else {
			die qq(Invalid value "$val" for [SIZE]);
		}
	}
	return $this->SUPER::validateParam($param,$val);
}

# TODO: Add SIZE->replace() to swap [SIZE=nnn] for [FONT SIZE=nnn]
sub toHTML($):method {
	my $this = shift;
	my $ret = sprintf q(<span style="font-size: %s">), $this->param('VAL');
	foreach($this->body) {
		$ret .= $_->toHTML;
	}
	$ret .= '</span>';
	return $ret;
}

1;
