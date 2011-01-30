package FooBar;

use strict;

require TengA::SchemaOnAHole;

sub import {
    my ( $class, @args ) = @_;

    TengA::SchemaOnAHole->import(
        { import_level => 1 },
        'foo' => sub  {
            my ( $schema, $table, $col, $val ) = @_;
            $schema->{ foo }->{ $table->name }->{ $col } = $val;
        },
        'bar' => sub  {
            my ( $schema, $table, $col, $val ) = @_;
            $schema->{ bar }->{ $table->name }->{ $col } = $val;
        },
    );
}


1;
