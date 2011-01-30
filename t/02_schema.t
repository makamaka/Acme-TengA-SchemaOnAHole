use strict;
use warnings;
use Test::More;

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

my $schema = schema {

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

} "My::Schema";


is_deeply( $schema->{foo}->{ table1 } => { 'foo' => 'bar' } );
is_deeply( $schema->{bar}->{ table1 } => { 'bar' => 'baz' } );
is_deeply( $schema->{foo}->{ table2 } => { 'hoge' => 'foo' } );
is_deeply( $schema->{bar}->{ table2 } => { 'fuga' => 'bar' } );


eval {
    schema {
        table {
            name "table1";
            columns qw( col1 col2 col3 );
            foo foo => 'bar';
            bar bar => 'baz';
        };
    } "My::Schema";
};

like( $@, qr/must be used in table_in_private_room/, 'croak in using gaget in normal table.' );

done_testing;

1;
