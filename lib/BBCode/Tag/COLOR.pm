# $Id: COLOR.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::COLOR;
use base qw(BBCode::Tag::Inline);
use BBCode::Util qw(:parse encodeHTML);
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
		my $color = parseColor($val);
		if(defined $color) {
			return $color;
		} else {
			die qq(Invalid value "$val" for [COLOR]);
		}
	}
	return $this->SUPER::validateParam($param,$val);
}

sub toHTML($):method {
	my $this = shift;
	my $ret = sprintf q(<span style="color: %s">), encodeHTML($this->param('VAL'));
	foreach($this->body) {
		$ret .= $_->toHTML;
	}
	$ret .= '</span>';
	return $ret;
}

1;
