#!/usr/bin/env perl

use Test::Most tests => 2;
use Modern::Perl;
use Renard::Yarn::Graphene;

subtest "Create point" => sub {
	ok my $p = Renard::Yarn::Graphene::Point->new( x => 1, y => -0.5 ), 'create Point';
	cmp_deeply $p->x, num(1), 'x dimension';
	cmp_deeply $p->y, num(-0.5), 'y dimension';
};

subtest "Modify point coordinate" => sub {
	ok my $p = Renard::Yarn::Graphene::Point->new(), 'create Point';
	my $tol = 1E-5;

	cmp_deeply $p->x, num(0, $tol), 'x dimension is zero by default';

	$p->x(4.2);

	cmp_deeply $p->x, num(4.2, $tol), 'x dimension is changed';
};

done_testing;
