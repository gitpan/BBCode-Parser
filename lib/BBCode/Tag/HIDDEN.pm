# $Id: HIDDEN.pm 200 2006-04-14 12:26:48Z chronos $
package BBCode::Tag::HIDDEN;
use base qw(BBCode::Tag::Inline);
use BBCode::Util qw(multilineText);
use strict;
use warnings;
our $VERSION = '0.30';

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
	return multilineText $ret;
}

1;

