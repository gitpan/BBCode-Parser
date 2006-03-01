# $Id: Body.pm 186 2006-03-01 18:01:08Z chronos $
package BBCode::Body;
use base qw(BBCode::Tag);
use BBCode::Tag::Block;
use BBCode::Util qw(multilineText);
use strict;
use warnings;
our $VERSION = '0.30';

sub Tag($):method {
	return 'BODY';
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
	return multilineText $ret;
}

sub toHTML($):method {
	my $this = shift;
	my $pfx = $this->parser->css_prefix;
	my $body = $this->bodyHTML;
	return multilineText qq(<div class="${pfx}body">\n$body\n</div>\n);
}

1;
