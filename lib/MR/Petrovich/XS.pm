package MR::Petrovich::XS;

use 5.008009;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('MR::Petrovich::XS', $VERSION);

use constant KIND_FIRST_NAME  => 0;
use constant KIND_MIDDLE_NAME => 1;
use constant KIND_LAST_NAME   => 2;

use constant CASE_NOMINATIVE    => 0;
use constant CASE_GENITIVE      => 1;
use constant CASE_DATIVE        => 2;
use constant CASE_ACCUSATIVE    => 3;
use constant CASE_INSTRUMENTAL  => 4;
use constant CASE_PREPOSITIONAL => 5;

use constant GENDER_MALE        => 0;
use constant GENDER_FEMALE      => 1;
use constant GENDER_ANDROGYNOUS => 2;

sub inflect_name {
    my ($name, $kind, $gender, $case) = @_;
    use bytes;
    $name = _inflect_name($name, length($name), $kind, $gender, $case);
    no bytes;
    return $name;
}

sub inflect_first_name {
    my ($name, $gender, $case) = @_;
    return inflect_name($name, KIND_FIRST_NAME, $gender, $case);
}

sub inflect_middle_name {
    my ($name, $gender, $case) = @_;
    return inflect_name($name, KIND_MIDDLE_NAME, $gender, $case);
}

sub inflect_last_name {
    my ($name, $gender, $case) = @_;
    return inflect_name($name, KIND_LAST_NAME, $gender, $case);
}


1;

=head1 NAME

MR::Petrovich::XS - Perl extension for libpetrovich

=head1 SYNOPSIS

  use MR::Petrovich::XS;

  MR::Petrovich::XS::init_from_file($yaml_config_path);

  MR::Petrovich::XS::inflect_first_name( $name, $gender, $case )



=head1 DESCRIPTION

Stub documentation for MR::Petrovich::XS, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

akazakov, E<lt>akazakov@localdomainE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by akazakov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
