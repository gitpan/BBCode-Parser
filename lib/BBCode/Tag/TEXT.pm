# $Id: TEXT.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::TEXT;
use base qw(BBCode::Tag);
use BBCode::Util qw(encodeHTML);
use strict;
use warnings;

sub Class($):method {
	return qw(TEXT INLINE);
}

sub NamedParams($):method {
	return qw(STR);
}

sub DefaultParam($):method {
	return 'STR';
}

sub toBBCode($):method {
	my $this = shift;
	return $this->param('STR');
}

sub toHTML($):method {
	my $this = shift;
	my $html = encodeHTML($this->param('STR'));
	$html =~ s/&#xA;/\n/g;
	$html =~ s#(?=\n)#<br/>#g;
	return $html;
}

1;
