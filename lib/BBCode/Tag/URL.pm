# $Id: URL.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::URL;
use base qw(BBCode::Tag);
use BBCode::Util qw(:parse encodeHTML);
use strict;
use warnings;

sub Class($):method {
	return qw(LINK INLINE);
}

sub BodyPermitted($):method {
	return 1;
}

sub BodyTags($):method {
	return qw(:INLINE !:LINK);
}

sub NamedParams($):method {
	return qw(HREF FOLLOW);
}

sub RequiredParams($):method {
	return qw(HREF);
}

sub DefaultParam($):method {
	return 'HREF';
}

sub validateParam($$$):method {
	my($this,$param,$val) = @_;

	if($param eq 'HREF') {
		my $url = parseURL($val);
		if(defined $url) {
			return $url->as_string;
		} else {
			die qq(Invalid value "$val" for [URL]);
		}
	}
	if($param eq 'FOLLOW') {
		return parseBool $val;
	}
	return $this->SUPER::validateParam($param,$val);
}

sub toHTML($):method {
	my $this = shift;

	my $ret = '<a href="'.encodeHTML($this->param('HREF')).'"';
	$ret .= ' rel="nofollow"' if not $this->isFollowed;
	$ret .= '>';
	foreach($this->body) {
		$ret .= $_->toHTML;
	}
	$ret .= '</a>';

	return $ret;
}

sub toLinkList($;$):method {
	my $this = shift;
	my $ret = @_ ? shift : [];
	push @$ret, [ $this->isFollowed, $this->Tag, $this->param('HREF'), $this->bodyHTML ];
	return $this->SUPER::toLinkList($ret);
}

1;
