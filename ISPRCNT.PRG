/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IsPrcntOf( nVar1, nVar2 ) --> nPercent

PARAMETERS:

nVar1
nVar2

SHORT:

Returns "what is Var1 percent of Var2"

DESCRIPTION:

k_IsPrcntOf() returns var1% of var2 ( What is 20% of 250)

NOTE:



EXAMPLE:

k_IsPrcntOf(25,100) // 25
k_IsPrcntOf(5,80)   // 6.25

******************************************************************************/
FUNCTION k_IsPrcntOf(nVar1,nVar2)
RETURN( (nVar1/100) * nVar2 )

