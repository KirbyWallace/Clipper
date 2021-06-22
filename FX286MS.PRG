/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FX286MS( nMaster_Select, nTopRow, nTopCol ) --> NIL

PARAMETERS:

nMaster_Select : Master Select Number (Optional)
nTopRow        : Top Left Corner Row of Menu Box (Optional)
nTopCol        : Top Left Corner Col of Menu Box (Optional)

SHORT:

Displays and accepts changes to an Epson 286MX/FX print setting box.

DESCRIPTION:

k_FX286MS() operates differently, depending upon the parameters it is passed. 

If a number is passed in the first parameter (Master Select number), the 
number is passed directly on to the printer as an Epson Master Select Print 
Code, with no checking of it's value.  In this case, the second and third 
parameters are not necessary, and are ignored if passed.

Use the Following Table to calculate the number to be used for 
nMaster_Select: 

    Underline     128
    Italic         64
    Double-Width   32
    Double-Strike  16
    Emphasized      8
    Condensed       4
    Proportional    2
    Elite (12 CPI)  1
    Pica  (10 CPI)  0

Simply add together the numbers of the options that you want, and pass the 
result as the nMaster_Select parameter, omitting remaining parameters (the 
box coordinates) and the printer will be set without displaying the 
selection box.

Optionally, you may skip the first parameter and pass only the second and 
third. In this case, a menu is given with the top left corner at the 
specified points.  Selections made from this menu are translated into a valid 
Master Select number and passed to the printer as an Epson Master Select 
Print Code.


The printer will beep once when exiting the menu to inform you that it 
has received the printer setup string.

You can also create an include file to hold the Master Select values:

#define EP_COND     4
#define EP_UNDER  128
#define EP_PICA     0

_FX286(EP_COND)

_FX286(EP_COND+EP_UNDER)

NOTE:

Certain combinations are illegal. Obviously Pica and Elite cannot 
be simultaneously selected.  Not so obvious, Emphasized can only be 
combined with Pica, NOT Elite or Condensed.  Illegal values are 
simply ignored by the printer.

EXAMPLE:

_FX286()          // gives popup and sets printer from options selected

_FX286(144)       // should use value passed and set printer

_FX286(128)       // Set printer to UnderLine

_FX286(EP_UNDER)  // Set printer to UnderLine using your own #define

_FX286(132)       // Set printer to UnderLine Condensed

_FX286(4)         // Set printer to Condensed only

_FX286(0)         // select 10 CPI

******************************************************************************/

#include     "set.ch"
#include     "klipper.ch"

#xtranslate  MS_BIT(<bit>) => iif(substr(ms_byte,(5-(5-<bit>)),1) = '1',chr(7),chr(9))+' '


FUNCTION k_FX286MS(nMaster_Select, nTopRow, nTopCol )
LOCAL    wrap_set    := set(_SET_WRAP)
LOCAL    oldcolor    := setcolor()

LOCAL    ms_byte     := '000000000'
LOCAL    ms_bit

LOCAL    FX_SCR


if nMaster_Select != NIL

    /*******************************************************************************************
                                    specifying ms value

       something has been passed for a master select value.  In this case, anything passed in
       the remaining parameters is ineffect. since they deal with position of a pick window
       and related items.

     *******************************************************************************************/


    k_LPrint(chr(27)+'!'+chr(nMaster_Select))


else

    /*******************************************************************************************
                                    asking for options
     *******************************************************************************************/

    set(_SET_WRAP,.t.)

    if nTopRow = NIL
        nTopRow = 5
    elseif nTopRow < 0 .or. nTopRow > 9
        nTopRow = 5
    end

    if nTopCol = NIL
        nTopCol = 10
    elseif nTopCol < 0 .or. nTopCol > 54
        nTopCol = 10
    endif

    fx_scr = savescreen(nTopRow,nTopCol,nTopRow+16,nTopCol+26)

    setcolor('w+/r')
    k_Box(nTopRow,nTopCol,nTopRow+15,nTopCol+25,BOXDOUBLETOP)

    @ nTopRow+3,nTopCol      say chr(195)
    @ nTopRow+3,nTopCol+25   say chr(180)
    @ nTopRow+3,nTopCol+1    say repl(chr(196),24)
    @ nTopRow+3,nTopCol+21   say chr(194)

    @ nTopRow+13,nTopCol      say chr(195)
    @ nTopRow+13,nTopCol+25   say chr(180)
    @ nTopRow+13,nTopCol+1    say repl(chr(196),24)
    @ nTopRow+13,nTopCol+21   say chr(193)

    setcolor('g+/r')
    @ nTopRow+1,nTopCol+1  say ' Epson FX-286 & FX-286e '

    setcolor('gr+/r')
    @ nTopRow+2,nTopCol+1  say '     Master Select      '

    setcolor('gr+/r')
    @ nTopRow+14,nTopCol+1 say '  Move  ¾ Select     '

    setcolor('w+/b')

    ms_bit = 0

    do while .t.

        @ nTopRow+04,nTopCol+1 prompt ' 1  Underline       ³ '+MS_BIT(1)
        @ nTopRow+05,nTopCol+1 prompt ' 2  Italic          ³ '+MS_BIT(2)
        @ nTopRow+06,nTopCol+1 prompt ' 3  Double Width    ³ '+MS_BIT(3)
        @ nTopRow+07,nTopCol+1 prompt ' 4  Double Strike   ³ '+MS_BIT(4)
        @ nTopRow+08,nTopCol+1 prompt ' 5  Emphasized      ³ '+MS_BIT(5)
        @ nTopRow+09,nTopCol+1 prompt ' 6  Condensed       ³ '+MS_BIT(6)
        @ nTopRow+10,nTopCol+1 prompt ' 7  Proportional    ³ '+MS_BIT(7)
        @ nTopRow+11,nTopCol+1 prompt ' 8  Elite (12 CPI)  ³ '+MS_BIT(8)
        @ nTopRow+12,nTopCol+1 prompt ' 9  Pica  (10 CPI)  ³ '+MS_BIT(9)

        menu to ms_bit

        if ms_bit = 0
            exit
        endif

        ms_byte = stuff(ms_byte,(5-(5-ms_bit)),1,iif(substr(ms_byte,(5-(5-ms_bit)),1) = '1','0','1' ) )

    enddo

    k_LPrint(chr(7))
    k_LPrint(chr(27)+'!'+chr(k_BtoI(val(substr(ms_byte,1,8)))))

endif


set(_SET_WRAP,wrap_set)

setcolor(oldcolor)
restscreen(nTopRow,nTopCol,nTopRow+16,nTopCol+26,fx_scr)

return(NIL)



