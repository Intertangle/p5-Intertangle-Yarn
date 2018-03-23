use Renard::Incunabula::Common::Setup;
package Renard::Yarn::Types;
# ABSTRACT: Types for Yarn

use Type::Library 0.008 -base,
	-declare => [qw(
		Point
		Vec2
		Size
	)];
use Type::Utils -all;
use Types::Standard qw(Tuple Num);
use Types::Common::Numeric qw(PositiveOrZeroNum);

use Renard::Yarn::Graphene;

=type Point

A type for any reference that extends L<Renard::Yarn::Graphene::Point>

Coercible from a C<Tuple[Num, Num]>.

=cut
class_type "Point",
	{ class => 'Renard::Yarn::Graphene::Point' };

coerce "Point",
	from Tuple[Num, Num],
	via {
		Renard::Yarn::Graphene::Point->new(
			x => $_->[0],
			y => $_->[1],
		)
	};

=type Vec2

A type for any reference that extends L<Renard::Yarn::Graphene::Vec2>

Coercible from a C<Tuple[Num, Num]>.

=cut
class_type "Vec2",
	{ class => 'Renard::Yarn::Graphene::Vec2' };

coerce "Vec2",
	from Tuple[Num, Num],
	via {
		Renard::Yarn::Graphene::Vec2->new(
			x => $_->[0],
			y => $_->[1],
		)
	};

=type Size

A type for any reference that extends L<Renard::Yarn::Graphene::Size>

Coercible from a C<Tuple[PositiveOrZeroNum, PositiveOrZeroNum]>.

=cut
class_type "Size",
	{ class => 'Renard::Yarn::Graphene::Size' };

coerce "Size",
	from Tuple[PositiveOrZeroNum, PositiveOrZeroNum],
	via {
		Renard::Yarn::Graphene::Size->new(
			width  => $_->[0],
			height => $_->[1],
		)
	};


1;
