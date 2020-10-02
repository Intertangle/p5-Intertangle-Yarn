use Modern::Perl;
package Intertangle::Yarn::Types;
# ABSTRACT: Types for Yarn

use Type::Library 0.008 -base,
	-declare => [qw(
		Point
		Vec2
		Size
		AngleDegrees
		Rect
		Matrix
	)];
use Type::Utils -all;
use Types::Standard qw(Tuple Num);
use Types::Common::Numeric qw(PositiveOrZeroNum);

use Intertangle::Yarn::Graphene;

=type Point

A type for any reference that extends L<Intertangle::Yarn::Graphene::Point>

Coercible from a C<Tuple[Num, Num]>.

=cut
class_type "Point",
	{ class => 'Intertangle::Yarn::Graphene::Point' };

coerce "Point",
	from Tuple[Num, Num],
	via {
		Intertangle::Yarn::Graphene::Point->new(
			x => $_->[0],
			y => $_->[1],
		)
	};

=type Vec2

A type for any reference that extends L<Intertangle::Yarn::Graphene::Vec2>

Coercible from a C<Tuple[Num, Num]>.

=cut
class_type "Vec2",
	{ class => 'Intertangle::Yarn::Graphene::Vec2' };

coerce "Vec2",
	from Tuple[Num, Num],
	via {
		Intertangle::Yarn::Graphene::Vec2->new(
			x => $_->[0],
			y => $_->[1],
		)
	};

=type Size

A type for any reference that extends L<Intertangle::Yarn::Graphene::Size>

Coercible from a C<Tuple[PositiveOrZeroNum, PositiveOrZeroNum]>.

=cut
class_type "Size",
	{ class => 'Intertangle::Yarn::Graphene::Size' };

coerce "Size",
	from Tuple[PositiveOrZeroNum, PositiveOrZeroNum],
	via {
		Intertangle::Yarn::Graphene::Size->new(
			width  => $_->[0],
			height => $_->[1],
		)
	};

=type AngleDegrees

A type for an angle in degrees. Aliased to L<Num>.

=cut
declare "AngleDegrees", parent => Num;

=type Rect

A type for any reference that extends L<Intertangle::Yarn::Graphene::Rect>

=cut
class_type "Rect",
	{ class => 'Intertangle::Yarn::Graphene::Rect' };

=type Matrix

A type for any reference that extends L<Intertangle::Yarn::Graphene::Matrix>

=cut
class_type "Matrix",
	{ class => 'Intertangle::Yarn::Graphene::Matrix' };

1;
