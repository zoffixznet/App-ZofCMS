package App::ZofCMS;

use warnings;
use strict;

our $VERSION = '0.0225';


1;
__END__

=encoding utf8

=head1 NAME

App::ZofCMS::Plugin - documentation for ZofCMS plugin authors

=head1 SYNOPSYS

    package App::ZofCMS::Plugins::QueryToTemplate;

    use strict;
    use warnings;

    sub new { bless {}, shift; }

    sub process {
        my ( $self, $template, $query, $config ) = @_;
        
        keys %$query;
        while ( my ( $key, $value ) = each %$query ) {
            $template->{t}{"query_$key"} = $value;
        }
        
        return;
    }

    1;
    __END__

    PLEASE INCLUDE DECENT PLUGIN DOCUMENTATION

=head1 DESCRIPTION

This documentation is intended for ZofCMS plugin authors, whether you are
coding a plugin for personal use or planning to upload to CPAN. Uploads
are more than welcome.

First of all, the plugin must be located in App::ZofCMS::Plugin:: namespace.

At the very least the plugin must contain to subs:

    sub new { bless {}, shift }

This is a constructor, you don't have to use a hashref for the object but
it's recommended. Currently no arguments (except a class name) are passed
to C<new()> but that may be changed in the future.

Second required sub is C<sub process {}> the C<@_> will contain the
following (in this order):

    $self     -- object of your plugin
    $template -- hashref which is ZofCMS template, go nuts
    $query    -- hashref containing query parameters as keys/values
    $config   -- App::ZofCMS::Config object, from here you can obtain
                 a CGI object via C<cgi()> method.

Return value is discarded.

Normally a plugin would take user input from ZofCMS template hashref.
If you are using anything outside the C<d> key (as described in
L<App::ZofCMS::Template> please C<delete()> the key from ZofCMS template.

=head1 AUTHOR

Zoffix Znet, C<< <zoffix at cpan.org> >>
(L<http://zoffix.com>, L<http://haslayout.net>)

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-zofcms at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-ZofCMS>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::ZofCMS

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-ZofCMS>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-ZofCMS>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-ZofCMS>

=item * Search CPAN

L<http://search.cpan.org/dist/App-ZofCMS>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2008 Zoffix Znet, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

