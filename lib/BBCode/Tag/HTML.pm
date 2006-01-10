# $Id: HTML.pm 112 2006-01-09 16:52:08Z chronos $
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
