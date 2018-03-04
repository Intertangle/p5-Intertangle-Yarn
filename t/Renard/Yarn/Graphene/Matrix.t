#!/usr/bin/env perl

use Test::Most tests => 3;
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

subtest "Matrix from ArrayRef" => sub {
	my $m = Renard::Yarn::Graphene::Matrix->new_from_arrayref(
		[
			[ 1, 0, 0, 0 ],
			[ 0, 1, 0, 0 ],
			[ 0, 0, 1, 0 ],
			[ 0, 0, 0, 0 ],
		]
	);

	is "$m", <<EOF;
[
    1 0 0 0
    0 1 0 0
    0 0 1 0
    0 0 0 0
]
EOF
};

subtest "Matrix from ArrayRef must be correct size" => sub {
	throws_ok {
		Renard::Yarn::Graphene::Matrix->new_from_arrayref(
			[
				[ 1, 0, 0, 0 ],
				[ 0, 0, 1, 0 ],
				[ 0, 0, 0, 0 ],
			]
		);
	} qr/4x4/, 'too few rows';

	throws_ok {
		Renard::Yarn::Graphene::Matrix->new_from_arrayref(
			[
				[ 1, 0, 0, 0 ],
				[ 0, 0, 1, 0 ],
				[ 0, 0, 0, 0 ],
				[ 0, 0, 0, 0 ],
				[ 0, 0, 0, 0 ],
			]
		);
	} qr/4x4/, 'too many rows';

	throws_ok {
		Renard::Yarn::Graphene::Matrix->new_from_arrayref(
			[
				[ 1, 0, 0, 0 ],
				[ 0, 0, 0, 0 ],
				[ 0, 0, 0 ],
				[ 0, 0, 0, 0 ],
			]
		);
	} qr/4x4/, 'too few columns';

	throws_ok {
		Renard::Yarn::Graphene::Matrix->new_from_arrayref(
			[
				[ 1, 0, 0, 0 ],
				[ 0, 0, 0, 0,   1 ],
				[ 0, 0, 0, 0 ],
				[ 0, 0, 0, 0 ],
			]
		);
	} qr/4x4/, 'too many columns';
};

done_testing;
