package pragma;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

pragma - A pragma for controlling other user pragmas

=head1 DESCRIPTION

The C<pragma> pragma is a module which influences other user pragmata
such as L<lint>. With Perl 5.10 you can create user pragmata and the
C<pragma> pragma can modify and peek at other pragmata.

=head1 A basic example

Assume you're using the C<myint> pragma mentioned in
L<perlpragma>. For ease, that pragma is duplicated here. You'll see it
sets the C<myint> value to 1 when on and 0 when off.

    package myint;
    
    use strict;
    use warnings;
    
    sub import {
        $^H{myint} = 1;
    }
    
    sub unimport {
        $^H{myint} = 0;
    }
    
    1;

Other code might casually wish to dip into C<myint>:
    
    no pragma 'myint';      # delete $^H{myint}
    use pragma myint => 42; # $^H{myint} = 42

    print pragma->peek( 'myint' ); # prints '42'

The above could have been written without the C<pragma> module as:

    BEGIN { delete $^H{myint} }
    BEGIN { $^H{myint} = 42 }

    print $^H{myint};

=cut

=head1 CLASS METHODS

=over

=item C<< use pragma PRAGMA => VALUE >>

=item C<< pragma->import( PRAGMA => VALUE ) >>

=item C<< pragma->poke( PRAGMA => VALUE ) >>

Sets C<PRAGMA>'s value to C<VALUE>.

=cut

sub import {

    # Handle "use pragma;"
    return if 1 == @_;

    my ( undef, $pragma, $value ) = @_;

    $^H{$pragma} = $value;
    return;
}
*poke = \&import;

=item C<< no pragma PRAGMA >>

=item C<< pragma->unimport( PRAGMA ) >>

Unsets C<PRAGMA>.

=cut

sub unimport {

    # Handle "no pragma";
    return if 1 == @_;

    my ( undef, $pragma ) = @_;

    delete $^H{$pragma} if exists $^H{$pragma};
    return;
}

=item C<< pragma->peek( PRAGMA ) >>

Returns the current value of C<PRAGMA>.

=cut

sub peek {
    my ( undef, $pragma ) = @_;

    # use Data::Dumper 'Dumper';
    # my $cx = 0;
    # while ( caller $cx ) {
    #     print Dumper( [ $cx, ( caller $cx )[10] ] );
    #     ++$cx;
    # }

    my $hints_hash = ( caller 0 )[10];
    return unless $hints_hash;
    return unless exists $hints_hash->{$pragma};
    return $hints_hash->{$pragma};
}

=back

=head1 SUBCLASSING

All methods may be subclassed.

=cut

q[And I don't think an entire stallion of horses, or a tank, could stop you two from getting married.];
