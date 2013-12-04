
package App::ZofCMS::Output;

use strict;
use warnings;
use Carp;

our $VERSION = '0.0225';

sub new {
    my ( $class, $config, $template ) = @_;
    my $self = bless {}, $class;
    $self->config( $config );
    $self->conf( $config->conf );
    $self->template( $template );
    return $self;
}

sub headers {
    my $self = shift;
    my $query = $self->config->query;
    if ( $query->{dir} eq '/' and $query->{page} eq '404' ) {
         return $self->config->cgi->header('text/html','404 Not Found');
    }
    return $self->config->cgi->header( -type => 'text/html', -charset => 'utf-8' );
}

sub output {
    my $self = shift;

    return $self->template->html_template->output;
}

sub config {
    my $self = shift;
    if ( @_ ) {
        $self->{ config } = shift;
    }
    return $self->{ config };
}


sub conf {
    my $self = shift;
    if ( @_ ) {
        $self->{ conf } = shift;
    }
    return $self->{ conf };
}


sub template {
    my $self = shift;
    if ( @_ ) {
        $self->{ template } = shift;
    }
    return $self->{ template };
}


1;
__END__

=encoding utf8

=head1 NAME

App::ZofCMS::Output - "core" part of ZofCMS - web-framework/templating system

=head1 SYNOPSYS

N/A

=head1 DESCRIPTION

This module is used internally by L<App::ZofCMS> and currently does not
provide anything "public".

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

