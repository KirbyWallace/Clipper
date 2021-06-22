/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Snatch( cInStr, nLowBound, nHighBound ) --> cString

PARAMETERS:

cInStr     : string to extract from
nLowBound  : Low position number
nHighBound : high position number

SHORT:

A modified SUBSTR() with absolute from/to params rather than from/len.

DESCRIPTION:

k_Snatch() returns a string between two positions rather than between a 
start/offset (as with substr()).

It is a useful alternative to substr() where you must supply a start position 
and a number of characters.  When you are not sure where the substr is or how 
long it is, you can use k_Snatch() in conjunction with k_NthOccr(), at(), 
etc, to get the substr even when you do not know it's exact placement within 
the string.

NOTE:



EXAMPLE:

t = k_Snatch('ABCDEFGHIJ',5,10)
Result: t = 'EFGHIJ'

When the exact placement of the string is unknown, but a set of 
delimiting characters IS known:

string1 = 'Dear <FNAME>, Howdy!'
string2 = 'Greetings <FULLNAME>'

t1 = k_Snatch(string1,at('<',string1)+1,at('>',string1)-1)
t2 = k_Snatch(string2,at('<',string1)+1,at('>',string1)-1)

Result: t1 = "FNAME"
t2 = "FULLNAME"

Note that in this example, the same k_Snatch() syntax extracts the text 
delimited by <> even though the desired texts were of different lengths and 
began at different positions.

******************************************************************************/

FUNCTION k_Snatch(cInStr,nLowBound,nHighBound)
RETURN( substr(cInStr,nLowBound,(nHighBound-nLowBound)+1))

