/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Alen( aName ) --> nArrayLength

PARAMETERS:

aName : Character expression name of an array

SHORT:

Determine the number of array elements, excluding NIL elements.

DESCRIPTION:

k_Alen() returns the number of defined elements in any given array, exclusing 
NIL elements.  That is, k_Alen() determines how many array elements are 
actually defined.

NOTE:



EXAMPLE:

PRIVATE MyArray[10]
MyArray[1] = 'howdy'
MyArray[2] = 'hello'
MyArray[3] = 'hithere'
MyArray[7] = 'hi'

t = k_Alen(MyArray)

Result: t = 4

******************************************************************************/

FUNCTION k_Alen(aName)
LOCAL    nCount, i

nCount = 0

for i = 1 to len(aName)
    nCount += iif(valtype(aName[i]) != 'U',1,0)
next

RETURN(nCount)
