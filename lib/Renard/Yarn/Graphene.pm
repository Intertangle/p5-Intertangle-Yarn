use Modern::Perl;
package Renard::Yarn::Graphene;
# ABSTRACT: Load the Graphene graphic types library

use Glib::Object::Introspection;
use DynaLoader;

my $_GRAPHENE_BASENAME = 'Graphene';
my $_GRAPHENE_VERSION = '1.0';
my $_GRAPHENE_PACKAGE = __PACKAGE__;

my @_FLATTEN_ARRAY_REF_RETURN_FOR = qw/
/;

use Env qw(@GI_TYPELIB_PATH @PATH);
use Alien::Graphene;

sub import {
	if( Alien::Graphene->install_type eq 'share' ) {
		unshift @GI_TYPELIB_PATH, Alien::Graphene->gi_typelib_path;
		if( $^O eq 'MSWin32' ) {
			push @PATH, Alien::Graphene->rpath;
		} else {
			push @DynaLoader::dl_library_path, Alien::Graphene->rpath;
			my @files = DynaLoader::dl_findfile("-lgraphene-1.0");
			DynaLoader::dl_load_file($files[0]) if @files;
		}
	}

	Glib::Object::Introspection->setup(
		basename => $_GRAPHENE_BASENAME,
		version  => $_GRAPHENE_VERSION,
		package  => $_GRAPHENE_PACKAGE,
		flatten_array_ref_return_for => \@_FLATTEN_ARRAY_REF_RETURN_FOR,
	);
}

=method Inline

  use Inline C with => qw(Renard::Yarn::Graphene);

Returns the flags needed to configure L<Inline::C> to use with
C<graphene-gobject-1.0>.

=cut
sub Inline {
	return unless $_[-1] eq 'C';

	require Renard::Incunabula::Glib;
	require Hash::Merge;
	my $glib = Renard::Incunabula::Glib->Inline($_[-1]);

	my @nosearch = $^O eq 'MSWin32' ? (':nosearch') : ();
	my @search   = $^O eq 'MSWin32' ? ( ':search' ) : ();
	my $graphene = {
		CCFLAGSEX => join(" ", delete $glib->{CCFLAGSEX}, Alien::Graphene->cflags),
		LIBS => join(" ", @nosearch, delete $glib->{LIBS}, Alien::Graphene->libs, @search),
		AUTO_INCLUDE => <<C,
#include <graphene.h>
#include <graphene-gobject.h>
C
	};

	my $merge = Hash::Merge->new('RETAINMENT_PRECEDENT');
	$merge->merge( $glib, $graphene );
}

package Renard::Yarn::Graphene::DataPrinterRole {
	use Role::Tiny;
	use Module::Load;

	BEGIN {
		eval {
			autoload Data::Printer::Filter;
			autoload Term::ANSIColor;
			autoload Package::Stash;
		};
	}

	sub _data_printer {
		my ($self, $prop) = @_;

		my $FIELDS = Package::Stash->new( ref $self )->get_symbol( '@FIELDS' );
		my $data = {
			map { $_ => $self->$_ } @$FIELDS
		};

		my $text = '';

		$text .= $prop->{colored} ? "(@{[colored(['green'], ref($self))]}) " : "(@{[ ref($self) ]}) ";
		$text .= Data::Printer::np($data, %$prop, _current_indent => 0, multiline => 0, );

		$text;
	}
}


package Renard::Yarn::Graphene::Size {
	our @FIELDS = qw(width height);
	use Role::Tiny::With;
	with 'Renard::Yarn::Graphene::DataPrinterRole';
	use overload
		'""' => \&op_str,
		'eq' => \&op_eq,
		'==' => \&op_eq;

	sub op_str {
		"[w: @{[ $_[0]->width ]}, h: @{[ $_[0]->height ]}]"
	}

	sub op_eq {
		$_[0]->width     == (Scalar::Util::blessed $_[1] ? $_[1]->width  : $_[1]->[0] )
		&& $_[0]->height == (Scalar::Util::blessed $_[1] ? $_[1]->height : $_[1]->[1] )
	}

	sub to_HashRef() {
		+{ map { $_ => $_[0]->$_ } @FIELDS };
	}
}

package Renard::Yarn::Graphene::Point {
	our @FIELDS = qw(x y);
	use Scalar::Util;
	use Role::Tiny::With;
	with 'Renard::Yarn::Graphene::DataPrinterRole';
	use overload
		'""' => \&op_str,
		'eq' => \&op_eq,
		'==' => \&op_eq;

	sub op_str {
		"[x: @{[ $_[0]->x ]}, y: @{[ $_[0]->y ]}]";
	}

	sub op_eq {
		$_[0]->x    == (Scalar::Util::blessed $_[1] ? $_[1]->x : $_[1]->[0] )
		&& $_[0]->y == (Scalar::Util::blessed $_[1] ? $_[1]->y : $_[1]->[1] )
	}

	sub to_HashRef() {
		+{ map { $_ => $_[0]->$_ } @FIELDS };
	}

	sub to_Point3D {
		my ($self) = @_;
		my $point3d = Renard::Yarn::Graphene::Point3D->new(
			x => $self->x,
			y => $self->y,
			z => 0,
		);
	}
}

package Renard::Yarn::Graphene::Point3D {
	our @FIELDS = qw(x y z);
	use Scalar::Util;
	use Role::Tiny::With;
	with 'Renard::Yarn::Graphene::DataPrinterRole';
	use overload
		'""' => \&op_str,
		'eq' => \&op_eq,
		'==' => \&op_eq;

	sub op_str {
		"[x: @{[ $_[0]->x ]}, y: @{[ $_[0]->y ]}], y: @{[ $_[0]->z ]}";
	}

	sub op_eq {
		$_[0]->x    == (Scalar::Util::blessed $_[1] ? $_[1]->x : $_[1]->[0] )
		&& $_[0]->y == (Scalar::Util::blessed $_[1] ? $_[1]->y : $_[1]->[1] )
		&& $_[0]->z == (Scalar::Util::blessed $_[1] ? $_[1]->z : $_[1]->[1] )
	}

	sub to_HashRef() {
		+{ map { $_ => $_[0]->$_ } @FIELDS };
	}
}

package Renard::Yarn::Graphene::Vec2 {
	our @FIELDS = qw(x y);
	use Scalar::Util;
	use Role::Tiny::With;
	with 'Renard::Yarn::Graphene::DataPrinterRole';
	use overload
		'""' => \&op_str,
		'eq' => \&op_eq,
		'==' => \&op_eq;

	sub new {
		my ($class, %args) = @_;

		my $vec2 = Renard::Yarn::Graphene::Vec2->alloc();
		$vec2->init( $args{x}, $args{y} );

		$vec2;
	}

	sub x {
		$_[0]->dot( Renard::Yarn::Graphene::Vec2::x_axis() );
	}

	sub y {
		$_[0]->dot( Renard::Yarn::Graphene::Vec2::y_axis() );
	}

	sub op_str {
		"[x: @{[ $_[0]->x ]}, y: @{[ $_[0]->y ]}]";
	}

	sub op_eq {
		$_[0]->x    == (Scalar::Util::blessed $_[1] ? $_[1]->x : $_[1]->[0] )
		&& $_[0]->y == (Scalar::Util::blessed $_[1] ? $_[1]->y : $_[1]->[1] )
	}

	sub to_HashRef() {
		+{ map { $_ => $_[0]->$_ } @FIELDS };
	}
}

package Renard::Yarn::Graphene::Rect {
	our @FIELDS = qw(origin size);
	use Role::Tiny::With;
	with 'Renard::Yarn::Graphene::DataPrinterRole';

	sub new {
		my ($class, %args) = @_;

		my $rect = Renard::Yarn::Graphene::Rect::alloc();
		$rect->init(
			$args{origin}->x, $args{origin}->y,
			$args{size}->width, $args{size}->height,
		);

		$rect;
	}
}

package Renard::Yarn::Graphene::Matrix {
	use Module::Load;
	use overload
		'""' => \&op_str,
		'*'  => \&op_transform,
		'x'  => \&op_matmult;

	sub new_from_arrayref {
		my ($class, $data) = @_;
		my $obj = $class->new;
		$obj->init_from_arrayref( $data );

		$obj;
	}

	sub new_from_float {
		my ($class, $data) = @_;
		my $obj = $class->new;
		$obj->init_from_float( $data );

		$obj;
	}

	sub init_from_arrayref {
		my ($class, $data) = @_;

		unless(
			@$data == 4
				&& @{ $data->[0] }  == 4
				&& @{ $data->[1] }  == 4
				&& @{ $data->[2] }  == 4
				&& @{ $data->[3] }  == 4
		) {
			die "Matrix data must be a 4x4 ArrayRef";
		}

		$class->init_from_float(
			[
				@{ $data->[0] },
				@{ $data->[1] },
				@{ $data->[2] },
				@{ $data->[3] },
			]
		);
	}

	sub to_ArrayRef {
		my ($self) = @_;
		my $data = [
			map {
				my $row = $self->get_row($_);
				[ $row->get_x, $row->get_y, $row->get_z, $row->get_w ]
			} 0..3
		];

		$data;
	}

	sub _data_printer {
		my ($self, $prop) = @_;

		BEGIN {
			eval {
				autoload Data::Printer::Filter;
				autoload Term::ANSIColor;
			};
		}

		my $text = '';

		$text .= $prop->{colored} ? "(@{[colored(['green'], ref($self))]}) " : "(@{[ ref($self) ]}) ";
		$text .= Data::Printer::np($self->to_ArrayRef, %$prop, _current_indent => 0, multiline => 0, );

		$text;
	}

	sub op_str {
		my $row_text = sub { "@{[ $_[0]->get_x ]} @{[ $_[0]->get_y ]} @{[ $_[0]->get_z ]} @{[ $_[0]->get_w ]}" };
		my $text = "";
		$text .= "[\n";
		$text .= " "x4 . $row_text->( $_[0]->get_row(0) ) . "\n";
		$text .= " "x4 . $row_text->( $_[0]->get_row(1) ) . "\n";
		$text .= " "x4 . $row_text->( $_[0]->get_row(2) ) . "\n";
		$text .= " "x4 . $row_text->( $_[0]->get_row(3) ) . "\n";
		$text .= "]\n";
	}

	sub transform_point {
		my ($self, $point ) = @_;

		my $point3d = $point->to_Point3D;
		my $t_point3d = $self->transform_point3d( $point3d );

		return Renard::Yarn::Graphene::Point->new(
			x => $t_point3d->x,
			y => $t_point3d->y,
		);
	};

	sub transform {
		my ($matrix, $other) = @_;

		my $result;

		if(      $other->isa('Renard::Yarn::Graphene::Vec4') )     { $result = $matrix->transform_vec4( $other )
		} elsif( $other->isa('Renard::Yarn::Graphene::Vec3') )     { $result = $matrix->transform_vec3( $other )
		} elsif( $other->isa('Renard::Yarn::Graphene::Point') )    { $result = $matrix->transform_point( $other )
		} elsif( $other->isa('Renard::Yarn::Graphene::Point3D') )  { $result = $matrix->transform_point3d( $other )
		} elsif( $other->isa('Renard::Yarn::Graphene::Rect') )     { $result = $matrix->transform_rect( $other )
		} elsif( $other->isa('Renard::Yarn::Graphene::Bounds') )   { $result = $matrix->transform_bounds( $other )
		} elsif( $other->isa('Renard::Yarn::Graphene::Box') )      { $result = $matrix->transform_box( $other )
		} elsif( $other->isa('Renard::Yarn::Graphene::Sphere') )   { $result = $matrix->transform_sphere( $other )
		} else {
			die "Unknown type for transformation: @{[ ref $other ]}";
		}


		$result;
	}

	sub op_transform {
		$_[0]->transform( $_[1] );
	}

	sub op_matmult {
		$_[0]->multiply( $_[1] );
	}
}

1;
