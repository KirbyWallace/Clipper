/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FDelete( cFileSpec ) --> NIL

PARAMETERS:

cFileSpec : a File spec.  Paths and wildcards OK.

SHORT:

Delete specified file(s) from drive.

DESCRIPTION:

k_FDelete() Deletes files!

NOTE:



EXAMPLE:

k_FDelete('ABC.DEF')
k_FDelete('*.DEF')
k_FDelete("*.d??")

All three of the above accomplish the same thing.

Clipper's ferase() function does not recognize wildcards.  This function 
mends that.

All of the above would work equivalently.  The wildcards may "take out" 
other files other than ABC.DEF.  For instance, the last one would also 
erase ABC.DEG.

But, you know DOS filename conventions, right?  I mean, you've READ 
the DOS manual, right?  Nudge-Nudge.... wink wink, say no more.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_FDelete(cFileSpec)

LOCAL    i
LOCAL    acFiles[adir(cFileSpec)]
LOCAL    cTemp

adir(cFileSpec, acFiles)
cTemp = k_ParseF(cFileSpec, PARSE_FPATH)

for i = 1 to len(acFiles)
    ferase( cTemp+acFiles[i] )
next

RETURN(NIL)

