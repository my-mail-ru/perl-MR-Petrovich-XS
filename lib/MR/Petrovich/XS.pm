package MR::Petrovich::XS;

use 5.008009;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

require XSLoader;
XSLoader::load('MR::Petrovich::XS', $VERSION);

use base qw/Class::Singleton/;
use Carp qw/confess/;

use constant KIND_MAX_IDX   => 2;
use constant CASE_MAX_IDX   => 5;
use constant GENDER_MAX_IDX => 2;

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

sub _new_instance {
    my ($class, %p) = @_;

    $p{config_path} ||= '/usr/local/etc/petrovich/rules.yml';

    my $self  = bless \%p, $class;
    init_from_file($self->{config_path}); 
    return $self;
}

sub inflect_name {
    confess "Wrong arguments count!" unless @_ == 5; 

    my ($self, $name, $kind, $gender, $case) = @_;
    confess "Illegal kind '$kind'!" if $kind < 0 || $kind > KIND_MAX_IDX;
    confess "Illegal gender '$gender'!" if $gender < 0 || $gender > GENDER_MAX_IDX;
    confess "Illegal case '$case'!" if $case < 0 || $case > CASE_MAX_IDX;

    use bytes;
    $name = _inflect_name($name, length($name), $kind, $gender, $case);
    no bytes;
    return $name;
}

sub inflect_first_name {
    my ($self, $name, $gender, $case) = @_;
    return $self->inflect_name($name, KIND_FIRST_NAME, $gender, $case);
}

sub inflect_middle_name {
    my ($self, $name, $gender, $case) = @_;
    return $self->inflect_name($name, KIND_MIDDLE_NAME, $gender, $case);
}

sub inflect_last_name {
    my ($self, $name, $gender, $case) = @_;
    return $self->inflect_name($name, KIND_LAST_NAME, $gender, $case);
}

sub DESTROY {
    my ($self) = @_;
    free_context();
}

1;

=head1 NAME

MR::Petrovich::XS - Perl extension for libpetrovich

=head1 SYNOPSIS

  use MR::Petrovich::XS;

  $petr = MR::Petrovich::XS->instance();
  $petr = MR::Petrovich::XS->instance(config_path => $path_to_yml_config);

  MR::Petrovich::XS->inflect_first_name( $name, $gender, $case )
  MR::Petrovich::XS->inflect_last_name( $name, $gender, $case )
  MR::Petrovich::XS->inflect_middle_name( $name, $gender, $case )

=head1 DESCRIPTION

=head2 EXPORT

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Alexander Kazakov, E<lt>akazakov@corp.mail.ruE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Alexander Kazakov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
