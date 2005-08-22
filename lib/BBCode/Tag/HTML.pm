# $Id: HTML.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::HTML;
use base qw(BBCode::Tag);
use strict;
use warnings;

sub NamedParams($):method {
	return qw(CODE);
}

sub DefaultParam($):method {
	return 'CODE';
}

sub toBBCode($):method {
	my $this = shift;
	return "[HTML]".$this->param('CODE')."[/HTML]";
}

sub toHTML($):method {
	my $this = shift;
	return $this->param('CODE');
}

1;
