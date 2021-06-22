/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PopBox( nTmax, nLMax, nBMax, nRMax, nType, cFill ) --> NIL

PARAMETERS:

nTMax : Top Row
nLMax : Left Column
nBMax : Bottom Row
nRMax : Right Column
nType : Type of Box Characters to use
cFill : Character to use to fill box (Default SPACE)

SHORT:

"Exploding" screen boxes.

DESCRIPTION:

k_PopBox() "explodes" a box onto the screen stopping at the given coordinates. 
Optionally, you may specify the box characters. Default box is Double 
Top/Single Side.

NOTE:

Due to the different CPU speeds of various computers, the box may "explode" 
so fast as to be unnoticeable.  This can be controlled by use of a 
DOS environment variable 

SET BOXDELAY=6000

This value is detected if present and used as a delay factor between each 
step of the "explosion" to slow the process down on fast computers.

EXAMPLE:

k_PopBox(10,10,15,70)

Result: All default values except for coordinates.

******************************************************************************/
#include "klipper.ch"

FUNCTION k_PopBox(nTmax,nLMax,nBMax,nRMax,nType,cFill)
LOCAL    BoxDelay := VAL(GETE("BOXDELAY"))
LOCAL    t, l, b, r
LOCAL    i
LOCAL    boxchar, tdone, ldone, bdone, rdone

if nType = NIL
    nType = 1
endif


if cFill = NIL
    cFill = ' '
endif

*******************************************************
* nTmax,nLMax,nBMax,nRMax are the destination points  *
*******************************************************

tdone   = .f.
ldone   = .f.
bdone   = .f.
rdone   = .f.

do case

    case nType = BOXSINGLE
        * single top, single side
        boxchar = [ÚÄ¿³ÙÄÀ³]+cFill

    case nType = BOXDOUBLETOP
        * Double top, single side
        boxchar = [ÕÍ¸³¾ÍÔ³]+cFill

    case nType = BOXDOUBLESIDE
        * single top, double side
        boxchar = [ÖÄ·º½ÄÓº]+cFill

    case nType = BOXDOUBLE
        * double top, double side
        boxchar = [ÉÍ»º¼ÍÈº]+cFill

    case nType = BOXTHICK
        * block
        boxchar = [ÛßÛÞÛÜÛÝ]+cFill

    case nType = BOXNONE
        * none
        boxchar = "         "+cFill


endcase

*******************************************************************
*  start from the center of the destination points and go outward *
*******************************************************************

t=int(nTmax+((nBMax-nTmax)/2))
l=int(nLMax+((nRMax-nLMax)/2))
b=t
r=l

while !(tdone .and. ldone .and. bdone .and. rdone)

    dispbox(t,l,b,r,boxchar)

    if t > nTmax
        t=t-1
    else
        tdone=.t.
    endif

    if l > nLMax
        l=l-2

        if l < nLMax
            l=nLMax
        endif
    else
        ldone=.t.
    endif

    if b < nBMax
        b=b+1
    else
        bdone=.t.
    endif

    if r < nRMax
        r=r+2

        if r > nRMax
            r=nRMax
        endif

    else
        rdone=.t.
    endif

    for i = 1 to BoxDelay
        i++
    next

enddo

dispbox(nTmax,nLMax,nBMax,nRMax,boxchar)

RETURN(NIL)




