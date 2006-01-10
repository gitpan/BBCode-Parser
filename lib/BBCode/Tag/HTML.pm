# $Id: HTML.pm 116 2006-01-10 16:41:53Z chronos $
package BBCode::Tag::HTML;
use base qw(BBCode::Tag);
use strict;
use warnings;
our $VERSION = '0.01';

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
