#!/usr/bin/env perl
# Normalizes certain character sequences in Malayalam (in addition to standard
# NFC Unicode normalization).
# Copyright © 2022 Dan Zeman <zeman@ufal.mff.cuni.cz>
# License: GNU GPL

use utf8;
use open ':utf8';
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
binmode(STDERR, ':utf8');
use Unicode::Normalize;

while(<>)
{
    print(normalize_chillu(NFC($_)));
}



#------------------------------------------------------------------------------
# Malayalam has nine "chillu" consonants that are pronounced without vowel
# (unlike a normal consonant followed by viram, which is sometimes pronounced
# with a half-vowel ŭ). There was an older way of encoding the "chillu" glyphs
# without using a separate Unicode points for them: use the normal consonant
# followed by viram and the zero width joiner (U+200D). If the old encoding
# occurs, normalize it to the new encoding.
#------------------------------------------------------------------------------
sub normalize_chillu
{
    my $x = shift;
    $x =~ s/\x{D2E}\x{D4D}\x{200D}/\x{D54}/g; # chillu m
    $x =~ s/\x{D2F}\x{D4D}\x{200D}/\x{D55}/g; # chillu y
    $x =~ s/\x{D34}\x{D4D}\x{200D}/\x{D56}/g; # chillu lll
    $x =~ s/\x{D23}\x{D4D}\x{200D}/\x{D7A}/g; # chillu nn
    $x =~ s/\x{D28}\x{D4D}\x{200D}/\x{D7B}/g; # chillu n
    $x =~ s/\x{D30}\x{D4D}\x{200D}/\x{D7C}/g; # chillu rr
    $x =~ s/\x{D31}\x{D4D}\x{200D}/\x{D7C}/g; # chillu rr
    $x =~ s/\x{D32}\x{D4D}\x{200D}/\x{D7D}/g; # chillu l
    $x =~ s/\x{D33}\x{D4D}\x{200D}/\x{D7E}/g; # chillu ll
    $x =~ s/\x{D15}\x{D4D}\x{200D}/\x{D7F}/g; # chillu k
    if($x =~ m/(.)?\x{D4D}\x{200D}/)
    {
        my $code = sprintf("%X", ord($1));
        print STDERR ("WARNING: Cannot handle string '$1\x{D4D}\x{200D}' (\\x{$code} followed by viram and zero width joiner).\n");
    }
    return $x;
}
