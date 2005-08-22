# $Id: Util.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Util;
use base qw(Exporter);
use HTML::Entities ();
use POSIX ();
use URI ();
use strict;
use warnings;

our $VERSION = '0.01';
our @EXPORT;
our @EXPORT_OK;
our %EXPORT_TAGS;

sub _tag {
	my $sym = shift;
	$sym =~ s/^(?=\w)/&/;
	unshift @_, 'ALL';
	while(@_) {
		my $tag = shift;
		$EXPORT_TAGS{$tag} = [] unless exists $EXPORT_TAGS{$tag};
		push @{$EXPORT_TAGS{$tag}}, $sym;
	}
}

BEGIN { _tag qw(tagLoadPackage tag) }
sub tagLoadPackage($) {
	my $tag = uc(shift);
	$tag =~ s#^/##;
	$tag =~ s/^_/x/;
	my $pkg = "BBCode::Tag::$tag";
	my $file = $pkg;
	$file =~ s#::#/#g;
	$file =~ s/$/.pm/;
	require $file;
	return $pkg;
}

BEGIN { _tag qw(tagExists tag) }
sub tagExists($) {
	my $tag = shift;
	return 1 if eval {
		tagLoadPackage($tag);
		1;
	};
	return 0;
}

BEGIN { _tag qw(quoteQ quote) }
sub quoteQ($) {
	local $_ = $_[0];
	s/([\\'])/\\$1/g;
	return qq('$_');
}

BEGIN { _tag qw(quoteQQ quote) }
sub quoteQQ($) {
	local $_ = $_[0];
	s/([\\"])/\\$1/g;
	return qq("$_");
}

BEGIN { _tag qw(quoteBS quote) }
sub quoteBS($) {
	local $_ = $_[0];
	s/([\\\[\]"'=,\s\n])/\\$1/g;
	return $_;
}

BEGIN { _tag qw(quoteRaw quote) }
sub quoteRaw($) {
	local $_ = $_[0];
	return undef if /[\\\[\]"'=,\s\n]/;
	return $_;
}

BEGIN { _tag qw(quote quote) }
sub quote($) {
	my @q = sort {
		(length($a) <=> length($b)) or ($a cmp $b)
	} grep {
		defined $_
	} (quoteQ $_[0], quoteQQ $_[0], quoteBS $_[0], quoteRaw $_[0]);
	return $q[0];
}

BEGIN { _tag qw(encodeHTML encode); }
sub encodeHTML($) {
	local $_ = $_[0];
	if(defined $_) {
		$_ = HTML::Entities::encode($_);
		s/'/&apos;/g;
		s/([^\x20-\x7E])/sprintf "&#x%X;", ord($1)/eg;
	}
	return $_;
}

BEGIN { _tag qw(decodeHTML encode); }
sub decodeHTML($) {
	return HTML::Entities::decode($_[0]);
}

BEGIN { _tag qw(setUpdate set) }
sub setUpdate(\%@) {
	my $set = shift;
	$set = { %$set } if defined wantarray;
	while(@_) {
		my $tag = shift;
		next unless defined $tag;
		if($tag =~ /\s/) {
			$tag =~ s/^\s+|\s+$//g;
			unshift @_, split /\s+/, $tag;
		} elsif(UNIVERSAL::can($tag, 'Tag')) {
			unshift @_, $tag->Tag;
		} elsif($tag =~ s/^!//) {
			$set->{$tag} = 0;
		} else {
			$set->{$tag} = 1;
		}
	}
	return %$set if wantarray;
	return $set;
}

BEGIN { _tag qw(setCreate set) }
sub setCreate(@) {
	my %set;
	setUpdate(%set, @_);
	return %set if wantarray;
	return \%set;
}

BEGIN { _tag qw(setNegate set) }
sub setNegate(\%) {
	my $set = shift;
	$set = { %$set } if defined wantarray;
	foreach my $k (keys %$set) {
		$set->{$k} = $set->{$k} ? 0 : 1;
	}
	return %$set if wantarray;
	return $set;
}

BEGIN { _tag qw(setMerge set) }
sub setMerge(\%\%) {
	my $set = shift;
	my $other = shift;
	$set = { %$set } if defined wantarray;
	foreach my $k (keys %$other) {
		$set->{$k} = $other->{$k};
	}
	return %$set if wantarray;
	return $set;
}

BEGIN { _tag qw(setContainsTag set) }
sub setContainsTag(\%$;$) {
	my($set,$tag,$default) = @_;
	foreach($tag->Tag, map { ":$_" } ($tag->Class, 'ALL')) {
		return $set->{$_} if exists $set->{$_};
	}
	return $default;
}

BEGIN { _tag qw(parseBool parse) }
sub parseBool($) {
	local $_ = $_[0];
	return undef if not defined $_;
	return $_->as_bool() if ref $_ and UNIVERSAL::can($_, 'as_bool');
	return 1 if /^(?:
		1 |
		T | TR | TRU | TRUE |
		Y | YE | YES |
		ON
	)$/ix;
	return 0 if /^(?:
		0 |
		F | FA | FAL | FALS | FALSE |
		N | NO |
		OFF
	)$/ix;
	return $_ ? 1 : 0;
}

BEGIN { _tag qw(parseNum parse) }
sub parseNum($);
sub parseNum($) {
	local $_ = $_[0];
	return undef if not defined $_;
	s/^\s+|\s+$//g;
	s/(?<=\d),(?=\d)//g;
	s/(?<=\d)_+(?=\d)//g;
	return 0 if /^ \. $/x;
	return 0+$1 if /^ ( [+-]? \d+ ) \.? $/x;
	return 0+$1 if /^ ( [+-]? \d* \. \d+ ) $/x;
	if(/^ ( [+-]? [\d.]* ) e ( [+-]? [\d.]* ) $/xi) {
		my($m,$e) = map parseNum($_), $1, $2;
		return $m * (10 ** $e) if defined $m and defined $e;
	}
	return 0;
}

BEGIN { _tag qw(parseEntity parse) }
sub parseEntity($);
sub parseEntity($) {
	local $_ = $_[0];
	return undef unless defined $_;
	s/^&(.*);$/$1/;
	s/^#([xob])/0$1/i;
	s/^#//;
	s/^U\+/0x/;

	my $ch;
	if(/^ 0x ([0-9A-F]+) $/xi) {
		$ch = hex($1);
	} elsif(/^ 0o ([0-7]+) $/xi) {
		$ch = oct($1);
	} elsif(/^ 0b ([01]+) $/xi) {
		my $b = ("\0" x 4) . pack("B*", $1);
		$ch = unpack "N", substr($b, -4);
	} elsif(/^ 0 ([0-7]{3}) $/x) {
		$ch = oct($1);
	} elsif(/^ (\d+) $/x) {
		$ch = 0+$1;
	}
	return sprintf "#x%X", $ch if defined $ch;

	my $decoded = HTML::Entities::decode("&$_;");
	return undef if $decoded eq "&$_;";
	return $_;
}

BEGIN { _tag qw(parseListType parse) }
my %listtype = (
	'*'		=> [ qw(ul) ],
	'1'		=> [ qw(ol decimal) ],
	'01'	=> [ qw(ol decimal-leading-zero) ],
	'A'		=> [ qw(ol upper-latin) ],
	'a'		=> [ qw(ol lower-latin) ],
	'I'		=> [ qw(ol upper-roman) ],
	'i'		=> [ qw(ol lower-roman) ],
	"\x{3B1}"	=> [ qw(ol lower-greek) ],
	"\x{5D0}"	=> [ qw(ol hebrew) ],
	"\x{3042}"	=> [ qw(ol hiragana) ],
	"\x{3044}"	=> [ qw(ol hiragana-iroha) ],
	"\x{30A2}"	=> [ qw(ol katakana) ],
	"\x{30A4}"	=> [ qw(ol katakana-iroha) ],
);
sub parseListType($) {
	local $_ = $_[0];
	my @ret;
	if(defined $_) {
		if(/^(disc|circle|square|none)$/i) {
			@ret = ('ul', lc $1);
		} elsif(/^(
			decimal(?:-leading-zero)? |
			(?:upper|lower)-(?:roman|latin|alpha) |
			lower-greek |
			hebrew |
			georgian |
			armenian |
			cjk-ideographic |
			(?:hiragana|katakana)(?:-iroha)?
		)$/ix) {
			@ret = ('ol', lc $1);
		} elsif(exists $listtype{$_}) {
			@ret = @{$listtype{$_}};
		}
	}
	return @ret;
}

my %conv = (
	px	=> 0.75,

	pt	=> 1,
	pc	=> 12,
	in	=> 72,

	mm	=> 72/25.4,
	cm	=> 72/2.54,

	ex	=> 8,
	em	=> 12,
);

# See <URL:http://www.w3.org/TR/CSS21/fonts.html#font-size-props>
# Tweaked slightly to be more logical
my @compat = qw(xx-small x-small small medium large x-large xx-large 300%);

BEGIN { _tag qw(parseFontSize parse) }
sub parseFontSize($);
sub parseFontSize($) {
	local $_ = $_[0];
	return undef unless defined $_;
	s/\s+/ /g;
	s/^\s|\s$//g;

	if(/^ (\d+ (?: \. \d+ )? ) \s? ([a-z]{2}) $/ix) {
		my($n,$unit) = (0+$1,lc $2);
		if(exists $conv{$unit}) {
			my $n2 = $n / $conv{$unit};
			if($n2 < 8) {
				$n = POSIX::floor(0.5 + 8 * $conv{$unit});
			} elsif($n2 > 72) {
				$n = POSIX::floor(0.5 + 72 * $conv{$unit});
			}
			return "$n$unit";
		}
	}

	if(/^( (?:xx?-)? (?:large|small) | medium )$/ix) {
		return lc $1;
	}

	if(/^ ( larger | smaller ) $/ix) {
		return lc $1;
	}

	if(/^ (\d+) $/x) {
		my $n = 0+$1;
		if($n >= 0 and $n < @compat) {
			return $compat[$n];
		} else {
			return parseFontSize("$n pt");
		}
	}

	if(/^ \+ (\d+) $/x) {
		# Roughly equivalent to CSS 2.1 "larger"
		return parseFontSize sprintf "%d%%", 100 * (1.25 ** $1);
	}

	if(/^ - (\d+) $/x) {
		# Roughly equivalent to CSS 2.1 "smaller"
		return parseFontSize sprintf "%d%%", 100 * (0.85 ** $1);
	}

	return undef;
}

my %cssColor = map { $_ => 1 } qw(
	maroon red orange yellow olive
	purple fuchsia white lime green
	navy blue aqua teal
	black silver gray
);

BEGIN { _tag qw(parseColor parse) }
sub parseColor($) {
	local $_ = $_[0];
	return undef unless defined $_;
	s/\s+//g;
	$_ = lc $_;

	return $1 if /^(\w+)$/ and exists $cssColor{$1};

	if(s/^#//) {
		s/^ ( [0-9a-f]{1,2} ) $/$1$1$1/x;
		s/^ ([0-9a-f]) \1 ([0-9a-f]) \2 ([0-9a-f]) \3 $/$1$2$3/x;

		return "#$_" if /^ [0-9a-f]{3} $/x;
		return "#$_" if /^ [0-9a-f]{6} $/x;
	} else {
		return $1 if /^( rgb \( (?: \d+ , ){2} \d+ \) )$/x;
		return $1 if /^( rgba\( (?: \d+ , ){3} \d+ \) )$/x;
		return $1 if /^( rgb \( (?: \d+% , ){2} \d+% \) )$/x;
		return $1 if /^( rgba\( (?: \d+% , ){3} \d+% \) )$/x;
	}
	return undef;
}

sub _url_parse_opaque($) {
	local $_ = $_[0];
	my @ret = (undef) x 3;

	$ret[2] = $1	if s/(#.*)$//;
	$ret[0] = lc $1	if s/^([\w+-]+)://;
	$ret[1] = $_;

	return @ret if wantarray;
	return \@ret;
}

sub _url_parse_query($) {
	local $_ = $_[0];
	my @ret = (undef) x 2;

	$ret[1] = $1 if s/(\?.*)$//;
	$ret[0] = $_;

	return @ret if wantarray;
	return \@ret;
}

sub _url_parse_path($) {
	local $_ = $_[0];
	my @ret = (undef) x 2;

	if(s#^//##) {
		$ret[0] = $1 if s#^([^/]+)##;
		s#^$#/#;
		$ret[1] = $_;
	} elsif(m#^/#) {
		$ret[1] = $_;
	} else {
		return () if wantarray;
		return undef;
	}

	return @ret if wantarray;
	return \@ret;
}

sub _url_parse_server($) {
	local $_ = $_[0];
	my($userpass,$hostport);

	if(/^ ([^@]*) \@ ([^@]*) $/x) {
		($userpass,$hostport) = ($1,$2);
	} else {
		$hostport = $_;
	}

	my @ret = (undef) x 4;

	$_ = $userpass;
	if(defined $_) {
		if(/^ ([^:]*) : ([^:]*) $/x) {
			@ret[0,1] = ($1,$2);
		} else {
			$ret[0] = $_;
		}
	}

	$_ = $hostport;
	if(s/:(\d+)$//) {
		$ret[3] = $1;
	} elsif(s/:([\w+-]+)$//) {
		$ret[3] = getservbyname($1,'tcp');
		goto Failure if not defined $ret[3];
	} else {
		s/:$//;
	}

	s/\.*$/./;
	if(/^ ( (?: [\w-]+ \. )+ ) $/x) {
		$ret[2] = $1;
		$ret[2] =~ s/\.$//;
	}

	goto Failure if not defined $ret[2];
	return @ret if wantarray;
	return \@ret;

Failure:
	return () if wantarray;
	return undef;
}

my %urltype = (
	'http'		=> 3,
	'https'		=> 3,
	'ftp'		=> 3,

	'file'		=> 2,

	'mailto'	=> 1,

	'data'		=> 0,
	'javascript' => 0,
);

sub _url_parse($$) {
	my($str,$schemes) = @_;

	my($scheme,$opaque,$fragment) = _url_parse_opaque($str);
	return undef unless defined $scheme;
	return undef unless exists $urltype{$scheme};

	if($urltype{$scheme} > 0) {
		my($rest,$query) = _url_parse_query($opaque);

		if($urltype{$scheme} > 1) {
			my($auth,$path) = _url_parse_path($rest);
			return undef unless defined $path;

			if($urltype{$scheme} > 2) {
				return undef unless defined $auth;
				my($user,$pass,$host,$port) = _url_parse_server($auth);
				return undef unless defined $host;

				$auth = '';
				if(defined $user) {
					$auth .= $user;
					$auth .= ':'.$pass if defined $pass;
					$auth .= '@';
				}
				$auth .= $host;
				$auth .= ':'.$port if defined $port;
			}

			$rest = join '', map { defined $_ ? $_ : '' } ('//',$auth,$path);
		}

		$opaque = join '', map { defined $_ ? $_ : '' } ($rest,$query);
	}
	$str = $scheme.':'.$opaque.(defined $fragment ? $fragment : '');

	my $url = URI->new_abs($str, 'http://sanity.check.example.com/')->canonical;
	return undef unless defined $url->scheme;
	return undef unless exists $$schemes{$url->scheme};
	return undef if $url->as_string =~ /\bsanity\.check\.example\.com\b/i;
	return undef if $url->can('userinfo') and defined $url->userinfo;
	return undef if $url->can('host') and not defined $url->host;
	if($url->can('to')) {
		return undef if not defined $url->to;
		return undef if not $url->to =~ /^ [\w.+-]+ \@ (?: \w[\w-]*(?<=\w) \. )* [a-z]{2,6} $/xi;
		$url->query(undef);
	}
	return $url;
}

BEGIN { _tag qw(parseURL parse) }
my %schemes = map { $_ => 1 } qw(http https ftp data);
sub parseURL($) {
	foreach('%', 'http://%') {
		my $str = $_;
		$str =~ s/%/$_[0]/g;
		my $url = _url_parse($str, \%schemes);
		return $url if defined $url;
	}
	return undef;
}

BEGIN { _tag qw(parseMailURL parse) }
sub parseMailURL($) {
	foreach('%', 'mailto:%') {
		my $str = $_;
		$str =~ s/%/$_[0]/g;
		my $url = _url_parse($str, { mailto => 1 });
		return $url if defined $url;
	}
	return undef;
}

BEGIN { _tag qw(textURL text) }
sub textURL($) {
	my $url = shift;
	$url = parseURL($url) if not ref $url;
	return undef if not defined $url;
	if($url->scheme eq 'mailto') {
		return $url->to;
	}
	if($url->scheme eq 'http' or $url->scheme eq 'https') {
		if(not defined $url->query or $url->query eq '') {
			if($url->path eq '' or $url->path eq '/') {
				return $url->host;
			}
			return $url->host.$url->path;
		}
	}
	if($url->scheme eq 'ftp') {
		return $url->path.' on '.$url->host.' (FTP)';
	}
	if($url->scheme eq 'data') {
		my $m = $url->media_type;
		if(defined $m) {
			$m =~ s/;.*$//;
			return "Inline data ($m)";
		}
		return "Inline data";
	}
	return $url->as_string;

}

BEGIN { _tag qw(textALT text) }
sub textALT($) {
	my $url = shift;
	$url = parseURL($url) if not ref $url;
	return undef if not defined $url;
	if($url->scheme eq 'data') {
		return "[Inline data]";
	}
	my $path = $url->path;
	$path =~ s#^.*/##;
	return "[$path]";
}

BEGIN {
	push @EXPORT_OK, @{$EXPORT_TAGS{ALL}} if exists $EXPORT_TAGS{ALL};
	push @EXPORT, @{$EXPORT_TAGS{DEFAULT}} if exists $EXPORT_TAGS{DEFAULT};
}

1;
