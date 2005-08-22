# $Id: Body.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Body;
use base qw(BBCode::Tag);
use BBCode::Tag::Block;
use strict;
use warnings;

sub new($@):method {
	return shift->_create(@_);
}

sub Tag($):method {
	return '';
}

sub BodyPermitted($):method {
	return 1;
}

sub BodyTags($):method {
	return qw(:ALL BODY);
}

sub bodyHTML($):method {
	return BBCode::Tag::Block::bodyHTML(shift);
}

sub toBBCode($):method {
	my $this = shift;
	my $ret = "";
	foreach($this->body) {
		$ret .= $_->toBBCode;
	}
	return $ret;
}

sub toHTML($):method {
	my $this = shift;
	my $pfx = $this->parser->css_prefix;
	my $body = $this->bodyHTML;
	return qq(<div class="${pfx}body">\n$body\n</div>\n);
}

1;
