# $Id: xURL.pm 186 2006-03-01 18:01:08Z chronos $
package BBCode::Tag::xURL;
use base qw(BBCode::Tag);
use BBCode::Util qw(:parse :encode :text);
use strict;
use warnings;
our $VERSION = '0.30';

sub Tag($):method {
	return 'URL';
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
	my $url = parseURL decodeHTML $text;

	if(defined $url) {
		my $that = BBCode::Tag->new($this->parser, 'URL', [ undef, $url->as_string ]);
		$that->pushBody(
			BBCode::Tag->new($this->parser, 'TEXT', [ undef, textURL($url) ])
		);
		return $that;
	} else {
		return BBCode::Tag->new($this->parser, 'TEXT', [ undef, $text ]);
	}
}

1;
