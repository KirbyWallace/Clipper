/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_BGraphH(TopRow,TopCol,BotRow,BotCol,Degree_Prcnt,Fore_Char,Back_Char,Fore_
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
Back_Color    : Background Color to Use
Final_Only    : Logical - Print Whole Bar or just Top Character
Use_Zero      : Locgical - Graph Bottom char if Percent 0 < n < 1

SHORT:

Provides a horizontal bargraph based upon "percent."

DESCRIPTION:

k_BGraphH() performs the same thing as k_BGraphV(), but along a
horizontal axis.

NOTE:

See KLIPPER.CH for alternate calling conventions using #xtrans.

EXAMPLE:

#define DEGREE  67

k_Box(1,09,03,71)

@ 04,10 say '100 %'+' (' + ltrim(str(DEGREE)) + '% COMPLETE)'
@ 04,24 say ' 75 %'
@ 14,39 say ' 50 %'
@ 14,54 say ' 25 %'
@ 24,68 say '  0 %'


k_BGraphV(02,10,02,70,DEGREE,'Û','°',,'b/n')

Result: A graph similar to the following is built:

ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛÛ°°°°°°°°°°°°°°°°°°°°°°°³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
0%            25%            50%            75%           100%

Notice that the k_BGraphH() function is responsible only for the
actual bargraph itself.  The box and the labels were drawn manually.

******************************************************************************/

FUNCTION k_BGraphH(TopRow, TopCol, BotRow, BotCol, Degree_Prcnt, Fore_Char, Back_Char, Fore_color, Back_Color, Final_Only, Use_Zero)
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
         Range_color[1] = iif(Fore_Color = NIL,'g/n',Fore_Color)
         Range_color[2] = iif(Fore_Color = NIL,'gr+/n',Fore_Color)
         Range_color[3] = iif(Fore_Color = NIL,'r+/n',Fore_Color)

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

Total_Range = BotCol-TopCol                          // number of blocks available to draw


Bar_Range = round(Degree_Prcnt*(Total_Range/100),0)  // use round() to cause larger low end, int cuts decimal
                                                     // and makes green area shorter and red area come sooner

GYR_Range  = int(Total_Range/3)

setcolor(Back_Color)

for i = 0 to (BotRow-TopRow)
    for j = 0 to (BotCol-TopCol-1) //  5-93
        @ TopRow+i,TopCol+j say Back_Char
    next
next


if int(Bar_Range) > 0


        for i = 0 to (BotRow-TopRow)

            Range_Counter = 1
            Range_ColSel = 1

            for j = 0 to Bar_Range

                if j >= Total_Range // 5-93
                    exit
                endif

                setcolor(Range_color[Range_ColSel])

                if Final_Only

                    if j = Bar_Range
                        @ TopRow+i,TopCol+j say Fore_Char
                    endif

                else

                    @ TopRow+i,TopCol+j say Fore_Char

                endif

                Range_Counter++

                if Range_Counter > GYR_Range
                    Range_ColSel = iif(++Range_ColSel > 3,3,Range_ColSel)
                    Range_Counter = 1
                endif

            next

        next

else
    // there was some residual percentage.  Not much, but not
    // zero either.

    if Use_Zero

        setcolor(Range_color[1])

        for i = 0 to (BotRow-TopRow)
            @ TopRow+i,TopCol say Fore_Char
        next

    endif

endif

setcolor(oldcolor)

RETURN(NIL)

