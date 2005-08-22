# $Id: HIDDEN.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::HIDDEN;
use base qw(BBCode::Tag::Inline);
use strict;
use warnings;

sub BodyPermitted($):method {
	return 1;
}

sub toHTML($):method {
	my $this = shift;
	my $pfx = $this->parser->css_prefix;
	my $css = $this->parser->css_direct_styles ? qq( style="color:#ddd;background-color:#ddd") : "";

	my $ret = qq(<span class="${pfx}hidden" title="Hidden text"$css>);
	foreach($this->body) {
		$ret .= $_->toHTML;
	}
	$ret .= '</span>';
	return $ret;
}

1;

