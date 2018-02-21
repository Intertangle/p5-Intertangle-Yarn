#!/usr/bin/env perl

use Test::Most tests => 1;
use Modern::Perl;
use Renard::Yarn::Graphene;

subtest "Matrix stringify" => sub {
	my $m = Renard::Yarn::Graphene::Matrix->new;
	$m->init_from_float([ 0..15 ]);

	is "$m", <<EOF;
[
    0 1 2 3
    4 5 6 7
    8 9 10 11
    12 13 14 15
]
EOF
};

done_testing;
