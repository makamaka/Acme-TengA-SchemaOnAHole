package TengA::SchemaOnAHole;

use strict;
use warnings;
use Carp ();
use Data::Dumper;
use Teng::Schema::Declare ();

our $VERSION = '0.01';

our $CURRENT_SCHEMA_CLASS;
our @CALLED_FUNCS;

my  @EXPORT = qw(table_in_private_room);


sub import {
    my ( $class, @args ) = @_;
    my $level = 0;

    if ( ref($args[0]) eq 'HASH' ) {
        my $opt = shift @args;
        $level = $opt->{ import_level } if exists $opt->{ import_level };
    }

    my $pkg = caller($level);

    no strict 'refs';
    no warnings 'redefine';

    for my $func ( @EXPORT ) {
        *{"$pkg\::$func"} = *{"$func"};
    }

    my %args = @args;

    for my $name ( keys %args ) {
        my $subref = $args{ $name };

        ref($subref) eq 'CODE' or Carp::croak "The value of $name must be a subroutine reference.";

        *{"$pkg\::$name"} = sub {
            unless ( $CURRENT_SCHEMA_CLASS ) {
                Carp::croak("Your funny gadget '$name' must be used in table_in_private_room()");
            }
            push @CALLED_FUNCS, [ $subref => @_ ];
        };
    }
}


sub table_in_private_room (&) {
    my $code = shift;

    my $caller_class = caller();

    local $CURRENT_SCHEMA_CLASS = Teng::Schema::Declare::_current_schema();
    local @CALLED_FUNCS;

    # push @CALLED_FUNCS in $code->() and execute in late
    my $table = eval qq{
        package $caller_class;
        table( sub { \$code->() } );
    };

    for my $func_args ( @CALLED_FUNCS ) {
        my ( $subref, @args ) = @$func_args;
        $subref->( $CURRENT_SCHEMA_CLASS, $table, @args );
    }

    return $table;
}


1;
__END__

=pod

=head1 NAME

TengA::SchemaOnAHole - Advance and make a hole to Teng::Schema::Declare

=head1 SYNOPSIS

    package MyModel::Schema;
    
    use Teng::Schema::Declare;
    use TengA::SchemaOnAHole (
       'foo' => sub  {
            my ( $schema, $table, $col, $val ) = @_;
            $schema->{ foo }->{ $table->name }->{ $col } = $val;
        }
    );
    
    table_in_private_room {
        name "table1";
        columns qw( col1 col2 col3 );
        foo 'foo', 'bar';
    };
    
    table_in_private_room {
        name "table2";
        columns qw( col1 col2 );
        foo 'bar', 'baz';
    };
    
    
    #
    # as plugin moudle
    #
    
    package TengA::Schema::Declare::FooBar;
    
    use strict;
    require TengA::SchemaOnAHole;
    
    sub import {
        my ( $class, @args ) = @_;
        TengA::SchemaOnAHole->import(
            { import_level => 1 },
            'bar' => sub  {
                my ( $schema, $table, @args ) = @_;
                # ...
            },
        );
    }
    
    # and use it.
    package MyModel::Schema2;
    
    use Teng::Schema::Declare;
    use TengA::Schema::Declare::FooBar;
    
    table_in_private_room {
        name "table1";
        columns qw( col1 col2 col3 );
        bar 'foo', 'bar';
    };

=head1 DESCRIPTION

This module advances L<Teng::Schema::Declare> (so, Teng - Advanced module).
You can use your new functions in Teng Schema DSL.

=head1 INTRODUCE FUNCTIONS

    use Teng::Schema::Declare;
    use TengA::SchemaOnAHole (
       'foo' => sub  {
            my ( $schema, $table, @args ) = @_;
            # ...
        }
    );

You pass fucntion name - code reference pairs to using TengA::SchemaOnAHole.
The code references take L<Teng::Schema> object, L<Teng::Schema::Table> and
passed arguments.

You can pass a optional hash reference as first argument.

=head2 option

=over 4

=item import_level

The import level for your setting functoin.
It is useful that you make a plugin module.

    package TengA::Schema::Declare::FooBar;
    
    require TengA::SchemaOnAHole;
    
    sub import {
        my ( $class, @args ) = @_;
        TengA::SchemaOnAHole->import(
            { import_level => 1 },
            'foo' => sub  {
                my ( $schema, $table, @args ) = @_;
                # ...
            },
        );
    }

=back

=head1 EXPORT FUNCTIONS

=head2 table_in_private_room

You can use your introduced functions only in C<table_in_private_room>.
All functions used in C<table> function can be used in C<table_in_private_room>.

If you use your introduced functions in normal C<table>, it croaks.

=head1 CAVEAT

You cannot set C<prototype> to introduced functions

=head1 SEE ALSO

L<Teng>, L<Tneg::Schema::Declare>,
L<Teng::Schema>, L<Teng::Schema::Table>

=head1 AUTHOR

Makamaka Hannyaharamitu, E<lt>makamaka[at]cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2011 by Makamaka Hannyaharamitu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
