/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ImportP(cDefFileName,cImpFileName,cCommentChar,cDataChar) --> nNumLinesRead

PARAMETERS:

cDefFileName : Import Definition File
cImpFileName : Import Data File
cCommentChar : Text to denote comment line (Default NONE)
cDataChar    : Text to denote valid data line (Default NONE)

SHORT:

Formatted import from text file.

DESCRIPTION:

CAUTION: k_ImportP() can be a very complex function to understand and 
implement.  In the long run, the time you spend learning how to use it will 
benefit you.

The inspiration for this funtion came from an application that I once wrote 
that had to import data from a mainframe text file each month. But, 
unfortunately, the format of the text file changed frequently.

For those of you who have ever worked in a "test/production WITH change 
control" environment, you know that simply changing the program and 
recompiling won't work efficiently or quickly.  You have to be given access 
to the program's source code, set up a test environment, make changes, test, 
call change control to move the application to the production environment 
(which you don't have access to), and resubmit the source code to production 
control. All in all, it is VERY time consuming.

But what if the application could "interpret" the import file by means of a 
file layout or definition in another file?  Then, the import routine could be 
changed without ANY source code changes to the application.

Why, then you would have something like k_ImportP()!

k_ImportP() (Import Positional), is a general purpose importing mechanism that 
imports an ASCII text file into a database according to a definition laid out 
in another text data file..

The receiving database must be open, with any indexes, in the current area.  
Records are APPENDED to the database.

The Import Data File must be a plain ASCII file.


Sample function call: k_ImportP(IMPORT.DFN,IMPORT.TXT, '//')

The Definition File must describe the contents of the import data file and 
the fields into which each piece of data is to be placed in the following 
manner:

    <top of file>
    // 
    // Import Definition File for Quarterly Budget Mainframe Import
    // Contact XYZ Corp. Operations Services for Support
    //
    // STRUCTURE OF DEFINITION TEXT FILE: IMPORT.TXT
    // TARGET DATABASE: BUDGET.DBF
    // -----------------------------------------------------

    LINEPROC: ShowCount(nLineNum)

    POSITION:1/16  FIELD:Name
    POSITION:17/9  FIELD:SSN
    POSITION:26/8  FIELD:INTEGER
    POSITION:34/9  FIELD:DECIMAL1 TYPE:1
    POSITION:43/11 FIELD:DECIMAL2 TYPE:3
    POSITION:54/6  FIELD:DATE1    TYPE:1
    POSITION:60/8  FIELD:DATE2    TYPE:1
    POSITION:68/8  FIELD:DATE3    TYPE:3
    <end of file>

*** LINEPROC DISCUSSION ***

LINEPROC: denotes the name of a function that is executed after each line of 
the import file is read.  This provides an opportunity to, for example, make 
a "status" screen indicating progress.  The only "exported" data from the 
function is the current line count of the import file.  This counter is 
updated in a variable that the calling application provides by name as the 
parameter to the LINEPROC function.  (In the above example, the application 
that calls the k_ImportP() function must have a function called SHOWCOUNT() in 
scope at the time the import begins.  Additionally, the function call 
indicates that the memory variable to receive the current line count is 
"nLineNum".  It must be of type numeric and must be in scope at the time the 
import begins.)

Here is the logic behind it:  When the k_ImportP() function is called, it runs 
until completion before returning to the calling application.  What this 
means is that there is no return value until the import is completely done.  
In order to give the application any clue as to what is happening inside the 
function (and thereby give the user any indication), it must declare a public 
or private memvar to hold a line count (the only data "exported" by the 
function during execution) and tell the k_ImportP() function to update it with 
the current number of lines read as it progresses.

Furthermore, the calling application must specify a function that is to be 
called by k_ImportP() as each line is read.  This function is written and 
linked into the application and then the application must tell the k_ImportP() 
function to call that function after each line of import text has been read.

The name of this function, AND the name of the variable that has been setup 
for it's use are BOTH defined on the LINEPROC line.  Since the function only 
exports the current line number, then only one variable can be used in the 
LINEPROC function.  

If the Import Definition File contains: "LINEPROC:ShowCount(a,b,c)" you will 
have trouble when the k_ImportP() function tries to interpret "a,b,c" as the 
name of a numeric variable to increment.

The correct implementation is:

LINEPROC:YourFunctionName(YourNumericVariableName)

The result will be: YourFunctionName() will be called for each import data 
file line read, and the counter variable YourNumericVariableName will be 
incremented.

Here's the implementation:

    // in the calling APP
    PRIVATE nCounter := 0

    // also in the calling APP
    FUNCTION ShowCount()
    MEMVAR nCounter

    @ 01,01 say 'Record Counter: '+ltrim(str(nCounter))

    RETURN(NIL)

    // in the definition file
    LINEPROC:ShowCount(nCounter)

    k_ImportP(...)

When the definition file is read, the line that defines the LINEPROC 
funciton:

1. Names the function to call: ShowCount()

2. Determines the name of the variable that will receive the line counter.

Obviously if this variable is not in scope at this time, you will get a 
run-time error in the usual way:

"Variable does not exist: nCounter"

*** POSITION, FIELD, TYPE DISCUSSION ***

POSITION: denotes the starting position and length of the field in the import 
data file.  The import definition file must not necessarily define the entire 
file.  You may include POSITION: labels for only that data which is needed 
and the undefined portion of the line will be ignored.

FIELD: denotes the a field name to receive the data.  This field must be 
present in the current database work area. Legally, this database need not be 
open for EXCLUSIVE access, but it is recommended that it be open EXCLUSIVELY 
since if the import fails for any reason, all records added since the import 
began are deleted, which might also include records appended by other 
applications.

TYPE: denotes the data format of the import data.  

Keep in mind that in an ASCII file, ALL data is character.  In order to 
convert it to other data types during import, you will need to tell the 
function something about the type of data it is getting and how to interpret 
it.  For instance, many mainframe text files use packed decimal or, more 
commonly, "implied" decimal places in numerics.  So, for example, the string 
of digits "1234" might mean 1234, 123.4, 12.34, 1.234, or .1234.  When 
k_ImportP() comes across this, how do you tell it how to convert it?  With the 
TYPE: token.

For numerics data, it specifies the number of decimal places to insert. If 
not specified at all, no decimal places are assumed.

TEXT        TYPE           RESULT
-------------------------------------
"12345678"  TYPE:2  -->    123456.78
"12345678"  TYPE:3  -->    12345.678
"12345678"  <none>  -->     12345678


NOTE:

TYPE: does not determine the data type that the import data will be converted 
to - that information is derived from the database field specified in the 
FIELD token.  It only specifies the FORMAT of the data, ie the numeric "type" 
or the date "type."

If decimals are present in the import file, ie, "123.4" then IMPLICIT 
DECIMALS are used no matter what the TYPE token specifies.

If TYPE: is not specified, the data format defaults to NO DECIMALS
UNLESS IMPLICIT for numerics and MM/DD/YY for date types.

For all types other than NUMERIC and DATE, the TYPE token has no meaning and 
will be ignored if specified.

If you are not interested in certain characters from the import file, 
then simply omit describing them in the Import Definition File and they 
will not be read.

Note that there can be NO SPACES between the colon of each token and 
it's coresponding value.  "TYPE:1" is OK, but "TYPE: 1", "TYPE : 1", and
"TYPE : 1" are all out.

FIELD:NAME              is OK
FIELD: Name             is NOT OK

*** NUMERIC TYPE SPECIFIERS ***

Example - TYPE:n, where n = Implied Decimals places

If you specify an implied decimal places and an exlicit decimal is found, 
then k_ImportP() will automatically switch to implicit decimals mode for 
that field.  Implicit decimals means that the decimal point is present in 
the data file.  If no decimal point is present, yet the numbers are 
decimal numbers, use a TYPE:n to define the number of implied decimal 
places to assume.

*** DATE TYPE SPECIFIERS ***

Example - TYPE:n  

Where n = 1  MM/DD/YY or MMDDYY       Standard
          2  DD/MM/YY or DDMMYY       English
          3  MM/DD/YYYY or MMDDYYYY   Standard, 4 digit year
          4  DD/MM/YYYY or DDMMYYYY   English,  4 digit year
          5  DDDYY                    Julian 2 digit year
          6  DDDYYYY                  Julian 4 digit year


Note that type 1, for example, considers MM/DD/YY and MMDDYY the same.  This 
is because all "/"'s are stripped from the data before an attempt is made to 
interpret the date.

If the cCommentChar is specified, the same comment character(s) must be 
used in both the import file and the definition file! Use caution 
when specifing the cCommentChar so that you do not use any character 
sequence that might be actual data in the import file!

*** LOGICAL TYPES ***

There is no TYPE token for Logical Field values.  If the import database 
field determines that the incoming data should be a logical, then logical 
values are assumed according to the following table:

    TRUE         FALSE
    --------------------
    "Y"         "N"
    "y"         "n"
    "T"         "F"
    "t"         "f"
    "1"         "0"
    "TRUE"      "FALSE"

Any other character(s) found in the import file that are being placed into 
a logical field will cause the import to fail.

WHEN AN IMPORT FAILS

An import can be caused to fail by any of a number of conditions, all but 
one of which are related to data that is incompatible with the field that has 
been specified *with* the TYPE: format that has been specified.

The following are these causes.  The FIRST one is the only non-data related 
way of failing an import.

1 - User Presses ESC during import.

2 - Integer portion of numeric data exceeds capacity of the specified 
field (ie, Data Width Error) 

3 - Decimal portion (whether explicit or implied) exceeds capacity 
of specified field.  No rounding takes place.  If you specify three 
decimal places and the field contains only two decimal places, it's over. 
(ie, Data Width Error) 

4 - Date does not match the format you specified in the Import 
Definition File.  If you specify TYPE:6 (DDDYY) and the file actually 
contains MM/DD/YY.  It is immediatly over since you will be one digit short 
of a full date (DDDYY has five, MM/DD/YY has six).  Other times may be 
more tricky.  If you specify the Standard date format and then actually get 
an English date in the import file, you may or may not make it though.  
Either way, unless the Month and Day are exactly the same, you are going 
to end up with the wrong date my a margin of several months.

5 - Something other than Y,y,N,n,T,t,F,f,1,0,TRUE,FALSE shows up in 
a POSITION: range that is mapped to a logical field.


When an import fails, all records added to the database since the import 
began are marked for deletion and a return code is set. 

*** RETURN CODES ***

The return code is a decimal number.  The integer portion indicates the 
error number and the decimal portion indicates the line number of either 
the import definition file or the import data file where the error occured. 

#      Meaning
------------------------------------------------------------------

0 No error - Import completed.

1 This line of the import definition was missing a required POSITION: label.

2 This line of the import definition was missing a required FIELD: label.

3 This line of the Import Definition specified a field name that does 
not exist in the database.

4 Explicit Decimals in data file exceed capacity of the specified 
database field.


5 Integer places exceed field capacity in non-int number

6 Integer places exceed field capacity in integer number

7 Invalid data in LOGICAL field

8 Character data in import file exceeded capacity of specified database 
field.

9 Botched Function call in LINEPROC:

10 No database was open when the import was attempted.

EXAMPLE:

FUNCTION Main()
#include "kfile.ch"

MEMVAR  nCounter
PRIVATE nCounter := 0

FILE_BEGIN TEST.DBF

    FLD Name,     C, 16
    FLD SSN,      C,  9
    FLD INTEGER,  N,  8
    FLD DECIMAL1, N, 10, 1
    FLD DECIMAL2, N, 10, 1
    FLD DECIMAL3, N, 12, 3
    FLD DATE1,    D
    FLD DATE2,    D
    FLD DATE3,    D
    FLD DATE4,    D
    FLD DATE5,    D
    FLD DATE6,    D
    FLD DATE7,    D
    FLD Memo,     M
    FLD Log1,     L
    FLD Log2,     L
    FLD Log3,     L

FILE_END TEST.DBF

FILE_BEGIN TEST2.DBF

    FLD NUMBER,   C, 7
    FLD DATE1,    D
    FLD DATE2,    D
    FLD DATE3,    D
    FLD DATE4,    D
    FLD DATE5,    D
    FLD DATE6,    D
    FLD DATE7,    D
    FLD DATE8,    D
    FLD DATE9,    D

FILE_END TEST2.DBF

USE TEST.DBF ALIAS test
ZAP

INDEX ON test->name TO test

CLEAR SCREEN

?
? 'Return: '+str(k_ImportP('test.def','test.txt','//'))

RETURN(NIL)

SEE DEMO\IMPORTP\IMPTEXT.PRG for a working example with data and definition 
files.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_ImportP( cDefFileName, cImpFileName, cCommentChar, cDataChar )

#define __POSITION k_Extract(DefArray[i],'|',1)
#define __FIELD    k_Extract(DefArray[i],'|',2)
#define __TYPE     k_Extract(DefArray[i],'|',3)

LOCAL    nDHandle
LOCAL    nIHandle
LOCAL    cThisLine
LOCAL    i
LOCAL    lFieldValid
LOCAL    xData
LOCAL    cField
LOCAL    cType
LOCAL    nLen
LOCAL    nDec
LOCAL    cDateType
LOCAL    cNumType

LOCAL    nRetVal   := 0.00
LOCAL    DefArray  := {}
LOCAL    aDBStruct := dbstruct()
LOCAL    cLineProc := ''
LOCAL    cVarCount := ''
LOCAL    nOldRec   := recno()
LOCAL    nLastRec  := lastrec()
LOCAL    nILineNum := 0
LOCAL    nDLineNum := 0

#include "kfile.ch"
#include "fileio.ch"


BEGIN SEQUENCE

    if empty(alias())
        nRetVal = 10.00
        BREAK
    endif

    if file(cDefFileName)

        nDHandle = fopen(cDefFileName)

        fseek(nDHandle,0,FS_SET)

        *******************************
        * read import definition file *
        *******************************

        while !k_FEOF(nDHandle)

            cThisLine = k_ReadLine(nDHandle) ; nDLineNum++

            if !empty(cThisLine)

                if cCommentChar != NIL

                    if substr(trim(cThisLine),1,len(cCommentChar)) = cCommentChar
                        loop
                    endif

                    // trim off comment to end of line
                    if cCommentChar $ cThisLine
                        cThisLine = substr(cThisLine,1,at(cCommentChar,cThisLine)-1)
                    endif

                endif

                if !empty(cThisLine)

                    // Check to see if a lineproc function has been declared:
                    if ('lineproc:' $ lower(cThisLine))


                        cLineProc = k_SubUntil(lower(cThisLine),'lineproc:',' ')

                        if at( ')',cLineProc ) < at('(',cLineProc)
                            // some fool botched a simple function call
                            nRetVal = val('9.'+ltrim(str(nDLineNum)))
                            BREAK

                        endif

                        if !( '(' $ cLineProc )
                            // no variable to export line count
                            // just a function name without parends

                            cVarCount = ''

                        else

                            if '()' $ cLineProc
                                // no variable to export line count
                                // just a function name with empty parends

                                cVarCount = ''

                            else

                                cVarCount = k_SubUntil(cLineProc,'(',')')

                                if type(cVarCount) != 'N'
                                    cVarCount = ''
                                endif

                            endif

                        endif

                        cLineProc = substr(cLineProc,1,at('(',cLineProc)-1)

                        LOOP

                    endif

                    ///////////////////////////////////////////////////////////////

                    // cCommentChar may have trimmed the entire line

                    if !('position:' $ lower(cThisLine))
                        nRetVal = val('1.'+ltrim(str(nDLineNum)))
                        BREAK
                    endif


                    ///////////////////////////////////////////////////////////////

                    if !('field:' $ lower(cThisLine))
                        nRetVal = val('2.'+ltrim(str(nDLineNum)))
                        BREAK
                    endif

                    aadd(DefArray,__Parse(cThisLine,nDLineNum))


                    ///////////////////////////////////////////////////////////////
                    // Check field name is valid

                    nRetVal = val('3.'+ltrim(str(nDLineNum)))

                    for i = 1 to len(aDBStruct)

                        if k_Extract(DefArray[len(DefArray)],'|',2) == lower(aDBStruct[i,1])
                            nRetVal = 0.00
                            EXIT
                        endif

                    next

                    if nRetVal != 0.00
                        BREAK
                    endif

                endif

            endif

        end

        ********************
        * Read import file *
        ********************

        if file(cImpFileName)

            nIHandle = fopen(cImpFileName)

            while !k_FEOF(nIHandle)

                cThisLine = k_ReadLine(nIHandle) ; nILineNum++

                if !empty(cThisLine)

                    if cCommentChar != NIL

                        if substr(trim(cThisLine),1,len(cCommentChar)) = cCommentChar
                            loop
                        endif

                        // trim off comment to end of line
                        if cCommentChar $ cThisLine
                            cThisLine = substr(cThisLine,1,at(cCommentChar,cThisLine)-1)
                        endif

                    endif

                    if !empty(cThisLine)

                        // cCommentChar may have trimmed the entire line

                        APPEND BLANK

                        for i = 1 to len(DefArray)

                            // get field positions from array and read that range from import file

                            xData = substr(cThisLine,val(k_Extract(__POSITION,'/',1)), ;
                                                     val(k_Extract(__POSITION,'/',2)))


                            // determine target field, type, size, decimals, etc

                            cField  = field(fieldpos(__FIELD))
                            cType   = type(field(fieldpos(__FIELD)))

                            for i = 1 to len(aDBStruct)

                                if aDBStruct[i,1] = cField

                                    nLen = aDBStruct[i,3]
                                    nDec = aDBStruct[i,4]

                                    EXIT

                                endif

                            next

                            if empty(cField)
                                // error - Invalid field name in Import Definition File
                                nRetVal = val('3.'+ltrim(str(nILineNum)))
                                BREAK
                            endif

                            do case

                                case cType = 'D'

                                    cDateType = lower(__TYPE)

                                    do case

                                        case cDateType = '1'  .or. empty(cDateType) // MM/DD/YY or MMDDYY

                                            if !('/' $ xData)

                                                xData = substr(xData,1,2)+'/'+;
                                                        substr(xData,3,2)+'/'+;
                                                        substr(xData,5,2)
                                            endif

                                            // will have "08/21/64"

                                            xData = ctod(xData)

                                        case cDateType = '2'  // DD/MM/YY or DDMMYY

                                            if !('/' $ xData)

                                                xData = substr(xData,1,2)+'/'+;
                                                        substr(xData,3,2)+'/'+;
                                                        substr(xData,5,2)
                                            endif

                                            // will have "21/08/64"

                                            xData = ctod(substr(xData,4,2)+'/'+;
                                                    substr(xData,1,2)+'/'+;
                                                    substr(xData,7,2))


                                        case cDateType = '3'  // MM/DD/YYYY or MMDDYYYY

                                            if !('/' $ xData)

                                                xData = substr(xData,1,2)+'/'+;
                                                        substr(xData,3,2)+'/'+;
                                                        substr(xData,5,4)
                                            endif

                                            // will have "08/21/1964"

                                            xData = ctod(substr(xData,1,2)+'/'+;
                                                    substr(xData,4,2)+'/'+;
                                                    substr(xData,9,2))


                                        case cDateType = '4'  // DD/MM/YYYY or DDMMYYYY

                                            if !('/' $ xData)

                                                xData = substr(xData,1,2)+'/'+;
                                                        substr(xData,3,2)+'/'+;
                                                        substr(xData,5,4)
                                            endif

                                            // will have "21/08/1964"

                                            xData = ctod(substr(xData,4,2)+'/'+;
                                                    substr(xData,1,2)+'/'+;
                                                    substr(xData,9,2))

                                        case cDateType = '5'  // DDDYY

                                            // no slashes should be in a julian date

                                            xData = ctod('01/01/'+substr(xData,4,2))+;
                                                    val(substr(xData,1,3))-1

                                        case cDateType = '6'  // DDDYYYY

                                            xData = ctod('01/01/'+substr(xData,6,2))+;
                                                    val(substr(xData,1,3))-1

                                    endcase

                                    fieldput(fieldpos(cField),xData)

                                case cType = 'N'

                                    if !('.' $ xData)

                                        // if no explicit decimal check for implied decimal format specifier

                                        cNumType = lower(__TYPE)

                                        if cNumType $ '123456789'

                                            //? xData
                                            xData = stuff(xData,(len(xData)-val(cNumType)+1),0,'.')
                                            //? xData

                                            //inkey(0)

                                        endif

                                    endif


                                    if '.' $ xData
                                        // check if decimals exceed field def

                                        if len(xData)-at('.',xData) > nDec
                                            // explicit decimals exceed field definition
                                            nRetVal = val('4.'+ltrim(str(nILineNum)))
                                            BREAK
                                        endif

                                        // check if int exceeds field def

                                        if at('.',xData)-1 > nLen-nDec-iif(nDec=0,0,1)
                                            // integer places exceed field definition in non-int number
                                            nRetVal = val('5.'+ltrim(str(nILineNum)))
                                            BREAK
                                        endif

                                    else

                                        // check if int exceeds field def

                                        if len(xData) > nLen-nDec-iif(nDec=0,0,1)
                                            // integer places exceed field definition in integer number
                                            nRetVal = val('6.'+ltrim(str(nILineNum)))
                                            BREAK
                                        endif

                                    endif

                                    xData = val(xData)

                                    // because numerics data is usually important and because it is not
                                    // apparent at a casual glance whether it is correct or not, k_ImportP()
                                    // will abort the import and delete all records that it has imported
                                    // (in essence, a rollback - but you still need to pack) if any of the
                                    // following occur:


                                    //    1 - Integer portion exceeds integer capacity of field
                                    //    1 - implied decimal portion exceeds decimal capacity of field
                                    //    1 - explicit decimal portion exceeds decimal capacity of field

                                    // decimal with int field - save int() part

                                    fieldput(fieldpos(cField),xData)

                                case cType = 'L'

                                    if xData $ 'TtYy1FfNn0'

                                        fieldput(fieldpos(cField),iif( xData $ 'tYy1TRUE',TRUE,FALSE))
                                    else
                                        nRetVal = val('7.'+ltrim(str(nILineNum)))
                                        BREAK
                                    endif


                            otherwise

                                // handles all character and memo operations, on which no
                                // "invalidity" can be detected other than length.

                                if len(xData) > nLen .and. cType = 'C'
                                    nRetVal = val('8.'+ltrim(str(nILineNum)))
                                    BREAK
                                else
                                    fieldput(fieldpos(cField),xData)
                                endif

                            endcase



                            // convert data type
                            // fieldput(i)


                        next



                    endif

                endif

                if !empty(cLineProc)
                    if type(cLineProc+'()') == 'UI'
                        &cLineProc()
                    endif
                endif

                if !empty(cVarCount)
                    // cVarCount contains the NAME of a numeric variable
                    // which must be in scope when k_ImportP() is called.
                    // That is, it must be PUBLIC or PRIVATE.

                    &cVarCount++

                endif

            end // eof input handle

            nRetVal = 0.00

        endif

    endif


END SEQUENCE

if ( (nRetVal != 0.00) .and. (nRetVal != 10.00) )

    // rollback database

    if lastrec() != nLastRec

        i = 1

        while TRUE

            GOTO nLastRec+i

            if eof()
                EXIT

            else
                DELETE
                i++

            endif

        end

    endif

endif

RETURN(nRetVal)


STATIC FUNCTION __Parse(cLine,nLine)
LOCAL  cRetVal := ''

cRetVal += k_SubUntil(lower(cLine),'position:',' ')+'|'
cRetVal += k_SubUntil(lower(cLine),'field:',' ')+'|'
cRetVal += k_SubUntil(lower(cLine),'type:',' ')

RETURN(cRetVal)

