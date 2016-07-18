# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl MR-Petrovich-XS.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More;
use utf8;
use Encode;
BEGIN { use_ok('MR::Petrovich::XS') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

is(MR::Petrovich::XS::init_from_file("../rules.yml"), 0, "init");

my $fn = "Саша";
my $mn = "Михайлович";
my $ln = "Казаков";

is(decode_utf8(MR::Petrovich::XS::inflect_first_name( $fn, MR::Petrovich::XS::GENDER_MALE, MR::Petrovich::XS::CASE_DATIVE)), "Саше", "sasha");
is(decode_utf8(MR::Petrovich::XS::inflect_middle_name($mn, MR::Petrovich::XS::GENDER_MALE, MR::Petrovich::XS::CASE_DATIVE)), "Михайловичу", "mikhailovich");
is(decode_utf8(MR::Petrovich::XS::inflect_last_name(  $ln, MR::Petrovich::XS::GENDER_MALE, MR::Petrovich::XS::CASE_DATIVE)), "Казакову", "kazakov");

MR::Petrovich::XS::free_context();

done_testing;
