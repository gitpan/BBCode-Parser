# $Id: Parser.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Parser;
use Carp ();
use BBCode::Util qw(:set :parse :tag);
use BBCode::Tag;
use BBCode::Body;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

BBCode::Parser - Parses BBCode tags

=head1 DESCRIPTION

BBCode is a simplified markup language used in several online forums
and bulletin boards.  It originated with phpBB, and remains most popular
among applications written in PHP.  Generally, users author their posts in
BBCode, and the forum converts it to a permitted subset of well-formed HTML.

C<BBCode::Parser> is a proper recursive parser for BBCode-formatted text.

=head1 METHODS

=cut

my %SETTINGS;

BEGIN {
	no strict 'refs';

	%SETTINGS = (
		css_prefix			=> 'bbcode-',
		css_direct_styles	=> 0,
		follow_links		=> 0,
		follow_override		=> 0,
		allow_image_bullets	=> 1,
		permitted			=> {
			':ALL' => 1,
			'HTML' => 0,
		},
	);

	foreach my $attr (qw(css_prefix)) {
		*$attr = sub($;$):method {
			my $this = shift;
			if(@_) {
				my $val = shift;
				if(defined $val) {
					die qq(Invalid attribute $attr => "$val")
						if ref $val or not $val =~ /^[\w-]*$/;
					$this->{$attr} = $val;
				} else {
					$this->{$attr} = $SETTINGS{$attr};
				}
			}
			return $this->{$attr};
		};
	}

	foreach my $attr (qw(css_direct_styles follow_links follow_override allow_image_bullets)) {
		*$attr = sub($;$):method {
			my $this = shift;
			if(@_) {
				my $val = shift;
				if(defined $val) {
					$val = parseBool($val);
					die qq(Invalid attribute $attr => "$val") if not defined $val;
					$this->{$attr} = $val;
				} else {
					$this->{$attr} = $SETTINGS{$attr};
				}
			}
			return $this->{$attr};
		};
	}
}

sub permitted($;$):method {
	my $this = shift;
	if(@_) {
		if(@_ == 1 and ref $_[0]) {
			my $val = shift;
			if(UNIVERSAL::isa($val,'ARRAY')) {
				$this->{permitted} = setCreate(@$val);
			} elsif(UNIVERSAL::isa($val,'HASH')) {
				$this->{permitted} = $val;
			} else {
				die qq(Unknown reference type $val);
			}
		} elsif(@_ == 1 and defined $_[0]) {
			my $val = shift;
			$val =~ s/^\s+|\s+$//g;
			$this->permitted([ split /\s+/, $val ]);
		} elsif(@_ == 1) {
			$this->{permitted} = { %{$SETTINGS{permitted}} };
		} else {
			$this->permitted(\@_);
		}
	}
	return %{$this->{permitted}} if wantarray;
	return $this->{permitted};
}

=head2 new

	my $parser = BBCode::Parser->new(%args);

C<new> creates a new C<BBCode::Parser>.  Any arguments
are handed off to the L</"set"> method.

=cut

sub new($%):method {
	my $class = shift;
	$class = ref($class) || $class;
	my $this = bless {}, $class;
	foreach(keys %SETTINGS) { $this->$_(undef); }
	$this->set(@_);
	return $this;
}

=head2 get

	if($parser->get('foo')) {
		# Foo enabled
	} else {
		# Foo disabled
	}

C<get> returns settings for the given parser.

=cut

sub get($@):method {
	my $this = shift;
	my @ret;
	while(@_) {
		my $key = shift;
		Carp::confess qq(Unknown setting "$key") unless $this->can($key);
		push @ret, $this->$key();
	}
	return @ret if wantarray;
	return $ret[0] if @ret == 1;
	return \@ret;
}

=head2 set

	$parser->set(foo => 1);

C<set> alters settings for the given parser.

=cut

sub set($%):method {
	my $this = shift;
	while(@_) {
		my($key,$val) = splice @_, 0, 2;
		Carp::confess qq(Unknown setting "$key") unless $this->can($key);
		$this->$key($val);
	}
	return $this;
}

=head2 permit

	$parser->permit(qw(:INLINE !:LINK));

C<permit> adds TAGs and :CLASSes to the list of permitted tags.  Use '!' in
front of a tag or class to negate the meaning.

=cut

sub permit($@):method {
	my $this = shift;
	setUpdate(%{$this->permitted}, @_);
	return $this;
}

=head2 forbid

	$parser->forbid(qw(:ALL !:TEXT));

C<forbid> adds TAGs and :CLASSes to the list of forbidden tags.  Use '!' in
front of a tag or class to negate the meaning.

=cut

sub forbid($@):method {
	my $this = shift;
	my %tmp;
	setUpdate(%tmp, @_);
	setNegate(%tmp);
	setMerge(%{$this->permitted}, %tmp);
	return $this;
}

=head2 isPermitted

	if($parser->isPermitted('IMG')) {
		# Yay, [IMG] tags
	} else {
		# Damn, no [IMG] tags
	}

C<forbid> checks if a tag is permitted by the current settings.

=cut

sub isPermitted($$):method {
	my($this,$tag) = @_;
	return setContainsTag(%{$this->permitted}, $tag, 0);
}

sub _args(\$) {
	my($ref,$ok,$k,$v,@args);
	$ref = shift;
	$ok = 0;

	while(length $$ref > 0) {
		$v = '' if not defined $v;

		next if $$ref =~ s/^\s+//;

		if($$ref =~ s/^\\//) {
			Carp::confess qq(Invalid BBCode: Backslash at end of text) unless $$ref =~ s/^(.)//s;
			$v .= $1 unless $1 eq "\n";
			next;
		}

		if($$ref =~ s/^(["'])//) {
			my $q = $1;
			my $qok = 0;
			while(length $$ref > 0) {
				$qok++, last if $$ref =~ s/^\Q$q\E//;
				if($$ref =~ s/^\\//) {
					Carp::confess qq(Invalid BBCode: Backslash at end of text) unless $$ref =~ s/^(.)//s;
					$v .= $1 unless $1 eq "\n";
				}
				$$ref =~ s/^(.)//s;
				$v .= $1 eq "\n" ? " " : $1;
			}
			Carp::confess qq(Invalid BBCode: Quoted string never ends) unless $qok;
			next;
		}
		if($$ref =~ s/^([,\]])//) {
			push @args, [ $k, $v ];
			$k = undef;
			$v = '';
			if($1 eq ']') {
				$ok++;
				last;
			}
			next;
		}
		if($$ref =~ s/^=//) {
			$k = uc $v;
			$v = '';
			next;
		}

		$$ref =~ s/^(.)//;
		$v .= $1;
	}

	Carp::confess qq(Invalid BBCode: Unterminated tag) unless $ok;
	return @args if wantarray;
	return \@args;
}

sub _tokenize($$) {
	my($this,$ref) = @_;
	my(@tokens);

	while(length $$ref > 0) {
		if($$ref =~ s/^ ([^\[<&]+) //x) {
			push @tokens, [ 'TEXT', [ undef, $1 ] ];
			next;
		}

		# Special case
		if($$ref =~ s/^ \[ HTML \] //xi) {
			$$ref =~ s/^ (.*?) \[ \/ HTML \] //xis;
			push @tokens, [ 'HTML', [ undef, $1 ] ];
			next;
		}

		# Special case
		if($$ref =~ s/^ \[ (\/?) \* \] //x) {
			push @tokens, [ $1.'LI' ];
			next;
		}

		# Special case
		if($$ref =~ s/^ \[ ( URL | EMAIL | IMG ) \] //xi) {
			push @tokens, [ '_'.uc($1) ];
			next;
		}

		if($$ref =~ s/^ \[ ( \/? \w+ ) \] //x) {
			my $tag = uc($1);
			if(tagExists($tag)) {
				push @tokens, [ $tag ];
			} else {
				push @tokens, [ 'TEXT', [ undef, "[$1]" ] ];
			}
			next;
		}

		if($$ref =~ s/^ \[ (\w+) ( \s*=\s* | ,? \s+ ) //x) {
			my $tag = uc($1);
			if(tagExists($tag)) {
				push @tokens, [ $tag, _args($$ref) ];
			} else {
				push @tokens, [ 'TEXT', [ undef, "[$1$2" ] ];
			}
			next;
		}

		if($$ref =~ s/^ \[ //x) {
			Carp::confess qq(Invalid BBCode);
		}

		if($$ref =~ s/^ <URL: ([^<>]*) > //x) {
			my $text = $1;
			my $url;
			if(defined($url = parseURL($text))) {
				push @tokens, [ 'URL', [ undef, $url->as_string ] ];
				push @tokens, [ 'TEXT', [ undef, $text ] ];
				push @tokens, [ '/URL' ];
			} elsif(defined($url = parseMailURL($text))) {
				push @tokens, [ 'EMAIL', [ undef, $url->as_string ] ];
				push @tokens, [ 'TEXT', [ undef, $text ] ];
				push @tokens, [ '/EMAIL' ];
			} else {
				push @tokens, [ 'TEXT', [ undef, "<URL:$text>" ] ];
			}
			next;
		}

		if($$ref =~ s/^ & ( [^&;]+ ) ; //x) {
			if(defined parseEntity($1)) {
				push @tokens, [ 'ENT', [ undef, $1 ] ];
			} else {
				push @tokens, [ 'TEXT', [ undef, "&$1;" ] ];
			}
			next;
		}

		$$ref =~ s/^ (.) //x;
		push @tokens, [ 'TEXT', [ undef, $1 ] ];
	}

	return \@tokens;
}

sub _top(\@) {
	my $stack = shift;
	return $$stack[$#$stack];
}

sub _parse($$$) {
	my($this,$root,$ref) = @_;
	my @st = ($root);

TOKEN:while(@$ref) {
		my $token = shift @$ref;

		if($token->[0] =~ s#^/##) {
			my @old = @st;
			while(@st) {
				if($token->[0] eq pop(@st)->Tag) {
					next TOKEN;
				}
			}
			Carp::confess 'Illegal close tag: expected [/'._top(@old)->Tag.'], got [/'.$token->[0].']';
		}

		my $tag = BBCode::Tag->new($this, @$token);

		while(@st) {
			eval {
				_top(@st)->pushBody($tag);
			};
			last if not $@;
			die $@ if not $@ =~ /^Invalid tag nesting/;
			pop(@st);
		}
		die qq(Invalid tag nesting) if not @st;

		push @st, $tag if $tag->BodyPermitted;
	}
}

=head2 parse

	my $tree = $parser->parse('[b]BBCode[/b] text.');

C<parse> creates a parse tree for the given BBCode.  The result is a
tree of L<BBCode::Tag> objects.  The most common use of the parse tree is
to convert it to HTML using L<BBCode::Tag-E<gt>toHTML()|BBCode::Tag/"toHTML">:

	my $html = $tree->toHTML;

=cut

sub parse($@):method {
	Carp::confess qq(EBCDIC platforms not supported) unless "A" eq "\x41";

	my $this = shift;
	$this = $this->new() unless ref $this;

	my $text = join "\n", @_;
	$text =~ s/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F-\x9F]+//;
	$text =~ s/(?:\r\n|\r|\n)/\n/g;

	my $tokens = $this->_tokenize(\$text);
	my $body = BBCode::Body->new($this);
	$this->_parse($body, $tokens);

	return $body->replaceBody;
}

1;

=head1 SEE ALSO

L<BBCode::Tag>

=head1 AUTHOR

Donald King E<lt>dlking@cpan.orgE<gt>

=cut
