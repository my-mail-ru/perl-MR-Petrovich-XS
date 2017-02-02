=head1 NAME

MR::Petrovich::XS - Perl extension for C<libpetrovich>

=head1 SYNOPSIS

  use MR::Petrovich::XS;

  $petr = MR::Petrovich::XS->instance();
  $petr = MR::Petrovich::XS->instance(config_path => $path_to_yml_config);

  MR::Petrovich::XS->inflect_first_name( $name, $gender, $case )
  MR::Petrovich::XS->inflect_last_name( $name, $gender, $case )
  MR::Petrovich::XS->inflect_middle_name( $name, $gender, $case )

=head1 DESCRIPTION

MR::Petrovich::XS provides an interface to C<libpetrovich> library (see L<https://github.com/my-mail-ru/petrovich-c>), which allows you inflect Russian first, last and middle names.
Inflect rules are given from YAML file. This file can be found here L<https://github.com/my-mail-ru/petrovich-rules>.

=cut

package MR::Petrovich::XS;

use 5.008008;
use strict;
use warnings;
use utf8;

our $VERSION = '0.02';

require XSLoader;
XSLoader::load('MR::Petrovich::XS', $VERSION);

use base qw/Class::Singleton/;
use Carp qw/confess/;

=head1 CONSTANTS

=head2 KIND

=over

=item KIND_FIRST_NAME

=item KIND_MIDDLE_NAME

=item KIND_LAST_NAME

=back

=head2 GENDER

=over

=item GENDER_MALE

=item GENDER_FEMALE

=item GENDER_ANDROGYNOUS

=back

=head2 CASE

=over

=item CASE_NOMINATIVE

=item CASE_GENITIVE

=item CASE_DATIVE

=item CASE_ACCUSATIVE

=item CASE_INSTRUMENTAL

=item CASE_PREPOSITIONAL

=back

=cut

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

=head1 METHODS

=over 4

=item instance(%p)

Makes instance of MR::Petrovich::XS. C<%p> accepts only one parameter - C<config_path>, that defines path to rules config file. 
Default path is C</usr/local/etc/petrovich/rules.yml>

=cut

sub _new_instance {
    my ($class, %p) = @_;

    $p{config_path} ||= '/usr/local/etc/petrovich/rules.yml';

    my $self  = bless \%p, $class;
    init_from_file($self->{config_path}); 
    return $self;
}

=item OBJ->inflect_name($name, $kind, $gender, $case)

Inflect male or female (see C<GENDER_*> constants) C<$name>, that can be first, last or middle part of name (see C<KIND_*> constants), to choosen case (see C<CASE_*> constants).
Method returns inflected name if result is successful, or original name otherwise.

=cut
sub inflect_name {
    confess "Wrong arguments count!" unless @_ == 5; 

    my ($self, $name, $kind, $gender, $case) = @_;
    confess "Illegal kind '$kind'!" if $kind < 0 || $kind > KIND_MAX_IDX;
    confess "Illegal gender '$gender'!" if $gender < 0 || $gender > GENDER_MAX_IDX;
    confess "Illegal case '$case'!" if $case < 0 || $case > CASE_MAX_IDX;

    return $name unless $name;

    use bytes;
    my $len = length($name);
    my $inflected_name = _inflect_name($name, $len, $kind, $gender, $case);
    warn "Can't inflect name '$name' (kind:$kind; gender:$gender; case:$case)" if !$inflected_name && $name;
    no bytes;
    return $inflected_name || $name;
}

=item OBJ->inflect_first_name($name, $gender, $case)

Same as C<inflect_name>, but for first names only. 

=cut

sub inflect_first_name {
    my ($self, $name, $gender, $case) = @_;
    return $self->inflect_name($name, KIND_FIRST_NAME, $gender, $case);
}

=item OBJ->inflect_middle_name($name, $gender, $case)

Same as C<inflect_name>, but for middle names only. 

=cut

sub inflect_middle_name {
    my ($self, $name, $gender, $case) = @_;
    return $self->inflect_name($name, KIND_MIDDLE_NAME, $gender, $case);
}

=item OBJ->inflect_last_name($name, $gender, $case)

Same as C<inflect_name>, but for last names only. 

=cut

sub inflect_last_name {
    my ($self, $name, $gender, $case) = @_;
    return $self->inflect_name($name, KIND_LAST_NAME, $gender, $case);
}

sub DESTROY {
    my ($self) = @_;
    free_context();
}

1;

=back

=head1 AUTHOR

Alexander Kazakov, E<lt>voland.kot@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Alexander Kazakov

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
