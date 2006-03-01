# $Id: EMAIL.pm 186 2006-03-01 18:01:08Z chronos $
package BBCode::Tag::EMAIL;
use base qw(BBCode::Tag::URL);
use BBCode::Util qw(:parse encodeHTML);
use strict;
use warnings;
our $VERSION = '0.30';

sub validateParam($$$):method {
	my($this,$param,$val) = @_;

	if($param eq 'HREF') {
		my $url = parseMailURL($val);
		if(defined $url) {
			return $url->as_string;
		} else {
			die qq(Invalid value "$val" for [EMAIL]);
		}
	}
	return $this->SUPER::validateParam($param,$val);
}

sub replace($):method {
	my $this = shift;
	my $href = $this->param('HREF');
	if(not defined $href) {
		my $text = $this->bodyText;
		my $url = parseMailURL $text;
		if(not defined $url) {
			return BBCode::Tag->new($this->parser, 'TEXT', [ undef, $text ]);
		}
		$this->param(HREF => $url);
	}
	return $this;
}

1;
