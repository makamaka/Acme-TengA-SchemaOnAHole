require 5.008001;
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'          => 'Acme::TengA::SchemaOnAHole',
    'VERSION_FROM'  => 'lib/Acme/TengA/SchemaOnAHole.pm', # finds $VERSION
    'PREREQ_PM'     => {
              'Test::More'  => '0.96',
              'Teng'        => '0.05',
    },
    ( $ExtUtils::MakeMaker::VERSION >= 6.3002 ? ('LICENSE' => 'perl', ) : () ),

    ( $ExtUtils::MakeMaker::VERSION >= 6.46 ? (
        'META_MERGE' => {
            resources => {
                repository  =>  'http://github.com/makamaka/Acme-TengA-SchemaOnAHole',
            },
        } ) : ()
    ),
);

