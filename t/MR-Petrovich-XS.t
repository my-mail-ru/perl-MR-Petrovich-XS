# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl MR-Petrovich-XS.t'

#########################

# change 'tests => 1' to 'tests => lastconvert_to_print';

use Test::More;
use Test::LeakTrace;
use utf8;
use Encode;
BEGIN { use_ok('MR::Petrovich::XS') };

#########################

my $TEST_FN_MALE = [
    [
        "Саша", "Саши", "Саше", "Сашу", "Сашей", "Саше"
    ],
    [
        "Александр", "Александра", "Александру", "Александра", "Александром", "Александре"
    ],
    [
        "Сережа", "Сережи", "Сереже", "Сережу", "Сережей", "Сереже"
    ],
    [
        "Сергей", "Сергея", "Сергею", "Сергея", "Сергеем", "Сергее"
    ],
    [
        "Евгений", "Евгения", "Евгению", "Евгения", "Евгением", "Евгении"
    ],
    [
        "Гиви", "Гиви", "Гиви", "Гиви", "Гиви", "Гиви"
    ],
    [
        "Ян", "Яна", "Яну", "Яна", "Яном", "Яне"
    ],
];

my $TEST_FN_FEMALE = [
    [
        "Саша", "Саши", "Саше", "Сашу", "Сашей", "Саше"
    ],
    [
        "Александра", "Александры", "Александре", "Александру", "Александрой", "Александре"
    ],
    [
        "Лена", "Лены", "Лене", "Лену", "Леной", "Лене"
    ],
    [
        "Евгения", "Евгении", "Евгении", "Евгению", "Евгенией", "Евгении"
    ],
    [
        "Софья", "Софьи", "Софье", "Софью", "Софьей", "Софье"
    ],
    [
        "Гаяне", "Гаяне", "Гаяне", "Гаяне", "Гаяне", "Гаяне"
    ],
    [
        "Любовь", "Любови", "Любови", "Любовь", "Любовью", "Любови"
    ],
];

my $TEST_LN_MALE = [
    [
        "Казаков", "Казакова", "Казакову", "Казакова", "Казаковым", "Казакове"
    ],
    [
        "Путин", "Путина", "Путину", "Путина", "Путиным", "Путине"
    ],
    [
        "Сушко", "Сушко", "Сушко", "Сушко", "Сушко", "Сушко"
    ],
    [
        "Олейник", "Олейника", "Олейнику", "Олейника", "Олейником", "Олейнике"
    ],
];

my $TEST_LN_FEMALE = [
    [
        "Казакова", "Казаковой", "Казаковой", "Казакову", "Казаковой", "Казаковой"
    ],
    [
        "Путина", "Путиной", "Путиной", "Путину", "Путиной", "Путиной"
    ],
    [
        "Сушко", "Сушко", "Сушко", "Сушко", "Сушко", "Сушко"
    ],
    [
        "Олейник", "Олейник", "Олейник", "Олейник", "Олейник", "Олейник"
    ],
];

my $TEST_MN_MALE = [
    [
        "Михайлович", "Михайловича", "Михайловичу", "Михайловича", "Михайловичем", "Михайловиче"
    ],
];

my $TEST_MN_FEMALE = [
    [
        "Михайловна", "Михайловны", "Михайловне", "Михайловну", "Михайловной", "Михайловне"
    ],
];

my @GENDER = qw/ male female androgynous /; 
my @CASE = qw/ nominative genitive dative accusative instrumental prepositional /;

my $petr = MR::Petrovich::XS->instance();
ok(ref $petr eq 'MR::Petrovich::XS', "init");

sub convert {
    my ($kind, $t, $gender, %opts) = @_;
    
    my $method   = "inflect_".$kind."_name";
    if($opts{test}) {
        is($petr->$method($t->[0], $gender, $_), $t->[$_], 
            "Test $GENDER[$gender] $kind name [ ${\(encode_utf8($t->[0]))} ; $CASE[$_] ]") for 1..5;
    } else {
        $petr->$method($t->[0], $gender, $_) for 1..5;
    }
}

### First names
for my $t (@$TEST_FN_MALE) {
    convert('first', $t, MR::Petrovich::XS::GENDER_MALE, test => 1);
}

for my $t (@$TEST_FN_FEMALE) {
    convert('first', $t, MR::Petrovich::XS::GENDER_FEMALE, test => 1);
}

### Last names
for my $t (@$TEST_LN_MALE) {
    convert('last', $t, MR::Petrovich::XS::GENDER_MALE, test => 1);
}

for my $t (@$TEST_LN_FEMALE) {
    convert('last', $t, MR::Petrovich::XS::GENDER_FEMALE, test => 1);
}

### Middle names
for my $t (@$TEST_MN_MALE) {
    convert('middle', $t, MR::Petrovich::XS::GENDER_MALE, test => 1);
}

for my $t (@$TEST_MN_FEMALE) {
    convert('middle', $t, MR::Petrovich::XS::GENDER_FEMALE, test => 1);
}

### Leak test
no_leaks_ok {
    my $pert = MR::Petrovich::XS->instance();

    ### First names
    for my $t (@$TEST_FN_MALE) {
        convert('first', $t, MR::Petrovich::XS::GENDER_MALE, test => 0);
    }

    for my $t (@$TEST_FN_FEMALE) {
        convert('first', $t, MR::Petrovich::XS::GENDER_FEMALE, test => 0);
    }

    ### Last names
    for my $t (@$TEST_LN_MALE) {
        convert('last', $t, MR::Petrovich::XS::GENDER_MALE, test => 0);
    }

    for my $t (@$TEST_LN_FEMALE) {
        convert('last', $t, MR::Petrovich::XS::GENDER_FEMALE, test => 0);
    }

    ### Middle names
    for my $t (@$TEST_MN_MALE) {
        convert('middle', $t, MR::Petrovich::XS::GENDER_MALE, test => 0);
    }

    for my $t (@$TEST_MN_FEMALE) {
        convert('middle', $t, MR::Petrovich::XS::GENDER_FEMALE, test => 0);
    }
} "no memory leaks";

done_testing;
