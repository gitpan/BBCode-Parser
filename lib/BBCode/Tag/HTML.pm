# $Id: HTML.pm 90 2005-08-27 10:58:31Z chronos $
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
