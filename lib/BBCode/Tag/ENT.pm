# $Id: ENT.pm 75 2005-08-22 18:22:43Z chronos $
package BBCode::Tag::ENT;
use base qw(BBCode::Tag);
use BBCode::Util qw(:parse);
use strict;
use warnings;

sub Class($):method {
	return qw(TEXT INLINE);
}

sub NamedParams($):method {
	return qw(VAL);
}

sub DefaultParam($):method {
	return 'VAL';
}

sub validateParam($$$):method {
	my($this,$param,$val) = @_;
	if($param eq 'VAL') {
		my $ent = parseEntity($val);
		if(defined $ent) {
			return $ent;
		} else {
			die qq(Invalid value "$val" for [ENT]);
		}
	}
	return $this->SUPER::validateParam($param,$val);
}

sub toHTML($):method {
	my $this = shift;
	my $ent = $this->param('VAL');
	return "&$ent;" if defined $ent;
	return "";
}

1;
