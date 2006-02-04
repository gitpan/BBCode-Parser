# $Id: HTML.pm 158 2006-02-04 19:12:54Z chronos $
package BBCode::Tag::HTML;
use base qw(BBCode::Tag);
use BBCode::Util qw(multilineText);
use strict;
use warnings;
our $VERSION = '0.30';

sub NamedParams($):method {
	return qw(CODE);
}

sub DefaultParam($):method {
	return 'CODE';
}

sub toBBCode($):method {
	my $this = shift;
	return multilineText "[HTML]".$this->param('CODE')."[/HTML]";
}

sub toHTML($):method {
	my $this = shift;
	return multilineText $this->param('CODE');
}

1;
