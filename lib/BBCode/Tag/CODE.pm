# $Id: CODE.pm 158 2006-02-04 19:12:54Z chronos $
package BBCode::Tag::CODE;
use base qw(BBCode::Tag::Block);
use BBCode::Util qw(encodeHTML multilineText);
use strict;
use warnings;
our $VERSION = '0.30';

sub BodyPermitted($):method {
	return 1;
}

sub BodyTags($):method {
	return qw(:TEXT URL EMAIL);
}

sub NamedParams($):method {
	return qw(LANG);
}

sub RequiredParams($):method {
	return ();
}

sub validateParam($$$):method {
	my($this,$param,$val) = @_;
	if($param eq 'LANG') {
		$val =~ s/_/-/g;
		if($val =~ /^ \w+ (?: - \w+ )* $/x) {
			return $val;
		} else {
			die qq(Invalid value "$val" for [CODE LANG]);
		}
	}
	return $this->SUPER::validateParam($param,$val);
}

sub toHTML($):method {
	my $this = shift;
	my $pfx = $this->parser->css_prefix;

	my $lang = $this->param('LANG');
	my $body = $this->bodyHTML;
	$body =~ s#<br/>$##mg;
	$body =~ s#<br/>#\n#g;
	return multilineText
		qq(<div class="${pfx}code">\n),
		qq(<div class="${pfx}code-head">), (defined $lang ? encodeHTML(ucfirst "$lang ") : ""), qq(Code:</div>\n),
		qq(<pre class="${pfx}code-body">\n),
		qq($body\n),
		qq(</pre>\n),
		qq(</div>\n);
}

1;
