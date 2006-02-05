# $Id: xIMG.pm 161 2006-02-05 17:31:00Z chronos $
package BBCode::Tag::xIMG;
use base qw(BBCode::Tag::Inline);
use BBCode::Util qw(:parse :encode :text);
use strict;
use warnings;
our $VERSION = '0.30';

sub Tag($):method {
	return 'IMG';
}

sub BodyPermitted($):method {
	return 1;
}

sub replace($):method {
	my $this = shift;
	my $text = $this->bodyHTML;
	my $url = parseURL decodeHTML $text;

	if(defined $url) {
		return BBCode::Tag->new(
			$this->parser,
			'IMG',
			[ undef, $url->as_string ],
			[ 'ALT', textALT($url) ],
		);
	} else {
		return BBCode::Tag->new($this->parser, 'TEXT', [ undef, $text ]);
	}
}

1;
