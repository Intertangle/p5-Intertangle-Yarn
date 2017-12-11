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

	my $graphene = {
		CCFLAGSEX => join(" ", delete $glib->{CCFLAGSEX}, Alien::Graphene->cflags),
		LIBS => join(" ", delete $glib->{LIBS}, Alien::Graphene->libs),
		AUTO_INCLUDE => <<C,
#include <graphene.h>
#include <graphene-gobject.h>
C
	};

	my $merge = Hash::Merge->new('RETAINMENT_PRECEDENT');
	$merge->merge( $glib, $graphene );
}


1;
