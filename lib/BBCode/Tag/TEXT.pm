# $Id: TEXT.pm 116 2006-01-10 16:41:53Z chronos $
package BBCode::Tag::TEXT;
use base qw(BBCode::Tag);
use BBCode::Util qw(encodeHTML);
use strict;
use warnings;
our $VERSION = '0.20';

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
	local $_ = $this->param('STR');
	s/\[/[]/g;
	s/&/[ENT=amp]/g;
	s/<(?=URL:)/[ENT=lt]/gi;
	return $_;
}

sub toHTML($):method {
	my $this = shift;
	my $html = encodeHTML($this->param('STR'));
	$html =~ s/&#xA;/\n/g;
	$html =~ s#(?=\n)#<br/>#g;
	return $html;
}

1;
