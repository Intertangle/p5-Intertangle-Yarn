#!/usr/bin/env perl

use Test::Most tests => 1;
use Modern::Perl;
use Renard::Yarn::Graphene;

subtest "Loaded Graphene" => sub {
	can_ok 'Renard::Yarn::Graphene::Point', qw(new distance);
};

done_testing;
