/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PrcntOfIs( nVar1, nVar2 ) --> nPercent

PARAMETERS:

nVar1
nVar2




SHORT:

Returns "what is Var1 percent of Var2?"

DESCRIPTION:

k_PrcntOfIs() returns: var1 is ?% of var2  (20 is ?% of 250)

NOTE:



EXAMPLE:

k_PrcntOfIs(100,1000) // 10
k_PrcntOfIs(100,100)  // 100
k_PrcntOfIs(20,100)   // 20
k_PrcntOfIs(5,80)     // 6.25
k_PrcntOfIs(50,0)     // 0

******************************************************************************/


FUNCTION k_PrcntOfIs(nVar1,nVar2)
RETURN(iif(nVar2 != 0,nVar1/(nVar2/100),0))


