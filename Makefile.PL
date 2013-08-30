use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;

my %conf = (
    NAME           => 'Text::Decaptcha',
    AUTHOR         => 'gray <gray@cpan.org>',
    LICENSE        => 'perl',
    VERSION_FROM   => 'lib/Text/Decaptcha.pm',
    ABSTRACT_FROM  => 'lib/Text/Decaptcha.pm',
    PREREQ_PM      => { 'Lingua::EN::Words2Nums' => 0 },
    BUILD_REQUIRES => { 'Test::More' => 0.98, },
    META_MERGE     => {
        resources =>  {
            repository => 'https://github.com/gray/text-decaptcha',
        },
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'Text-Decaptcha-*' },
);

my $eumm_version =  do {
    no warnings 'numeric';
    eval $ExtUtils::MakeMaker::VERSION;
};
delete $conf{META_MERGE} if $eumm_version < 6.46;
$conf{PREREQ_PM} = {
    %{ $conf{PREREQ_PM} || {} }, %{ delete $conf{BUILD_REQUIRES} },
} if ($conf{BUILD_REQUIRES} and $eumm_version < 6.5503);

WriteMakefile(%conf);


sub MY::postamble {
    return <<"    MAKE_FRAG";
authortest:
\t\$(MAKE) -e \$(TEST_TYPE) TEST_FILES="xt/*.t"
    MAKE_FRAG
}

sub MY::dist_test {
    my $self = shift;
    return $self->MM::dist_test . <<"    MAKE_FRAG";
\tcd \$(DISTVNAME) && \$(MAKE) authortest \$(PASTHRU)
    MAKE_FRAG
}
