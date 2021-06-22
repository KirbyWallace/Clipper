/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_BaseX2BaseY( cXNum, nXBase, nYBase ) --> cNumStr

PARAMETERS:

cXNum  : string representation of any number in base 1...72
nXBase : number indicating base of cXNum
nYBase : Base to convert cXNum into

SHORT:

Convert a number of any base 1...72 to any other base 1...72.

DESCRIPTION:

k_BaseX2BaseY() accepts any number of any base between 1 and 72 in 
STRING format (for obvious reasons with HEX (base 16) and greater) 
and converts it to the base specified in nYBase.

The most common bases numbering systems are:

Base 16 (Hexadecimal)
Base 10 (Decimal - our favourite!)
Base 8  (Octal)
Base 2  (Binary - our computer's favourite!)

Hexadecimal uses the digits 0-9 and A-F, for a total of 16 unique symbols.
Thus: base 16.

Vegisimal uses 20 unique characters and thus: Base 20.  This number system 
is purported to have been used by the ancient Mayan Indians.

But there ARE other number systems.  In fact, any number for which you
have that many unique symbols to represent values can be used as a base.
 
With the IBM PC, we have 256 unique symbols, making possible a base 256 
numbering system.  (What you might use that for is beyond me, but it is 
possible).  For simplicity, this function supports only base 1 through 72 
(approximately the number of printable, NORMAL, everyday English language 
characters available from the ascii set).

If you have the Klipper Library source code, it should not be at all
difficult to make modifications to allow a larger base number!  I've done
it, but because the results include characters that are not easily printed,
read, or manipulated, I prefer to stick to a more modest base 72 here.


NOTE:

NO ERROR CHECKING IS DONE TO ENSURE THAT THE CHARACTERS IN YOUR BASE 
NUMBER ARE VALID FOR THE GIVEN BASE!  ERROR CHECKING IS SACRIFICED FOR SAKE 
OF SPEED, AND IT IS ASSUMED THAT YOU KNOW WHAT YOU ARE DOING!  YOU SHOULD 
KNOW OR CHECK THE VALIDITY OF THE SYMBOLS IN YOUR SOURCE BASE NUMBER!

USE CAUTION:  FFGh will be considered a perfectly acceptable 
HEXadecimal number with "G" having the decimal equivalent of 16, even 
though there is no "G" in the Hexadecimal symbol set!!!

Likewise, in FGFh, the "G" will have the decimal equivelent of 289d, 
even though the maximum positional value in that place is 256d!!!

8o will be considered a perfectly acceptable Octal number with a value of 
8 even though there IS NO "8" in the Octal symbol set!!! 

1102b will be considered a perfectly acceptable Binary number with the 
"2" having a value of 2 even though there is no "2" in the Binary 
symbol set!!!

Who knows?  Maybe this has an interesting application?

As far as MAXIMUM values goes, I can only say that when either the number 
being converted or the resulting number exceeds the capacity of the computer's
16 digits of base 10 equivelent precision, you will get unpredictable results.

This is because the computer/compiler, unlike the human mind, must do it's math
and convert the results to BASE 10.  Thus, an intermediate Base 10 conversion
step is necessary!  When either the source or target number exceeds the capacity
of it's base 10 equivelent, this intermediate step fails and throws off the
resulting base (n) number.

Go figure!

Remember that the value coming back will always be a STRING representation 
of the number.  If you are deriving a DECIMAL value from some other base, 
you can convert it to numeric with VAL().


BE CAREFUL WITH THESE - YOU CAN GET SOME STRANGE RESULTS IF YOU DON'T 
CHECK YOU SYMBOLS CAREFULLY!  IT CAN GET REALLY SCAREY ONCE YOU GET UP 
INTO BASE 50 OR SO, WHERE ALL KINDS OF CHARACTERS ARE LEGAL!

IF YOU COME UP WITH AN INTERESTING APPLICATION FOR NUMBERS IN BASES 
HIGHER THAN 16, PLEASE LET ME KNOW!  I'D LOVE TO SEE IT!

The k_LineEd???() functions use this function for indexing the comment
databases.  It uses Base 26.  Check out the source code to those functions to 
see an example of this function in action with base greater than 16.

EXAMPLE:

#define VEG  20
#define HEX  16
#define DEC  10
#define OCT  8
#define QUAD 4
#define TRI  3
#define BIN  2

t = k_BaseX2BaseY('FFFF',HEX,DEC)       // "65535"
t = k_BaseX2BaseY('FFFF',HEX,OCT)       // "177777"
t = k_BaseX2BaseY('FFFF',HEX,BIN)       // "1111111111111111"
t = k_BaseX2BaseY('1101',BIN,DEC)       // "13"
t = k_BaseX2BaseY('1101',BIN,HEX)       // "D"
t = k_BaseX2BaseY('1201210',TRI,DEC)    // "1263"
t = k_BaseX2BaseY('598',DEC,TRI)        // "211011"
t = k_BaseX2BaseY('1032231',QUAD,DEC)   // "5037"
t = k_BaseX2BaseY('599',DEC,QUAD)       // "21113"
t = k_BaseX2BaseY('120',TRI,BIN)        // "1111"

// in base 3 120 = (1*9)+(2*3)+(0*1) = 1111b = 15d = Fh

Here are some examples of results obtained with "illegal" character sets!

t = k_BaseX2BaseY('FFG',HEX,DEC) // "4096"
// FFFh = 4095d  thus, theoritically, FFGh = 4096d even 
// though this is illegal!


t = k_BaseX2BaseY('678',OCT,DEC)  // 448
// 677o = 447d, ... same as above!


t = k_BaseX2BaseY('1101',BIN,DEC)  // 13
// this one is OK


t = k_BaseX2BaseY('1102',BIN,DEC)  // 14
// this one same rules as above.  The "2" is taken to mean 2
// even though it is an illegal character!

You can really have some fun with this function!  I had a hell of a time 
writting it. :-)

******************************************************************************/

FUNCTION k_BaseX2BaseY( cXNum, nXBase, nYBase )
RETURN(k_Dec2BaseX(k_BaseX2Dec(cXNum,nXBase),nYBase))

