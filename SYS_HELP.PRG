/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

Help() --> NIL

PARAMETERS:

None

SHORT:

General Purpose Context-Sensitive On-Line Help system.

DESCRIPTION:

Help() is a self-contained, data driven, general purpose, help facility.

Field level help is implemented by way of determining the current VAR_NAME = 
readvar().  Field help can therefore be present in the on-line help but will 
not be included in the printed manual (unless you include them by means of a 
chap/sect/para entry).

Field level help appears in the resulting text before any other help text if 
field level help is found in the sys_help file.

OVERVIEW

Make no mistake.  No matter what anyone tells you, on-line, context sensitive 
help requires careful thought and planning. There are no quick-fixes to the 
problem of getting users of your Clipper Application information related to 
the work at hand.  In order to be truely context sensitive, your help system 
must know what the current "context" is.  It must also be able to determine 
what other information is not exactly, but closely related.

In order to fully understand and exploit the Klipper Help() function, you 
need to understand one fundamental concept.  The Klipper Help() Function is a 
paragraph constructor.  On-Line help is composed of individual pieces of 
information on very specific topics related to a theme.  Help texts are built 
by compiling together paragraphs of help text that are pertinent to the 
"theme" in question, into a single help text which is then displayed.

Since the Help() Function is a paragraph constructor, in order to create a 
neat and "flowing" appearance to your help text, you must write individual 
paragraphs in such a manner that they might appear to have come "from" 
anywhere else and be able to lead into anything else that is related.  Almost 
like intentionally writting an open-ended sentence, only in paragraph form.  
For instance, if you have three pieces of information regarding editing 
commands, it would not do to begin each paragraph with "Editing Commands for 
..... are ....." because in the resulting help text, you will end up with: 

Editing Commands for Fields are...
Editing Commands for cursor movement are...
Editing Commands for Quiting and Saving are...

... which is how a three year old speaks.  Three editing command paragraphs 
might better simply begin as if you were already on the topic: 

First Paragraph     : Editing Commands for Fields are ....
Second Paragraph    : To Move the Cursor...
Third Paragraph     : Press ESC to Quit and optionally save...

Which would result in:

Editing Commands for Fields area ....
To Move the Cursor...
Press ESC to Quit and optionally save...

...which flows much smoother.  You will quickly catch on to this after you 
compose a few paragraphs and see what it looks like when the complete help 
text is constructed.  Full examples are given later.

On line help can be provided to any system with minimal modification.  The 
way the On-Line Help Sub-System works is really quite simple.  At any time 
that the user presses F1, the Help() function is called.  It expects to find 
a character variable declared in the calling procedure called Help_Label. 
This variable should contain a Help Key that will be located in the help 
database.  The Help_Label may contain several keys combined together (with 
the "+" symbol) and help topics will be included for each of the individual 
keys.  The Help system includes features such as:

? Context Sensitive Help
? Configurable down to individual field level
? Topical Index
? Zoom to full screen on any text
? Word Search through Help Text
? Print Help Text to Local or Network Printer
? User Entered Notes added along-side System Help

When the user is finished looking at the help text, they can return to their 
application at exactly the point they left it, even if they were in the 
middle of a READ.  The On-Line Help System can pop up even over a data entry 
screen. 

TECHNICAL DETAILS

The On-Line Help Sub-System is data driven from a database called 
SYS_HELP.DBF.  The structure is as follows: 

HELP_LABEL, C, 40
INDEX,      C, 40
PROC_NAME,  C, 10
VAR_NAME,   C, 10
TEXT,       M
USER_TEXT,  M

The fields are defined as follows:

HELP_LABEL:  This field contains the Help_Label to locate when the On-Line 
Help Sub-System is called. 

The Help_Label is a character variable that you create and "drop" into your 
code at various places so that when F1 is pressed, the contents Help_Label 
reflect the help that needs to be generated for the particular subject area.

The contents of this variable control the different ascpects of the help 
system's behaviour.  The contents of this variable may be a single word 
indicating a single help topic to be displayed (ie, "BUDGETSCREENHELP") or 
there may be multiple words indicating several subjects to be gathered.  In 
this case, the words MUST be separated by a PLUS SIGN (ie, "HLP1+HLP2+HLP3").

Recall that this help function is a paragraph constructor.  It compiles help 
from individual help paragraphs that can be combined in all sorts of ways and 
in all sorts of different places, as appropriate.  This makes common 
individual subjects available for reuse throughout the application.

First, if the "HELP_LABEL" variable does not exist, or is not in scope (ie, 
available to the help system function) when the help function is executed, 
then the user will see "No help available for this subject - END OF SYSTEM 
HELP."

The Help_Label variable will change, as your application proceeds.  You can 
include a single Help_Label key, or several to be handled as separate 
"elements" to extract from the help database.  Again, the delimiter for this 
is the plus sign "+".

For instance if, at any particular point in you application your Help_Label 
is "MEUHELP" then when the help function is executed and this string is 
parsed, it will pull help for "MENUHELP" only from the help database.  
However, you may want more than one help text added to the complete help 
text:

    Help_Label = "BUDGET_EDIT+BUDGET_ACCOUNTS+EDIT_COMMANDS"

In this case, the resulting help text will contain three paragraphs, all 
obtained from separate help text fields in the help database.

The Help_Label, in addition to containing multiple help subjects, separated 
by a plus sign, can also contain additional elements that instruct the help 
system to behave differently.

Some systems use a screen design "standard," often dictated in large 
corporations.  If your screens all have a unique identifying mark, you can 
use this mark as your help_label rather than "dropping" help_labels all over 
your code.  In fact, if you know that you can always identify any part of 
your system by some label in a permananet location on the screen, you can 
make a single Help_Label declaration at the top of your program that will 
tell the help system to always get it's Help_Label from there.

If the Help_Label contains a comma "," (*ONE* comma) anywhere in it, it is 
assumed that you want to extract the help_label from some place ON THE SCREEN 
by specifying the SCREEN LINE number and a TOKEN which the help_label 
immediately follows. In this case, the Help_Label variable contains two 
"parameters" separated by a comma.

The first parameter is the line number of the screen on which to look for the 
token specified in the second parameter.  The Help_Label then becomes 
whatever text immediately follows the specified token up to but not including 
the first non-alphanumeric character on the screen.

Say for instance that the screen has, on line 24, the text: 

    "SCREEN_ID: BUDGET1002 - BUDGETS - XYZ Corp"

To use "BUDGET1002" as the help label for this screen, simply set Help_Label 
to contain:

    HELP_LABEL = "24,SCREENID: "

In this case, the COMMA is a delimiter.  It tells the function that, since 
you passed TWO parameters, then the first one is a screen line number, and 
the second is text to locate on that line and extract Help_Label from what 
follows it.  The function will begin reading on line 24, on the first 
character AFTER "SCREENID: " and continue reading until it encounters the 
first non-alphanumeric character (which in this case is a space).  From the 
above example, the Help_Label variable that the help function would build for 
itself would contain "BUDGET1002" and it would then proceed as normal, 
gathering help from the help database for "BUDGET1002."

If Help_Label contains *TWO* commas (THREE parameters), the behaviour is 
similar to the above case of 1 comma (two parameters) and the variable is 
interpreted thusly:

The first parameter is a screen line, the second parameter is a screen 
column, and the third parameter is a number indicating the number of 
characters to read from the screen.  This value is then used as the 
Help_Label:

    Help_Label = "24,65,5"

This indicates that the help_label is to be read from the screen; five 
characters beginning at line 24 and column 65.

INDEX: This field contains the Index Entry for the associated Help_Label.  
This field comprises the Topical Index when it is requested.  The Topical 
Index presents this column of the database in alphabetical order when F1 is 
pressed from within the On-Line Help Sub-System.

PROC_NAME: (unused) This field is reserved for future use. 
VAR_NAME: (unused) This field is reserved for future use. 

TEXT: This is a memo field that contains the help text that is displayed for 
the current Help_Label variable (if it isn't being derived from the screen).

USER_TEXT: This is a memo field that contains the user-entered notes that are 
entered alongside the system defined help when the user presses "F4 - Notes."

Calling Convention, Parameters and Usage Notes

Syntax: (In your application:)

SET KEY nnn TO HELP() or
EXTERNAL HELP

Source Code Examples and Explanations

In brief, when the user presses F1 to activate the On-Line Help, the program 
branches to the Help() function.  At this time, the Help() function scans the 
run-time environment looking for a character variable called "Help_Label".  
If it is found, the contents are used as a lookup into the HELP_LABEL field 
in the SYS_HELP database.  NOTE:  It is important that your Help_Label 
variable be declared either as PRIVATE or PUBLIC.  If you make it a LOCAL, it 
will not be visible to the HELP() function when it is executed. 

If found, the contents of the TEXT memo field are added to a memory variable 
that will be displayed in the Help Window.  The Help_Label variable that is 
currently in scope when the Help System is invoked can contain several 
individual keys concatenated together with "+".  The primary purpose for this 
feature is to allow you to compile a comprehensive help text from several 
components that may be used independently of each other. For instance, if you 
are working on a financial statements reporting program that has a data entry 
screen for "Current Year Budget Dollars", you could define Help_Label keys 
for the following subjects/keys:

CURRENT YEAR BUDGET DOLLARS:       Dollars
FINANCIAL STATEMENTS:              Statements
RECORD NAVIGATION:                 Record_Nav
EDITING COMMANDS:                  Edit_Command


Then, at the point where you are actually entering dollar amounts on the 
Financial Statements data entry screen, you could define your Help_Label as 
"Dollars+Statements+Edit_Commands". When the user presses F1, the On-Line 
Help Sub-System will parse the Help_Label string to look for and compile 
together the help TEXT for "Dollars", "Statements" and "Edit_Commands".  The 
result is a single help text that discusses everything involved in the 
current action.  In addition to this, the "Edit_Commands" text can itself be 
used in all other cases where editing commands are included in the Help_Label 
variable.  Thus, you do not need to write and rewrite the Edit Command help 
in every single place where it might be needed  rather you simply include 
"Edit_Commands" in each Help_Label variable that needs it and it will be 
included in the system generated Help Text. 

A source code example of the Help_Label might be:

*******************************************************
FUNCTION Display_Budget()
LOCAL    Select_Edit
PRIVATE  Help_Label := 'Budget'

// issue @ SAY's - display data entry screen for browse only

if Select_Edit = TRUE
    Edit_Budget()
endif

RETURN(NIL)
*******************************************************

FUNCTION Edit_Budget()
PRIVATE  Help_Label := 'Budget+Edit_Commands'

// issue @ say/gets

READ

RETURN(NIL)
*******************************************************

If the user presses F1 while in Display_Budget(), the current Help_Label is, 
"Budget".  The help system looks through it's SYS_HELP.DBF file and adds the 
text from the TEXT field to a memory variable that will be displayed in the 
Help Window. 

However, if the user has selected Select_Edit and the program branches to 
"Edit_Budget()", the new PRIVATE Help_Label becomes the Help_Label currently 
in scope.  It's contents include "Budget", and also "Edit_Commands".  The 
On-Line Help Sub-System again scans it's database file and adds the help text 
from the TEXT memo field to it's display memory variable and also adds the 
help text for "Editing Commands" to the same display memory variable.  The 
end result is a single help text that includes help on budget matters and 
also help on editing commands. 

The flexibility becomes evident when you consider that you may have an half 
dozen different editing screens that need on-line help that all include help 
on Edit Commands.  But, you do not want to duplicate the edit command help 
text in each of the screens.  Instead, you could define Help_Label variables 
that have:


Budget+Edit_Commands
Forecast+Edit_Commands
Consolidate+Edit_Commands
Report_Parameters+Edit_Commands
Financials+Edit_Commands

and in each case, the different help texts will be added to the Editing 
Commands help to provide comprehensive, context-sensitive and detailed help.  
Even though the Edit Commands help text has only been written once, it is 
used in many different places. 

It is possible to add help incrementally as the program goes into greater 
depth to give a comprehensive help text detailing everything that has 
happened up to the current point:

Help_Label := 'Menu+Edit_Option+Budget+Edit_Commands'

This example would begin by compiling the TEXT memo field for "Menu" and 
continue to add help for "Edit_Option", then for "Budget", and finally 
"Edit_Commands", and all four paragraphs will be compiled together and 
presented in the Help Window as a single help text.

This is precisely how the F2 - Search function works.  It takes the 
Help_Label as it currently exists, prompts the user for a word or phrase to 
locate, scans all the help TEXT and adds paragraphs to the existing help text 
and displays it altogether in the Help Window.

The INDEX field is used as a list of topics that are displayed when the users 
presses F1 again while in the On-Line Help Sub-System.  This produces a 
Topical Pick-List of subjects that are defined in the Help Database.  Once 
the list is displayed, the user may pan up and down by using the up and down 
arrow keys or the PgUp / PgDn keys.  Once they press ENTER on a subject, the 
text of that subject is displayed. 

User Defined Help

Users may also add their own help text to the On-Line Help Sub-System, and 
have it along with, but maintained separately from the system defined help.  
When the user has pressed F1 to call the On-Line Help, while viewing the 
help, they may add their own notes by pressing F4.  The system then gives 
them an edit window into which they may add whatever free-form text they 
wish. It will always appear here in the same place whenever they press F4.

Help File Path

The location of the SYS_HELP.DBF is assumed to be the current directory.  
This location can be changed by placing the SYS_HELP.DBF and SYS_HELP.DBT 
files in any other directory and then naming that directory in a DOS 
environment variable called "HELPPATH".  When Help() is invoked, the DOS 
environment space is analysed to see if it contains this variable and if it 
does it is evaluated to see if it contains any value.  If it exists and 
contains a value (namely a directory path), this path is where Help() will 
expect to find the help files. 

This is useful in a network environment where there may be multiple users of 
the apllication and you want to ensure that no one user changes or deletes 
the SYS_HELP.DBF.  It can be placed in a directory where that user has no 
DELETE rights without interfering with their FULL RIGHTS to the work 
directory.

NOTE:

NOTE that Help() is the ONLY Klipper Library function that is not prefixed 
with an underscore!  This makes it available simply by specifying it in the 
link script because Clipper automatically assigns the F1 key to call a 
function named HELP() if it exists.

Undoubtedly, a common problem will be setting a HELPPATH to one directory for 
one application and then forgetting to set it to another or to NIL when a 
different application is loaded.  This can cause two problems.  First, the 
user will be presented with help text from a completely foreign application 
and second, when they press F1 to get that help, the unknown help key will be 
added to the wrong help database.  Therefore, be careful that you correctly 
set the HELPPATH variable for each application and reset or remove it as 
necessary.

The HELPPATH variable can be removed by typing:

SET HELPPATH=

at any DOS prompt, or, preferably, in the batch file that calls your 
application. 

A good setup batch file might look like:

SET HELPPATH=G:\THISAPP\HELPFILE
THISAPP.EXE
SET HELPPATH=

Key Summary

F1: Initiates the On-Line Help Sub-System.  Once Active:

F1: Topical Index
F2: Search for Text in Help Descriptions (HELP_TEXT)
F3: Full Screen Zoom Toggle
F4: User Notes - View/Edit
F5: Print Help Text to Printer
ESC: UnZoom if zoomed (or press F3), or Exit On-Line Help.

EDITING HELP "ON-THE-FLY"
-------------------------

Help Texts can be edited "on-the-fly" by creating a LOGICAL variable called 
__HELPEDIT (it's actual value is not important; it may be either true or 
false) that is IN SCOPE when the Help() function is invoked.

When the Help() system is invoked, BEFORE the help texts are compiled, an 
edit window for each paragraph of help text is presented (with the specific 
help_label at the bottom of the window indicating which help text you are 
editing).  After you have edited each help text paragraph, the system 
compiles them together as it normally would and presents them just as the end 
user will see it.

__HELPEDIT should be removed from PRODUCTION applications!!!

EXAMPLE:



******************************************************************************/
/*

    To Do:

    OPTIONS: OPTION: Zoom upon Help Startup TRUE/FALSE
             Margins (#chars between border and text)
             Color Selections: during development can set by
             changing them on-line.  They stay that way until
             changed again.

             Import Text File into Memo Field.
             Link Text File (Text File must then be present at
               runtime)



*/

STATIC CallCount := 0

/*************************************************************************

    Function:    Help()
    Description: MAIN MODULE OF HELP SYSTEM

*************************************************************************/

FUNCTION Help()

#include "inkey.ch"
#include "memoedit.ch"
#include "setcurs.ch"
#include "set.ch"
#include "klipper.ch"
#include "kfile.ch"

#define  FIRST_COMMA  k_NthOccr(M->Help_Label,',',1)
#define  SECOND_COMMA k_NthOccr(M->Help_Label,',',2)


FIELD    INDEX, HELP_LABEL, PROC_NAME, VAR_NAME, TEXT, USER_TEXT

LOCAL    Help_Key   := ''
LOCAL    WinTRow    := 8,  WinTCol := 15,  WinBRow := 17,  WinBCol := 65
LOCAL    Old_Cursor := set(_SET_CURSOR,SC_NONE)
LOCAL    Old_Area   := select()
LOCAL    Prn_On     := set(_SET_PRINTER)  // help cannot pop up over a report that is printing - disastrous things will happen!

LOCAL    Help_Line
LOCAL    Help_Tag
LOCAL    Temp_Scr_Line
LOCAL    Temp_Key
LOCAL    Help_Col
LOCAL    Help_Chars
LOCAL    __cHelpPath := trim(gete("HELPPATH"))


LOCAL    i

MEMVAR   cHelp_Text
MEMVAR   cUser_Text
MEMVAR   cCreateName
MEMVAR   nUser_Txt_Rec
MEMVAR   cSwap_Screen

MEMVAR   HelpTRow
MEMVAR   HelpTCol
MEMVAR   HelpBRow
MEMVAR   HelpBCol
MEMVAR   Help_Screen

PRIVATE  Help_Screen

PRIVATE  cHelp_Text    := ''  // these applicable and used by
PRIVATE  cUser_Text    := ''  // almost all the functions in the
PRIVATE  cCreateName   := ''  // Help! system
PRIVATE  nUser_Txt_Rec := 0   //
PRIVATE  cSwap_Screen  := SaveScreen(0,0,MaxRow(),MaxCol())


if !empty(__cHelpPath)
    if right(__cHelpPath,1) != '\'
        __cHelpPath += '\'
    endif
endif

SET KEY 28 to                // disable help key, we're already here!

SETBLINK(FALSE)                // Redirect Blink Attribute to High Intensity

if !Prn_On

    // these can be set in your application if you wish to override these defaults

    if type('HelpTRow') = 'N' .and. type('HelpTCol') = 'N' .and. ;
       type('HelpBRow') = 'N' .and. type('HelpBCol') = 'N'


        if helptrow >= 0 .and. helptrow <= 22
            WinTRow = HelpTRow
        endif

        if HelpTCol >= 0 .and. HelpTCol <= 78
            WinTCol = HelpTCol
        endif

        if HelpBRow >= HelpTrow .and. HelpBRow <= 22
            WinBRow = HelpBRow
        endif

        if HelpBCol >= HelpTCol .and. HelpBCol <= 78
            WinBCol = HelpBCol
        endif

    endif

    // check help file.  if not present on first call to help, create empty

    if !file(__cHelpPath+'SYS_HELP.DBF')

        cCreateName = __cHelpPath+'SYS_HELP.DBF'

        FILE_BEGIN &cCreateName


            FLD CHAPTER,    C, 10     // for ordering during printout
            FLD SECTION,    C, 10     //
            FLD PARAGRAPH,  C, 10     //

            FLD INDEX,      C, 40
            FLD HELP_LABEL, C, 40

            FLD VAR_NAME,   C, 25     // used for field level help

            FLD TEXT,       M         // help text and user notes
            FLD USER_TEXT,  M
            FLD USERSCREEN, M         // captured by key in UDFUser_Notes

        FILE_END &cCreateName

    endif

    // check indexes. to rebuild, delete them.

    // SYS_HLP1.NTX is for lookups on Help_Label, SYS_HLP2 is for
    // lookups of field level help on VAR_NAME

    if !file(__cHelpPath+'sys_hlp1.tif')

        SELECT 0

        USE (__cHelpPath+'SYS_HELP') EXCLUSIVE
        INDEX ON Help_Label TO (__cHelpPath+'SYS_HLP1.TIF')

        CLOSEAREA

    endif


    if !file(__cHelpPath+'sys_hlp2.tif')

        SELECT 0

        USE (__cHelpPath+'SYS_HELP') EXCLUSIVE
        INDEX ON Var_Name TO (__cHelpPath+'SYS_HLP2.TIF')

        CLOSEAREA

    endif

    if type('M->Help_Label') = 'C'


        // discern which method of extracting the help key.  There are three:
        //
        // 1 - Pass it as the one and only text parameter
        //
        // 2 - Pass a screen line number and a label to use in locating the key
        //     on a specific line of the screen following the label you passed.
        //
        // 3 - Pass a screen line number and start / length coordinates that
        //     explicitly define a region of the screen to read to derive the
        //     help key.

        do case

            case k_ChCount(',',M->Help_Label) = 0
                // one param, passed variable to use as help_label
                // get help label from PRIVATE Help_Label

                Help_Key = M->Help_Label

            case k_ChCount(',',M->Help_Label) = 1
                // two params passed, line number and label
                // get help label from line and label.  Find label, read all
                // characters after label until first non alphanum char
                // use this as Help_Label

                Help_Line = val(k_Snatch(M->Help_Label,1,FIRST_COMMA-1))
                Help_Tag =  k_Snatch(M->Help_Label,FIRST_COMMA+1,len(M->Help_Label) )
                Temp_Scr_Line = savescreen(Help_Line,1,Help_Line,MaxCol())
                Temp_Key = ''

                for i = 1 to len(Temp_Scr_Line) STEP 2

                    Temp_Key += substr(Temp_Scr_Line,i,1)

                next

                if at(Help_Tag,Temp_Key) > 0

                    for i = at(Help_Tag,Temp_Key)+len(Help_Tag) to len(Temp_Key)

                        if isalpha(substr(Temp_Key,i,1)) .or. isdigit(substr(Temp_Key,i,1))

                            Help_Key += substr(Temp_Key,i,1)

                        else

                            exit

                        endif

                    next

                endif

            case k_ChCount(',',M->Help_Label) = 2
                // three params passed, screen coords to cut help label from
                // get help label from screen at these coords.

                Help_Line  = Val(k_Snatch(M->Help_Label,1,FIRST_COMMA-1))
                Help_Col   = Val(k_Snatch(M->Help_Label,FIRST_COMMA+1,SECOND_COMMA-1))
                Help_Chars = Val(k_Snatch(M->Help_Label,SECOND_COMMA+1,len(M->Help_Label)))

                Temp_Key = SaveScreen(Help_Line,Help_Col,Help_Line,Help_Col+Help_Chars)

                for i = 1 to len(Temp_Key) STEP 2
                    Help_Key += substr(Temp_Key,i,1)
                next

        endcase

        // Look through the call stack for keywords to automatically add READMODAL

        for i = 0 to 25
            if procname(i) = 'READMODAL'
                Help_Key+='+READMODAL'
                EXIT
            endif
        next


        Help_Screen = SaveScreen(0,0,MaxRow(),MaxCol())

        if !empty(cHelp_Text := Help_Find(Help_Key))

            k_KeyList('³F1 - Index³F2 - Search³F3 - Zoom³F4 - Notes³F5 - Print³ PgUp PgDn³ESC - Quit³','gr+*/n')
            Help_Box(WinTRow,WinTCol,WinBRow,WinBCol)
            Help_Text(WinTRow,WinTCol,WinBRow,WinBCol,cHelp_Text)

        endif

        RestScreen(0,0,MaxRow(),MaxCol(),Help_Screen)

    endif (help_label = c)

endif prn_on

SETBLINK(TRUE)

SET(_SET_CURSOR,Old_Cursor)

SET KEY 28 TO Help()  // restore help key so we can come back again.

if Old_Area != 0
    Select (Old_Area)
endif

RETURN(NIL)


/*************************************************************************

    Function: Help_Find()

*************************************************************************/

FUNCTION Help_Find(cHelp_Label)

MEMVAR   cUser_Text
MEMVAR   nUser_Txt_Rec

LOCAL    cHelp_Found := FALSE
LOCAL    cHelp_Text  := ''
LOCAL    Old_Area    := SELECT()
LOCAL    Old_Color   := SetColor()
LOCAL    Old_Exact   := set(_SET_EXACT,TRUE)
LOCAL    Num_Keys    := k_ChCount('+',cHelp_Label)+1
LOCAL    i
LOCAL    __cHelpPath := trim(gete("HELPPATH"))
LOCAL    cEditScreen := SaveScreen(5,5,MaxRow()-3,MaxCol()-3)

if !empty(__cHelpPath)
    if right(__cHelpPath,1) != '\'
        __cHelpPath += '\'
    endif
endif

SELECT 0

USE (__cHelpPath+'Sys_Help') ALIAS HelpFile SHARED
SET INDEX TO (__cHelpPath+'SYS_HLP2.TIF')


/****************************************
   get help texts for memory variable
*****************************************/

// do not edit field level help when help index is called
// it will come up with the regular help-edit.


if ( !empty(readvar()) .and. (procname(1) != "HELP_INDEX") )

    SEEK lower(substr(readvar()+space(10),1,10))

    if !found()
        APPEND BLANK
        REPLACE HelpFile->Var_Name WITH lower(readvar())
    endif

    if type('__HELPEDIT') == 'L'

        // if __HELPEDIT is in scope, allow edit of help text now
        // Remove __HELPEDIT from production applications!

        k_KeyList('³ INS - XXX ³ Ctrl-B Reformat ³ ALT-I - Index Label ³ F10 - Save ³ ESC - Quit ³','gr+*/n')

        SetColor('w+*/n')

        k_Box(5,5,MaxRow()-5,MaxCol()-5,BOXTHICK,1,'FIELD: '+lower(readvar())+' ³ Index: '+alltrim(HelpFile->Index) )

        if k_RLock()

            // this memoedit reuses the existing User_notes editing UDF
            REPLACE HelpFile->Text WITH memoedit(HelpFile->Text,6,6,MaxRow()-6,MaxCol()-6,TRUE, 'UDFUser_Notes' )

            set(_SET_CURSOR,SC_NONE) // turn off cursor after edit

        endif

        RestScreen(5,5,MaxRow()-3,MaxCol()-3,cEditScreen)
        SetColor(Old_Color)

    endif

    if !empty(HelpFile->Text)
        cHelp_Text += HelpFile->Text+LF+LF
    endif

endif

/********************************************
    get help texts for keys in Help_Label
*********************************************/

SET INDEX TO (__cHelpPath+'SYS_HLP1.TIF')

for i = 1 to Num_Keys

    SEEK alltrim(lower(k_Extract(cHelp_Label,'+',i)))

    cHelp_Found = found()

    if !cHelp_Found
        APPEND BLANK
        REPLACE HelpFile->Help_Label WITH alltrim(lower(k_Extract(cHelp_Label,'+',i)))
    endif

    if type('__HELPEDIT') == 'L'

        k_KeyList('³ INS - XXX ³ Ctrl-B Reformat ³ ALT-I - Index Label ³ F10 - Save ³ ESC - Quit ³','gr+*/n')

        SetColor('w+*/n')

        k_Box(5,5,MaxRow()-5,MaxCol()-5,BOXTHICK,1,'LABEL: '+trim(k_Extract(cHelp_Label,'+',i))+' ³ Index: '+alltrim(HelpFile->Index))

        if k_RLock()

            REPLACE HelpFile->Text WITH memoedit(HelpFile->Text,6,6,MaxRow()-6,MaxCol()-6,TRUE, 'UDFUser_Notes' )

            set(_SET_CURSOR,SC_NONE) // turn off cursor after edit

        endif

        RestScreen(5,5,MaxRow()-3,MaxCol()-3,cEditScreen)
        SetColor(Old_Color)

    endif

    if !empty(HelpFile->Text)

        cHelp_Text += HelpFile->Text+LF+LF

    endif

    if i = 1

        cUser_Text = HelpFile->User_Text
        nUser_Txt_Rec = Recno()

    endif

next


if empty(cHelp_Text)
    cHelp_Text = 'No help available on this subject'
endif

CLOSEAREA

if Old_Area != 0
    Select (Old_Area)
endif

set(_SET_EXACT,Old_Exact)

RETURN(cHelp_Text)


/*************************************************************************

    Function: Help_Text()

*************************************************************************/

FUNCTION Help_Text(nTopRow,nTopCol,nBotRow,nBotCol,cEditVar,cUDFZoomMode)

MEMVAR cHelp_Text

LOCAL Old_Color := iif(CallCount = 0,SetColor('w+*/n'),SetColor('w+*/b'))

If CallCount != 0 // offset the box a bit on index lookups
    nTopRow -= 2 ; nTopCol -= 2 ; nBotRow -= 2 ; nBotCol -= 2
endif

cUDFZoomMode = iif(cUDFZoomMode == NIL,'UDFHelp','UDFHelpZoom')


// if Help_Text() is called by the Index function, then the default
// is a full screen disply, zoom-shrink, usernotes, etc are out.
// only keys allowed here are F2 to search, and F5 to print

if procname(1) = 'HELP_INDEX'
    cUDFZoomMode = 'UDFIndex'
endif

nTopRow++ ; nTopCol += 2 ; nBotRow-- ; nBotCol--

while TRUE


    cEditVar = cHelp_Text

    memoedit('HELP! Version 1.0'+LF+repl(chr(196),17)+LF+LF+cEditVar+LF+LF+'END OF SYSTEM HELP'+LF,;
              nTopRow,nTopCol,nBotRow,nBotCol,FALSE,cUDFZoomMode)

    if LastKey() = K_ESC
        exit
    endif

end

SetColor(Old_Color)

RETURN(NIL)

/******************************

    Function: UDFHelp()

******************************/
FUNCTION UDFHelp(UDFMode, UDFRow, UDFCol)
LOCAL UDFRet_Val := 0
LOCAL UDFKey := lastkey()
LOCAL UDFZoom_Scr

MEMVAR cHelp_Text

do case

    case UDFMode = ME_IDLE

    case UDFMode = ME_UNKEY

        do case

            case UDFKey = K_F1
                Help_Index()

            case UDFKey = K_F2
                if Help_Search() > 0
                    UDFRet_Val = K_CTRL_W
                endif

            case UDFKey = K_F3
                SAVE SCREEN TO UDFZoom_Scr

                k_KeyList('³ F1 - Index³ F2 - Search³ F3 - Shrink³ F4 - Notes³ F5 - Print³  PgUp PgDn ³','gr+*/n')
                Help_Box(2,2,MaxRow()-3,MaxCol()-4)
                Help_Text(2,2,MaxRow()-3,MaxCol()-4,cHelp_Text,'ZOOM')

                RESTORE SCREEN FROM UDFZoom_Scr

            case UDFKey = K_F4
                // notes
                Edit_Notes()

            case UDFKey = K_F5
                // print
                Print_Help(cHelp_Text)

        end


end

RETURN(UDFRet_Val)


/******************************

    Function: UDFHelpZoom()




******************************/
FUNCTION UDFHelpZoom(UDFMode, UDFRow, UDFCol)
LOCAL UDFRet_Val := 0
LOCAL UDFKey := lastkey()

MEMVAR cHelp_Text

do case

    case UDFMode = ME_IDLE

    case UDFMode = ME_UNKEY .or. UDFMode = ME_UNKEYX

        do case

            case UDFKey = K_F1
                Help_Index()

            case UDFKey = K_F2
                if Help_Search() > 0
                    UDFRet_Val = K_CTRL_W
                endif

            case UDFKey = K_F3

                KEYBOARD chr(27)

            case UDFKey = K_F4
                // notes
                Edit_Notes()

            case UDFKey = K_F5
                // print
                Print_Help(cHelp_Text)


        end

end

RETURN(UDFRet_Val)

/*************************************************************************

    Function: Help_Box




*************************************************************************/

FUNCTION Help_Box(nTopRow, nTopCol, nBotRow, nBotCol)

LOCAL Old_Color := iif(CallCount = 0,SetColor('w+*/n'),SetColor('w+*/b'))

If CallCount != 0 // offset the box a bit
    nTopRow -= 2 ; nTopCol -= 2 ; nBotRow -= 2 ; nBotCol -= 2
endif

k_Box(nTopRow, nTopCol, nBotRow, nBotCol, 5)

SetColor(Old_Color)

RETURN(NIL)

/*************************************************************************

    Function: Help_KeyList()




*************************************************************************/
FUNCTION Help_KeyList(cHelpKeyText)
LOCAL Old_Color := SetColor('gr+*/n')

k_Clr(MaxRow())
@ MaxRow(),00 say cHelpKeyText
SetColor(Old_Color)

RETURN(NIL)


/*************************************************************************

    Function: Help_Index()




*************************************************************************/

FUNCTION Help_Index()

MEMVAR Index_Array
MEMVAR cHelp_Text

LOCAL Old_Color   := SetColor('w+*/b')
LOCAL Old_Screen  := SaveScreen(0,0,MaxRow(),MaxCol())
LOCAL Old_Area    := Select()
LOCAL cHelp_Label := ''
LOCAL Help_Screen
LOCAL Index_Num
LOCAL i
LOCAL nIndexCount := 0
LOCAL __cHelpPath := trim(gete("HELPPATH"))

PRIVATE Index_Array
PRIVATE cHelp_Text  := ''

BEGIN SEQUENCE

CallCount++

if CallCount > 1
    k_Ack('The index is already open - Press ESC to access it!',,5)
    BREAK
endif


if !empty(__cHelpPath)
    if right(__cHelpPath,1) != '\'
        __cHelpPath += '\'
    endif
endif

SELECT 0

USE (__cHelpPath+'Sys_Help') ALIAS HelpFile SHARED
SET INDEX TO (__cHelpPath+'SYS_HLP1.TIF')

GOTO TOP

while !eof()

    if !empty(HelpFile->Help_Label)
        nIndexCount++
    endif

    SKIP
end

PRIVATE Index_Array[nIndexCount]

nIndexCount = 1

GOTO TOP

while !eof()

    if !empty(HelpFile->Help_Label)
        Index_Array[nIndexCount] = substr(HelpFile->Index+space(40),1,40)+HelpFile->Help_Label
        nIndexCount++

    endif

    SKIP

end

Asort(Index_Array)

USE

while TRUE

    k_KeyList('³ Index:   PgUp PgDn ³ ¾ - View ³ ESCape - Quit  ³','gr+*/n')
    Index_Box(4,5,MaxRow()-4,45)

    Index_Num := Achoice(6,7,MaxRow()-6,43,Index_Array)

    if Index_Num != 0

        cHelp_Label = Substr(Index_Array[Index_Num],41)

        if !empty(cHelp_Text := Help_Find(cHelp_Label))

            Help_Screen = SaveScreen(0,0,MaxRow(),MaxCol())

            k_KeyList('³ F2 - Search ³ F5 - Print ³ TEXT:   PgUp PgDn ³ ESC - Exit','gr+*/n')

            Help_Box(2,2,MaxRow()-4,MaxCol()-6)
            Help_Text(2,2,MaxRow()-5,MaxCol()-7,cHelp_Text)

            RestScreen(0,0,MaxRow(),MaxCol(),Help_Screen)

        endif

    else
        exit
    endif

end

END SEQUENCE

SetColor(Old_Color)

RestScreen(0,0,MaxRow(),MaxCol(),Old_Screen)

if Old_Area != 0
    select (Old_Area)
endif

CallCount--

RETURN(NIL)


/*************************************************************************

    Function: Index_Box()




*************************************************************************/

FUNCTION Index_Box(nTopRow, nTopCol, nBotRow, nBotCol)
LOCAL Old_Color := SetColor("w+*/b")

k_Box(nTopRow, nTopCol, nBotRow, nBotCol,5)

SetColor('gr+/b')
@ nTopRow+1, nTopCol+2 CLEAR TO nTopRow+1, nBotCol-2
@ nTopRow+1, nTopCol+6 say 'Help! Topical Index'

@ nBotRow-1, nTopCol+2 CLEAR TO nBotRow-1, nBotCol-2
@ nBotRow-1, nTopCol+4 say 'Select from List and Press ¾'

SetColor(Old_Color)

RETURN(NIL)

/******************************

    Function: UDFIndex()




******************************/
FUNCTION UDFIndex(UDFMode, UDFRow, UDFCol)
LOCAL UDFRet_Val := 0
LOCAL UDFKey := lastkey()
LOCAL UDFZoom_Scr

MEMVAR cHelp_Text

do case

    case UDFMode = ME_UNKEY

        do case

            case UDFKey = K_F2
                if Help_Search() > 0
                    UDFRet_Val = K_CTRL_W
                endif

            case UDFKey = K_F5
                // print
                Print_Help(cHelp_Text)

        end

end

RETURN(UDFRet_Val)

/*************************************************************************

    Function: Help_Search()




*************************************************************************/
FUNCTION Help_Search()


MEMVAR cHelp_Text

LOCAL Search_Str  := k_GetStr('Enter Search Text: ')
LOCAL nTextsAdded := 0
LOCAL FirstFind   := TRUE
LOCAL Old_Area    := Select()
LOCAL i
LOCAL __cHelpPath := trim(gete("HELPPATH"))

if !empty(__cHelpPath)
    if right(__cHelpPath,1) != '\'
        __cHelpPath += '\'
    endif
endif

SELECT 0

USE (__cHelpPath+'Sys_Help') ALIAS HelpFile SHARED


GOTO TOP

for i = 1 to Reccount()

    if inkey() = K_ESC
        exit
    endif

    if Search_Str $ HelpFile->text

        if FirstFind
            cHelp_Text += LF+LF+'*** USER SEARCH DATA: '+Search_Str
            FirstFind = FALSE
        endif

        cHelp_Text += LF+LF+HelpFile->Text
        nTextsAdded++
    endif

    SKIP

next

USE


if old_area != 0
    select (Old_Area)
endif

k_Ack(ltrim(str(nTextsAdded))+' Texts Added to Help Screen',,5)

RETURN(nTextsAdded)


/*************************************************************************

    Function: Edit_Notes()




*************************************************************************/
FUNCTION Edit_Notes()


MEMVAR cUser_Text
MEMVAR nUser_Txt_Rec

LOCAL Old_Color  := SetColor('w+*/b')
LOCAL Old_Area   := Select()
LOCAL Old_Cursor := set(_SET_CURSOR,SC_NORMAL)
LOCAL User_Note_Scr


LOCAL cEditVar  := ''
LOCAL __cHelpPath := trim(gete("HELPPATH"))

User_Note_Scr = SaveScreen(0,0,MaxRow(),MaxCol())

k_Box(8,10,20,70,5)

k_KeyList('³User Notes³ F5 - Print ³ F10 - Save ³ INS - XXX ³ESC - Quit, No Save ³','gr+*/n')

cUser_Text := cEditVar := memoedit(cUser_Text,9,11,19,69,TRUE,'UDFUser_Notes')

if lastkey() != K_ESC


    if !empty(__cHelpPath)
        if right(__cHelpPath,1) != '\'
            __cHelpPath += '\'
        endif
    endif

    SELECT 0

    USE (__cHelpPath+'Sys_Help') ALIAS HelpFile SHARED

    Goto nUser_Txt_Rec

    if !k_RLock()

        if k_QConfirm('Cannot Save. Other users viewing Help! Retry?')

            while !k_RLock()

                if inkey() = K_ESC
                    exit
                endif
            end

            if k_RLock()
                Replace User_Text with cEditVar
            endif

        endif

    else
        Replace User_Text with cEditVar
    endif

    USE

    if Old_Area != 0
        Select (Old_Area)
    endif

endif

RestScreen(0,0,MaxRow(),MaxCol(),User_Note_Scr)

SetColor(Old_Color)
Set(_SET_CURSOR,Old_Cursor)

RETURN(NIL)

/***********************************

    Function: UDFUser_Notes()




***********************************/

FUNCTION UDFUser_Notes(UDFMode, UDFRow, UDFCol)
LOCAL    UDFRet_Val   := ME_DEFAULT
LOCAL    UDFKey       := lastkey()
LOCAL    cOldColor    := SetColor()
LOCAL    cTemp        := ''
LOCAL    cScreenText  := ''
LOCAL    nCursorSet
LOCAL    i

MEMVAR   cHelp_Text
MEMVAR   cUser_Text
MEMVAR   cSwap_Screen
MEMVAR   Help_Screen

do case

    case UDFMode = ME_INIT

        ReadInsert(TRUE)

    case UDFMode = ME_IDLE

        SetColor('gr+*/n')

        if procname(2) = 'HELP_FIND'
            @ MaxRow(),08 say iif(readinsert(),'ON ','OFF')
        else
            // Edit_Notes() is calling - it's INS position is different
            @ MaxRow(),45 say iif(readinsert(),'ON ','OFF')
        endif

        set(_SET_CURSOR, iif(readinsert() ,SC_BLOCK,SC_NORMAL) )

        SetColor(cOldColor)


    case UDFMode = ME_UNKEY .or. UDFMode = ME_UNKEYX

        if UDFMode = ME_UNKEYX .and. UDFKey = K_ESC

            if k_QConfirm('Save Changes')
                UDFRet_Val = K_CTRL_W
            else
                if lastkey() = K_ESC
                    UDFRet_Val = ME_IGNORE
                else
                    UDFRet_Val = K_ESC
                endif
            endif

        else

            do case

                case UDFKey = K_ALT_W
                    UDFRet_Val = K_CTRL_W

                case UDFKey = K_ALT_X
                    UDFRet_Val = K_CTRL_W

                case UDFKey = K_ALT_Q
                    UDFRet_Val = K_CTRL_W

                case UDFKey = K_ALT_S
                    UDFRet_Val = K_CTRL_W

                case UDFKey = K_F10
                    UDFRet_Val = K_CTRL_W

                case UDFKey = K_ALT_I
                    // Add Index entry

                    __AddIndexLabel()

                case UDFKey = K_INS

                    if UDFCol > 0
                        KEYBOARD chr(K_LEFT)+chr(K_RIGHT)
                    else
                        KEYBOARD chr(K_RIGHT)+chr(K_LEFT)
                    endif

                case UDFKey = K_ALT_H

                     // pop up original screen and wait for keypress
                     // then return to help screen

                     nCursorSet = Set(_SET_CURSOR,SC_NONE)

                     cSwap_Screen = SaveScreen(0,0,MaxRow(),MaxCol())

                     RestScreen(0,0,MaxRow(),MaxCol(),Help_Screen)

                     inkey(0)

                     RestScreen(0,0,MaxRow(),MaxCol(),cSwap_Screen)

                     set(_SET_CURSOR,nCursorSet)


                case UDFKey = K_ALT_P

                    // ADD user screen to HELPFILE->USERSCREEN

                    tone(1000,.5)

                    if procname(2) = 'HELP_FIND'

                        for i = 1 to len(Help_Screen) step 2

                            cTemp += substr(Help_Screen,i,1)

                        next

                        for i = 1 to len(cTemp)

                            cScreenText += substr(cTemp,i,1)

                            if i % 80 = 0
                                cScreenText += LF
                            endif

                        next

                        cScreenText += LF

                        if k_RLock()
                            REPLACE HelpFile->UserScreen WITH HelpFile->UserScreen+cScreenText
                        else
                            k_Ack("Cannot Save Screen - RLock Failed")
                        endif

                    else
                        tone(2000,.5)
                    endif


                case UDFKey = K_F5

                    Print_Help(cUser_Text)

            end

        endif

end


RETURN(UDFRet_Val)


/*************************************************************************

    Function: Print_Help()




*************************************************************************/
FUNCTION Print_Help(cPrint_Var)
LOCAL Num_Lines := mlcount(cPrint_Var,72)
LOCAL i

if isprinter()

    set print on
    set device to print
    set cons off

    for i = 1 to Num_Lines
        ? memoline(cPrint_Var,72,i)
    next

    set print off
    set device to screen
    set cons on

else
    k_Ack('No Printer Online - Cannot Print',,5)

endif

RETURN(NIL)

FUNCTION __AddIndexLabel()

LOCAL    cKeyListLine := savescreen(MaxRow(),0,MaxRow(),MaxCol())
LOCAL    cIndexLabel
LOCAL    GetList := {}

cIndexLabel = HelpFile->Index

k_Clr(MaxRow())

@ MaxRow(),0 say 'Index: ' GET cIndexLabel PICTURE '@K'

READ

if lastkey() != K_ESC
    if k_RLock()
        REPLACE HelpFile->Index WITH cIndexLabel
    endif
endif

restscreen(maxrow(),0,maxrow(),maxcol(),cKeyListLine)

RETURN(NIL)

