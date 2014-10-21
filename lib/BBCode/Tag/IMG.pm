# $Id: IMG.pm 158 2006-02-04 19:12:54Z chronos $
package BBCode::Tag::IMG;
use base qw(BBCode::Tag::Inline);
use BBCode::Util qw(:parse :text encodeHTML);
use strict;
use warnings;
our $VERSION = '0.30';

sub BodyPermitted($):method {
	return 1;
}

sub BodyTags($):method {
	return qw(:TEXT);
}

sub NamedParams($):method {
	return qw(SRC ALT W H TITLE);
}

sub RequiredParams($):method {
	return qw(SRC);
}

sub DefaultParam($):method {
	return 'SRC';
}

sub validateParam($$$):method {
	my($this,$param,$val) = @_;
	if($param eq 'SRC') {
		my $url = parseURL($val);
		if(defined $url) {
			if($url->scheme =~ /^(?:http|https|ftp|data)$/) {
				return $url->as_string;
			} else {
				die qq(Scheme "$url->scheme" not permitted for [IMG]);
			}
		} else {
			die qq(Invalid value "$val" for [IMG]);
		}
	}
	if($param eq 'W' or $param eq 'H') {
		return parseNum $val;
	}
	return $this->SUPER::validateParam($param,$val);
}

sub replace($):method {
	my $this = shift;
	my($src,$alt) = map { $this->param($_) } qw(SRC ALT);
	return $this if defined $src and defined $alt;

	my $text = $this->bodyText;
	my $url;

	if(defined $src) {
		$url = parseURL $src;
		die "BUG: Cannot re-parse URL <$src>" unless defined $url;
		$text = textALT $url if $text =~ /^\s*$/;
	} else {
		$url = parseURL $text;
		goto boom unless defined $url;
		$text = textALT $url;
		$this->param(SRC => $url);
	}
	$this->param(ALT => $text) if not defined $alt;
	return $this;

boom:
	return BBCode::Tag->new($this->parser, 'TEXT', [ undef, $text ]);
}

sub toHTML($):method {
	my $this = shift;
	my($src,$alt,$w,$h,$t) = map { $this->param($_) } qw(SRC ALT W H TITLE);

	if(defined $src and defined $alt) {
		if(not defined $t) {
			$t = $this->bodyText;
		}
		my $ret = '<img';
		$ret .= ' src="'.encodeHTML($src).'"';
		$ret .= ' alt="'.encodeHTML($alt).'"';
		$ret .= ' width="'.encodeHTML($w).'"' if defined $w;
		$ret .= ' height="'.encodeHTML($h).'"' if defined $h;
		$ret .= ' title="'.encodeHTML($t).'"' if defined $t;
		$ret .= ' />';
		return $ret;
	}
	return '';
}

sub toLinkList($;$):method {
	my $this = shift;
	my $ret = shift;
	$ret = [] if not defined $ret;

	my($src,$alt) = map { $this->param($_) } qw(SRC ALT);
	if(defined $src and defined $alt) {
		push @$ret, [ 1, $this->Tag, $src, $alt ];
	}
	return $this->SUPER::toLinkList($ret);
}

1;
