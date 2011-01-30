use strict;
use warnings;
use Test::More;

use lib qw(t/lib);
use Model;

my $model  = Model->new({ connect_info => [ 'dbi:SQLite:' ], schema_class => 'Model::SchemaUsingFooBar' });
my $schema = $model->schema;

is_deeply( $schema->{foo}->{ table1 } => { 'foo' => 'bar' } );
is_deeply( $schema->{bar}->{ table1 } => { 'bar' => 'baz' } );
is_deeply( $schema->{foo}->{ table2 } => { 'hoge' => 'foo' } );
is_deeply( $schema->{bar}->{ table2 } => { 'fuga' => 'bar' } );

done_testing;

1;
