# $Id: S.pm 161 2006-02-05 17:31:00Z chronos $
package BBCode::Tag::S;
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
	my $css = $this->parser->css_direct_styles ? qq( style="text-decoration: line-through") : "";

	my $ret = qq(<span class="${pfx}s"$css>);
	$ret .= $this->bodyHTML;
	$ret .= '</span>';
	return multilineText $ret;
}

sub toText($):method {
	return multilineText '~'.shift->bodyText().'~';
}

1;
