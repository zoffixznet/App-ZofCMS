use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::ZofCMS',
    license             => 'perl',
    dist_author         => 'Zoffix Znet <zoffix@cpan.org>',
    dist_version_from   => 'lib/App/ZofCMS.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Carp'           => 1.04,
        'CGI::Carp'      => 1.29,
        'CGI'            => 3.15,
        'File::Spec'     => 3.2701,
        'HTML::Template' => 2.9,
        'Getopt::Long'   => 2.35,
        'File::Path'     => 1.08,
        'File::Find'     => 1.12,
        'File::Copy'     => 2.09,
        perl             => '5.006',
    },
    configure_requires => { 'Module::Build' => 0 },
    add_to_cleanup      => [ 'App-ZofCMS-*' ],
    create_makefile_pl => 'traditional',
    script_files => [ 'script/zofcms_helper' ],
);

$builder->create_build_script();
