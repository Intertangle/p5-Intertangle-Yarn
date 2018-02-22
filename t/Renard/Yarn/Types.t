#!/usr/bin/env perl

use Test::Most tests => 2;
use Renard::Yarn::Types qw(Point Size);

subtest "Point" => sub {
	my $p = Point->coerce( [ 2, 7 ] );
	is $p->x, 2, 'x';
	is $p->y, 7, 'y';
};

subtest "Size" => sub {
	my $s = Size->coerce( [ 10, 20 ] );
	is $s->width, 10, 'width';
	is $s->height, 20, 'height';
};

done_testing;
