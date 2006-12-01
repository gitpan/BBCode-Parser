# $Id: xEMAIL.pm 284 2006-12-01 07:51:49Z chronos $
package BBCode::Tag::xEMAIL;
use base qw(BBCode::Tag);
use BBCode::Util qw(:parse :encode :text);
use strict;
use warnings;
our $VERSION = '0.34';

sub Tag($):method {
	return 'EMAIL';
}

sub Class($):method {
	return qw(LINK INLINE);
}

sub BodyPermitted($):method {
	return 1;
}

sub BodyTags($):method {
	return qw(TEXT ENT);
}

sub replace($):method {
	my $this = shift;
	my $text = $this->bodyHTML;
	my $url = parseMailURL decodeHTML $text;

	if(defined $url) {
		my $that = BBCode::Tag->new($this->parser, 'EMAIL', [ undef, $url->as_string ]);
		$that->pushBody(
			BBCode::Tag->new($this->parser, 'TEXT', [ undef, textURL($url) ])
		);
		return $that;
	} else {
		return BBCode::Tag->new($this->parser, 'TEXT', [ undef, $text ]);
	}
}

1;
