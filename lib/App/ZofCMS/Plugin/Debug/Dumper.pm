package App::ZofCMS::Plugin::Debug::Dumper;

use warnings;
use strict;

# VERSION

use Data::Dumper;
use HTML::Entities (qw/encode_entities/);

sub new { bless {}, shift }

sub process {
    my ( $self, $template, $query, $config ) = @_;

    my %conf = (
        t_prefix => 'dumper_',
        use_qq   => 1,
        pre      => 1,
        escape_html => 1,
        line_length => 150,
        %{ delete $config->conf->{plug_dumper} || {} },
        %{ delete $template->{plug_dumper}     || {} },
    );

    if ( $conf{use_qq} ) {
        $Data::Dumper::Useqq = 1;
    }

    my $t_dump = Dumper $template;

    $template->{t}{ $conf{t_prefix} . 't' . $_ } = Dumper $template->{$_}
        for qw/t d/;

    $template->{t}{ $conf{t_prefix} . 't' } = $t_dump;
    $template->{t}{ $conf{t_prefix} . 'q' } = Dumper $query;
    $template->{t}{ $conf{t_prefix} . 'c' } = Dumper $config->conf;

    if ( $conf{line_length } ) {
        for ( qw/tt td t q c/ ) {
            $template->{t}{ $conf{t_prefix} . $_ } =~ s/(.{$conf{line_length}})(?!\n)/$1\n/g;
        }
    }

    if ( $conf{escape_html} ) {
        encode_entities $template->{t}{ $conf{t_prefix} . $_ }
            for qw/tt td t q c/;
    }

    if ( $conf{pre} ) {
        $template->{t}{ $conf{t_prefix} . $_ }
        = qq|<pre style="font-family: 'DejaVu Sans Mono', monotype;">|
            . $template->{t}{ $conf{t_prefix} . $_ } . q|</pre>|
            for qw/tt td t q c/;
    }

    return 1;
}

1;
__END__

=encoding utf8

=head1 NAME

App::ZofCMS::Plugin::Debug::Dumper - small debugging plugin that Data::Dumper::Dumper()s interesting portions into {t}

=head1 SYNOPSIS

In your Main Config file or ZofCMS Template:

    plugins => [ qw/Debug::Dumper/ ],

In your L<HTML::Template> template:

    Dump of {t} key: <tmpl_var name="dumper_tt">
    Dump of {d} key: <tmpl_var name="dumper_td">
    Dump of ZofCMS template: <tmpl_var name="dumper_t">
    Dump of query: <tmpl_var name="dumper_q">
    Dump of main config: <tmpl_var name="dumper_c">

=head1 DESCRIPTION

The module is a small debugging plugin for L<App::ZofCMS>. It uses L<Data::Dumper> to
make dumps of 5 things and sticks them into C<{t}> ZofCMS template key so you could display
the dumps in your L<HTML::Template> template for debugging purposes.

This documeantation assumes you've read L<App::ZofCMS>, L<App::ZofCMS::Config>
and L<App::ZofCMS::Template>

=head1 MAIN CONFIG FILE OR ZofCMS TEMPLATE

=head2 C<plugins>

    plugins => [ qw/Debug::Dumper/ ],

    plugins => [ { UserLogin => 100 }, { 'Debug::Dumper' => 200 } ],

You need to add the plugin to the list of plugins to execute (duh!). By setting the priority
of the plugin you can make dumps before or after some plugins executed.

=head2 C<plug_dumper>

    plug_dumper => {
        t_prefix    => 'dumper_',
        use_qq      => 1,
        pre         => 1,
        escape_html => 1,
        line_length => 80,
    },

The plugin takes configuration via C<plug_dumper> first-level key that can be either
in ZofCMS template or Main Config file, same keys set in ZofCMS template will override
those keys set in Main Config file. As opposed to many ZofCMS plugins,
L<App::ZofCMS::Plugin::Debug::Dumper> will B<still> execute even if the C<plug_dumper>
key is not set to anything.

The C<plug_dumper> key takes a hashref as a value. Possible keys/values of that hashref
are as follows:

=head3 C<t_prefix>

    { t_prefix => 'dumper_', }

B<Optional>. The C<t_prefix> specifies the string to use to prefix the names of the
L<HTML::Template> variables generated by the plugin in C<{t}> ZofCMS Template key. See
C<HTML::Template VARIABLES> section below for more information. B<Defaults to:> C<dumper_> (
note the underscore at the end)

=head3 C<use_qq>

    { use_qq => 1, }

B<Optional>. Can be set to either true or false values. When set to a true value, the plugin
will set C<$Data::Dumper::Useqq> to C<1> before making the dumps, this will basically
make, e.g. C<"\n">s instead of generating real new lines in output. See L<Data::Dumper> for
more information. B<Defaults to:> C<1>

=head3 C<pre>

    { pre => 1, }

B<Optional>. Can be set to either true or false values. When set to a true value the plugin
will wrap all the generated dumps into HTML C<< <pre></pre> >> tags. B<Defaults to:> C<1>

=head3 C<escape_html>

    { escape_html => 1, }

B<Optional>. Can be set to either true or false values. When set to a true value the plugin
will escape HTML code in the dumps. B<Defaults to:> C<1>

=head3 C<line_length>

    { line_length => 150, }

B<Optional>. The C<line_length> key takes a positive integer as a value. This value will
specify the maximum length of each line in generated dumps. Strictly speaking it will
stick a C<\n> after every C<line_length> characters that are not C<\n>.
B<Special value> or C<0> will B<disable> line length feature. B<Defaults to:> C<150>

=head1 HTML::Template VARIABLES

The plugin will stick the generated dumps in the C<{t}> ZofCMS template special key;
that means that you can dump them out in your L<HTML::Template> templates with
C<< <tmpl_var name""> >>s. The following five variables are available so far:

    Dump of {t} key: <tmpl_var name="dumper_tt">
    Dump of {d} key: <tmpl_var name="dumper_td">
    Dump of ZofCMS template: <tmpl_var name="dumper_t">
    Dump of query: <tmpl_var name="dumper_q">
    Dump of main config: <tmpl_var name="dumper_c">

The C<{t}> and C<{d}> keys refer to special keys in ZofCMS Templates. The C<query> is
the hashref of query parameters passed to the script and C<main config> is your Main Config
file hashref. The C<dumper_> prefix in the C<< <tmpl_var name=""> >>s above is the
C<t_prefix> that you can set in C<plug_dumper> configuration key (explained way above). In
other words, in your main config file or ZofCMS template you can set:
C<< plug_dumper => { t_prefix => '_' } >> and in L<HTML::Template> templates you'd then use
C<< <tmpl_var name="_tt"> >>, C<< <tmpl_var name="_q"> >>, etc.

The names are generated by using C<$t_prefix  . $name>, where C<$t_prefix> is C<t_prefix>
set in C<plug_dumper> and C<$name> is one of the "variable names" that are as follows:

=head2 C<tt>

    <tmpl_var name="dumper_tt">

The dump of C<{t}> ZofCMS template special key. Mnemonic: B<t>emplate {B<t>} key.

=head2 C<td>

    <tmpl_var name="dumper_td">

The dump of C<{d}> ZofCMS template special key. Mnemonic: B<t>emplate {B<d>} key.

=head2 C<t>

    <tmpl_var name="dumper_t">

The dump of entire ZofCMS template hashref. Mnemonic: B<t>emplate.

=head2 C<q>

    <tmpl_var name="dumper_q">

The dump of query parameters as a hashref, in parameter/value way. Mnemonic: B<q>uery.

=head2 C<c>

    <tmpl_var name="dumper_c">

The dump of your Main Config file hashref. Mnemonic: B<c>onfig.

=head1 SPECIAL NOTES

Note that all properly behaving plugins will remove their config data from ZofCMS templates
and Main Config files, that list includes this plugin as well, therefore when dumping
the ZofCMS template (C<< <tmpl_var name="dumper_t"> >>) after the plugins were executed, you
will not see the configuration for those plugins that you wrote.

=head1 SEE ALSO

L<Data::Dumper>

=head1 REPOSITORY

Fork this module on GitHub:
L<https://github.com/zoffixznet/App-ZofCMS>

=head1 BUGS

To report bugs or request features, please use
L<https://github.com/zoffixznet/App-ZofCMS/issues>

If you can't access GitHub, you can email your request
to C<bug-App-ZofCMS at rt.cpan.org>

=head1 AUTHOR

Zoffix Znet <zoffix at cpan.org>
(L<http://zoffix.com/>, L<http://haslayout.net/>)

=head1 LICENSE

You can use and distribute this module under the same terms as Perl itself.
See the C<LICENSE> file included in this distribution for complete
details.

=cut