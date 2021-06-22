/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SlideBox( cDir, nTmax, nLMax, nBMax, nRMax, nType, cFill, lShadow ) --> NIL

PARAMETERS:

cDir    : Direction of "slide" U/D/L/R
nTMax   : Top Row
nLMax   : Left Column
nBMax   : Bottom Row
nRMax   : Right Column
nType   : Type of Box Characters to use
cFill   : Character to use to fill box (Default SPACE)
lShadow : Logical TRUE  = Draw shadow after box (DEFAULT)
                  FALSE = No Shadow

SHORT:

Displays a "sliding" exploding box from any direction (ala popbox()).

DESCRIPTION:

k_SlideBox() "explodes" a box onto the screen starting at the top, 
bottom, left, or right of the box, (depending upon cDir) stopping at the 
given coordinates.  Optionally, you may specify the box characters.  
Default box is Double Top/Single Side.

NOTE:

Due to the different CPU speeds of various computers, the box may "explode" 
so fast as to be unnoticeable.  This can be controlled by use of a 
DOS environment variable

SET BOXDELAY=6000

Also, since the screen coordinate system is over three times wider than it 
is high, the verticle motion is complete much sooner than the 
horizontal motion.  This may be a desired effect (having the box quickly 
reach verticle limits and then panning horizontally for the remainder).  
If not, you can adjust it by setting a DOS environment variable 
called BOXRATIO.

SET BOXRATIO=3

A setting of 3 will cause the verticle and horizontal motion to end at 
almost the same time. A value greater than 4 will cause the horizontal 
motion to finish first and the remaining time will be spent completing 
the verticle motion.  A value less than four has the opposit effect.

These values are detected if present and used as a delay factor between 
each step of the "explosion" to slow the process down on fast computers, 
and delay the horizontal motion to match the verticle motion.

Do not use fractional numbers (non-integers) for the boxdelay variable.  
Doing so will result in occasional "escapes" of the box from it's 
final coordinates.  It will continue to explode further than desired. 

Be aware of how the Boxratio is affected by the "evenness/oddness" of 
the total range of the final box coordinates and the fact that the 
screen columns are numbered 0-79.

A Box whose coordinates are an even number in terms of total range will have 
a starting center that is one to the left or right of center.  This means 
that one side will finish just slightly sooner than the other.

5,5 to 12,75 = 70 total places to span.
Half of 70 is 35.

In full speed motion, this trait is barely a flicker, and hardly noticeable.  
But on slower machines, it may look odd.

EXAMPLE:

k_SlideBox('D',10,10,15,70)

Result:  A box is drawn, "sliding" DOWN from line 10 to line 15.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_SlideBox(cDir,nTMax,nLMax,nBMax,nRMax,nType,cFill,lShadow)
LOCAL    BoxDelay  := VAL(GETE("BOXDELAY"))
LOCAL    BoxRatio  := VAL(GETE("BOXRATIO"))
LOCAL    t, l, b, r
LOCAL    i, j
LOCAL    boxchar, tdone, ldone, bdone, rdone
LOCAL    cRight, cRight1, cRight2, cBelow
LOCAL    KBOXHIGH
LOCAL    cOldColor := SetColor()


if nType = NIL
    nType = 1
endif


if cFill = NIL
    cFill = ' '
endif

if BoxRatio = 0
    BoxRatio = 3
endif

if lShadow = NIL
    lShadow = TRUE
endif

if type('KBOXHIGH') != 'L'
    KBOXHIGH = FALSE
endif


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

*******************************************************
* nTmax,nLMax,nBMax,nRMax are the destination points  *
*******************************************************


do case


    case cDir == 'C'

        t=int(nTmax+((nBMax-nTmax)/2))
        l=int(nLMax+((nRMax-nLMax)/2))
        b=t
        r=l

    case cDir == 'U' .or. cDir == 'N'

        t=nBMax
        l=nLMax
        b=nBMax
        r=nRMax

    case cDir == 'D' .or. cDir == 'S'

        t=nTMax
        l=nLMax
        b=nTMax
        r=nRMax


    case cDir == 'L' .or. cDir == 'W'

        t=nTMax
        l=nRMax
        b=nBMax
        r=nRMax

    case cDir == 'R' .or. cDir == 'E'

        t=nTMax
        l=nLMax
        b=nBMax
        r=nLMax

    case cDir == 'NE'

        t=nBMax
        l=nLMax
        b=t
        r=l

    case cDir == 'NW'

        t=nBMax
        l=nRMax
        b=t
        r=l

    case cDir == 'SE'

        t=nTMax
        l=nLMax
        b=t
        r=l

    case cDir == 'SW'

        t=nTMax
        l=nRMax
        b=t
        r=l


endcase


tdone   = FALSE
ldone   = FALSE
bdone   = FALSE
rdone   = FALSE

do while .not. (tdone .and. ldone .and. bdone .and. rdone)

    dispbox(t,l,b,r,boxchar)

    if t > nTmax
        t-=1
    else
        tdone=TRUE
    endif

    if l > nLMax+(BoxRatio-1)
        l -= BoxRatio
    else
        ldone=TRUE
    endif

    if b < nBMax
        b+=1
    else
        bdone=TRUE
    endif

    if r < nRMax-(BoxRatio-1)
        r+=BoxRatio
    else
        rdone=TRUE
    endif

    for i = 1 to BoxDelay
        i++
    next

enddo

dispbox(nTmax,nLMax,nBMax,nRMax,boxchar)

set color to n+/n

//j = 0


if KBOXHIGH

    // additional column to the right of standard (default) column.  This gives two columns on the right

    restscreen(nTMax+1,nRMax+2,nBMax+1,nRMax+2, ;
               transform(savescreen(nTMax+1,nRMax+2,nBMax+1,nRMax+2),repl(chr(88)+chr(8),(nBMax-nTMax)*(nRMax-nLMax))))

endif

//right
restscreen(nTMax+1,nRMax+1,nBMax+1,nRMax+1, ;
           transform(savescreen(nTMax+1,nRMax+1,nBMax+1,nRMax+1),repl(chr(88)+chr(8),(nBMax-nTMax)*(nRMax-nLMax))))

// below
restscreen(nBMax+1,nLMax+2,nBMax+1,nRMax+1, ;
           transform(savescreen(nBMax+1,nLMax+2,nBMax+1,nRMax+1),repl(chr(88)+chr(8),(nBMax-nTMax)*(nRMax-nLMax))))


setcolor(cOldColor)

RETURN(NIL)

