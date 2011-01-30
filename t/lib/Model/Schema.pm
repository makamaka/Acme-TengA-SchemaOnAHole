package Model::Schema;

use strict;
use warnings;

use Teng::Schema::Declare;
use TengA::SchemaOnAHole (
   'foo' => sub  {
        my ( $schema, $table, $col, $val ) = @_;
        $schema->{ foo }->{ $table->name }->{ $col } = $val;
    },
   'bar' => sub  {
        my ( $schema, $table, $col, $val ) = @_;
        $schema->{ bar }->{ $table->name }->{ $col } = $val;
    },
);

table_in_private_room {
    name "table1";
    columns qw( col1 col2 col3 );
    foo foo => 'bar';
    bar bar => 'baz';
};

table_in_private_room {
    name "table2";
    columns qw( col1 col2 col3 );
    foo hoge => 'foo';
    bar fuga => 'bar';
};

1;

