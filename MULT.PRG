/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Mult( cVal1, cVal2 ) --> cProduct

PARAMETERS:

cVar1 : Multiplicand
cVar2 : Multiplier

SHORT:

Perform multiplication to 64,000 digits (I swear, it's the truth!, kinda)

DESCRIPTION:

k_Mult() performs multiplication on POSITIVE whole numbers represented 
as strings.  The benefit of this is that you may multiply numbers 
of astronomical proportions: 65,535 total digits!  Thus, the two 
largest numbers that could be multiplied (give or take - probably take - 
a digit or two) would be:

k_Mult( Replicate('9',32768), Replicate('9',32768) )

I'll spare you the result of this operation!  If you printed it, it would 
span 11 pages in compressed print or stretch about 420 feet if printed all 
on one line (including commas)!

A product of two numbers will never exceed twice the number of the number 
of digits in the multiplicand and the multiplier. (that is, xx*yy will 
never exceed 4 significant digits, xxx*yyy will never exceed 6 
significant digits, etc.)  For that reason, 64K is the maximum number 
of digits between the two numbers.  The following would work:

k_Mult( Replicate('9',60000), Replicate('9',2000) )

because the product will be no greater than 62000 digits long.


This would NOT work:

k_Mult( Replicate('9',60000), Replicate('9',9000) )

because the resulting string will exceed the capacity of Clipper's string 
data type.  It couldn't allocate a string big enough to hold the 
resulting number string!

The product is always returned as a string for obvious reasons.

If you embed a space or other non-digit character in a number string, then 
you're just dumb and outta luck!  It will work, but you will get unreliable 
and incorrect results.

NOTE:



EXAMPLE:

cStr = k_Mult('123',321')

? cStr = '39483' // .t.

? k_Mult('1234567890123456789','545') = '67283950011728395005' // .t.


Clipper Numeric and k_Mult() multiplications:

    12345678901234567890
                     x 1
    --------------------
    12345678901234570000   Numeric
    12345678901234567890   k_Mult()


    12345678901234567890
                     x 8
    --------------------
    98765431209876540000   Numeric
    98765431209876543120   k_Mult()


    12345678901234567890
                     x 9
    --------------------
    ********************   Numeric
   111111110111111111010   k_Mult()


Why not?  What the heck?  How about:


                      1234567890123456789
                    x 1234567890123456789
                    ---------------------
                     * Are You kidding? *   Numeric
    1524157875323883675019051998750190521   k_Mult()


Yes, now YOU too can work for the congressional budget office and explain 
Bill Clinton's tax policies - They've been using this function for a year 
now, really.  I swear it's the truth!  Would I lie?

******************************************************************************/

FUNCTION k_Mult(cVar1, cVar2)

LOCAL    cRetVal := '', cProduct := ''
LOCAL    nCarry  := 0,  nDigit   := 0
LOCAL    i, j

cVar1 = alltrim(cVar1) ; cVar2 = alltrim(cVar2)

for i = 1 to len(cVar2)

    for j = 1 to len(cVar1)

        nDigit = val(substr(cVar2,-i,1)) * val(substr(cVar1,-j,1)) + nCarry

        nCarry = int(nDigit/10) ; nDigit = (nDigit-(nCarry*10))

        cProduct = alltrim(str(nDigit))+cProduct

    next

    if nCarry > 0
        cProduct = alltrim(str(nCarry))+cProduct
        nCarry = 0
    endif

    cRetVal = k_Add(cProduct+iif(i > 1,repl('0',i-1),''),cRetVal)

    cProduct = ''

next

RETURN(cRetVal)

