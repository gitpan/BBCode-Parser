# $Id: S.pm 90 2005-08-27 10:58:31Z chronos $
package BBCode::Tag::S;
use base qw(BBCode::Tag::Inline);
use strict;
use warnings;
our $VERSION = '0.01';

sub BodyPermitted($):method {
	return 1;
}

sub toHTML($):method {
	my $this = shift;
	my $pfx = $this->parser->css_prefix;
	my $css = $this->parser->css_direct_styles ? qq( style="text-decoration: line-through") : "";

	my $ret = qq(<span class="${pfx}s"$css>);
	foreach($this->body) {
		$ret .= $_->toHTML;
	}
	$ret .= '</span>';
	return $ret;
}

1;
