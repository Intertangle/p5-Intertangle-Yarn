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



1;
