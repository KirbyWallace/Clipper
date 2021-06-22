/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_BGraphV(TopRow,TopCol,BotRow,BotCol,Degree_Prcnt,Fore_Char,Back_Char,Fore_
Color,Back_Color,Final_Only,Use_Zero) --> NIL

PARAMETERS:

TopRow        : Top Row (Maximum range) of Bargraph
TopCol        : Top Left Column of Bargraph
BotRow        : Bottom Row (Minimum Range) of Bargraph
BotCol        : Bottom Right Column of Bargraph
Degree_Prcnt  : Percent of Bar to Graph
Fore_Char     : Graph Charcater (what to draw with)
Back_Char     : Background Character (what to draw on)
Fore_color    : ForeGround Color to Use
Back_Color    : background Color to Use
Final_Only    : Log - Print Whole Bar or just Top Character
Use_Zero      : Log - Graph Bottom char if:
                Min_Inc_Characters < Degree_Percent

SHORT:

Provides a verticle BarGraph based upon "percent."

DESCRIPTION:

_BGraphV draw a VERTICLE bargraph with minimum and maximum ranges at
the given coordinates.  It then displays the bargraph "Degree_Prcnt" 
percent of the min/max values.

For instance, if the BarGraph range is from row 4 down to row 13 (ten 
rows) and Degree_Prcnt = 50, then 50% of the bargraph will be filled from 
the bottom Row 13 UP TO Row 9.

The Bargraph will be drawn using character Fore_Char and the remaining 
unused range of the Bargraph will be drawn using Back_Char.


The Fore_Char will be drawn using the color specified in the 
Fore_Color parameter and the back_Char will be drawn using the color 
specified in the Back_Color parameter.

If the percent to be graphed is less than can be displayed in a 
single character of the bargraph, USE_ZERO = .T. will cause the 
bottom-most character to be graphed anyway.

NOTE:

See KLIPPER.CH for alternate calling conventions using #xtrans.

EXAMPLE:

#define DEGREE 67

k_Box(1,22,24,24)

@ 02,25 say '100 %'+' (' + ltrim(str(DEGREE)) + '% COMPLETE)'
@ 08,25 say ' 75 %'
@ 13,25 say ' 50 %'
@ 18,25 say ' 25 %'
@ 23,25 say '  0 %'

k_BGraphV(02,23,23,23,DEGREE,'°','Ä',,'b/n')

Result: A graph similar to the following is built:


ÚÄÄÄ¿
³ Ä ³ 100%    (67% Complete)
³ Ä ³
³ Ä ³
³ Ä ³
³ Ä ³
³ Ä ³
³ Ä ³  75%
³ Ä ³
³ ° ³
³ ° ³
³ ° ³
³ ° ³  50%
³ ° ³
³ ° ³
³ ° ³
³ ° ³
³ ° ³  25%
³ ° ³
³ ° ³
³ ° ³
³ ° ³
³ ° ³   0%
ÀÄÄÄÙ


Notice that the k_BGraphV() function is responsible only for the
actual Bargraph itself.  The box and the labels were drawn manually.

******************************************************************************/

FUNCTION k_BGraphV(TopRow,TopCol,BotRow,BotCol,Degree_Prcnt,Fore_Char,Back_Char,Fore_color,Back_Color,Final_Only,Use_Zero)
LOCAL    i
LOCAL    j
LOCAL    oldcolor := setcolor()
LOCAL    Total_Range
LOCAL    Bar_Range
LOCAL    GYR_Range

LOCAL    Range_Counter
LOCAL    Range_ColSel

MEMVAR   Range_Color

PRIVATE  Range_Color[3] // specifying Fore_Color will override auto coloring by Bar Level Range
         Range_color[1] = iif(Fore_Color = NIL,'g/n',   Fore_Color)
         Range_color[2] = iif(Fore_Color = NIL,'gr+/n', Fore_Color)
         Range_color[3] = iif(Fore_Color = NIL,'r+/n',  Fore_Color)


if Fore_Char = NIL
    Fore_Char = 'Û' // chr(219)
endif

if Back_Char = NIL
    Back_Char = ' ' // chr(32)
endif

// Fore_color checked later when determining character Range color

if Back_Color = NIL
    Back_Color = oldcolor
endif

if Final_Only = NIL
    Final_Only = .f.
endif

if Use_Zero = NIL
    Use_Zero = .f.
endif

// any value greater than 100% defaults to 100% for bar display
if Degree_Prcnt > 100
    Degree_Prcnt = 100
endif

Total_Range = BotRow-TopRow                          // number of blocks available to draw with
                                                     // +2 to cover from and to rows themselves

Bar_Range = round(Degree_Prcnt*(Total_Range/100),0)  // use round() to cause larger low end, int cuts decimal
                                                     // and makes green area shorter and red area come sooner

GYR_Range  = int(Total_Range/3)

Range_Counter = 1
Range_ColSel = 1

if int(Bar_Range) >  0

    for i = 0 to Bar_Range

        setcolor(Range_color[Range_ColSel])

        if Final_Only
            if i = Bar_Range
                @ BotRow-i,TopCol say repl(Fore_Char,BotCol-TopCol+1)
            endif
        else
            @ BotRow-i,TopCol say repl(Fore_Char,BotCol-TopCol+1)
        endif

        Range_Counter++

        if Range_Counter > GYR_Range
            Range_ColSel = iif(++Range_ColSel > 3,3,Range_ColSel)
            Range_Counter = 1
        endif

    next

    setcolor(Back_Color)
    for i = i to Total_Range
        @ BotRow-i,TopCol say repl(Back_Char,BotCol-TopCol+1)

    next

else
    // there was some residual percentage.  Not much, but not
    // zero either.

    if Use_Zero
        setcolor(Range_color[1])
        @ BotRow,TopCol say repl(Fore_Char,BotCol-TopCol+1)
    endif

    setcolor(Back_Color)
    for i = iif(Use_Zero,1,0) to Total_Range
        @ BotRow-i,TopCol say repl(Back_Char,BotCol-TopCol+1)
    next

endif

setcolor(oldcolor)

RETURN(NIL)


