/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Prepare(lUseErrHandler) --> NIL

PARAMETERS:

lUseErrHandler : TRUE or FALSE to use or not use the custom error handler.

SHORT:

Sets various run time envrionments, options, and a custom error handler.

DESCRIPTION:

k_Prepare() issues several statement and function calls that are common to all 
programs (generally) that use this library as a development platform.  It 
sets statuses that are commonly used by the other functions in this library 
such as k_Menu(), k_KMenu() and k_FScreen().

An additional feature of this program is that any program using can be 
disabled by creating a file in the program directory called @DISABLE.DAT and 
then calling this function at the beginning of every program.

If the @DISABLE.!!! file exists, the program is terminated with a message 
explaining why.  It is handy to control access in a network environment when 
users must be prevented from access so that updates can be made.  
Additionally, you may include comments in the @DISABLE.!!! file explaining 
why the application has been disabled and these comments (ie, the entire 
contents of the file) will be displayed on the screen. 

k_Prepare(), if used in any application, also changes the default errorblock 
to use the custom error handling block, bErrorBlock.

This custom error handler logs run time errors in a file specified in a DOS 
environment variable ERRFILE on the path specified by a DOS Environment 
variable ERRPATH.

Both of these are acceptable DOS environment variable settings:

SET ERRPATH=\ERRORS\
SET ERRPATH=\ERRORS

This is invalid:

SET ERRPATH=\ERRORS\ERRORLOG.TXT

The path setting must contain ONLY a path.

This is an example of the file name specification:

SET ERRFILE=\ERRORLOG.DAT


These are invalid:

SET ERRFILE=\ERRORLOG.TXT
SET ERRFILE=ERRORLOG.TXT\

The ERRFILE must contain ONLY a file name.

If either are not specified, the default is:

ERRPATH : Current directory
ERRFILE : ERRORLOG.TXT


The use of the custom error handler can be disabled by passing FALSE as a 
parameter: k_Prepare(.F.)  This will disable runtime error logging and the 
Klipper Error Object. 

bErrorBlock is a custom error handling system that records many important 
statistics and settings (including the user screen) in an error log file 
specified as a parameter to k_Prepare().  If not specified, the default file 
name is ERRORLOG.TXT.  The default location of this file is the current 
directory.  The location can be changed by setting an OS environment variable 
called ERRPATH.

APPLICATION NOTE FILES
----------------------

If a file exists in the current directory named APmmddyy.APN, (where mmddyy 
is a date), and the date is todays date, the contents of that file are 
presented to the user before the application begins.

These files may be prepared in advance by inserting the appropriate mmddyy 
value in APmmddyy.APN.  When mmddyy comes around on the calendar, this 
Application Note File will be presented to all users each time the system 
starts and k_Prepare() is called.  The note will vanish the next day when the 
system date changes.



NOTE:

Use of this function REQUIRES the setting of the U_NAME DOS 
Environment Parameter.

EXAMPLE:

k_Prepare()

Result: 

SCORE is set OFF
COLOR is set to w+/b,w+/g
CURSOR is set OFF
WRAP is set ON
EXCLUSIVE is set OFF

If @DISABLE.!!! is present, the program is terminated and the contents of the 
file are displayed on the screen.  The disable file name is hard coded in 
k_Prepare() and may not be changed (unless, of course, you have purchased a 
source code liscence - hint hint).

All errors are recorded in a file called ERRORLOG.TXT in the current 
directory.

Example 2: (Using an OS Environment Variable (ERRPATH=\LOGFILES)

k_Prepare('ERRORS.LST')

Result: 

SCORE is set OFF
COLOR is set to w+/b,w+/g
CURSOR is set OFF
WRAP is set ON
EXCLUSIVE is set OFF

Same as above, but all errors are recorded in a file called ERRORS.LST in the 
\LOGFILES directory.

******************************************************************************/
#include "fileio.ch"
#include "klipper.ch"
#include "error.ch"

FUNCTION k_Prepare( lUseErrHandler )

LOCAL    bErrorBlock
LOCAL    nDisableHandle
LOCAL    nEndPointer
LOCAL    U_Name := iif( empty(gete("U_NAME")), gete("LOGIN"), gete("U_NAME") )
LOCAL    cFileString := space(2000)
LOCAL    lDefault := FALSE

MEMVAR   GetList


lUseErrhandler = iif(lUseErrHandler == NIL, TRUE, lUseErrHandler )

SET score off
SET color to w+/b,w+/g
SET cursor off
SET wrap on
SET exclusive off


*************************************
* Read APPLNOTE.TXT File if current *
*************************************

k_ReadAppNote()

************************
* check disable status *
************************

k_AppKill('@DISABLE.!!!')

****************************************
* check User Name Environment Variable *
****************************************

if empty(U_Name)
    k_Terminate('Required environment variable U_NAME not set - Cannot Execute')
endif

**********************************
* Setup error recording routines *
**********************************

if lUseErrhandler
    bErrorBlock := { | bErrObject | __ErrorRecord( bErrObject ) }
    errorblock( bErrorBlock )
endif


RETURN(NIL)


FUNCTION __ErrorRecord( bErrorObject )

LOCAL    nFHandle, i

LOCAL    U_Name        := gete("U_NAME")
LOCAL    cPath         := gete("ERRPATH")
LOCAL    cFile         := gete("ERRFILE")
LOCAL    nWorkArea     := Select()
LOCAL    cOldColor     := SetColor('w+/r')
LOCAL    lRetry        := FALSE
LOCAL    cPrintErrDesc

LOCAL    lOldPrintSet
LOCAL    cOldDeviceSet
LOCAL    cOldConsole

************************************************************************************************************************

// The following three cases identical to standard error handler:

// by default, division by zero yields zero
if ( bErrorObject:genCode == EG_ZERODIV )

    RETURN(0)

end


// for network open error, set NETERR() and subsystem default
if ( bErrorObject:genCode == EG_OPEN .and. bErrorObject:osCode == 32 .and. bErrorObject:canDefault )

    NetErr(TRUE)
    RETURN(FALSE)

end


// for lock error during APPEND BLANK, set NETERR() and subsystem default
if ( bErrorObject:genCode == EG_APPENDLOCK .and. bErrorObject:canDefault )

    NetErr(TRUE)
    RETURN(FALSE)

end


************************************************************************************************************************
// no screen save, beep, and runtime error data collection unless user ":CanRetry" and did not.

BEGIN SEQUENCE

if bErrorObject:CanRetry


    // test here for recoverable errors (ie, :CanRetry errors)

    i = 3

    while ( i-- > 0 )

        do case

            case ( bErrorObject:SubSystem = 'TERM' .and. empty( bErrorObject:SubCode ) )

                cPrintErrDesc = LF+'  The printer is not responding'+LF+'_____________________________'+LF+LF+;
                                   '  Please check that the printer has paper loaded and is on-line.'

                tone(2000,2)

                lOldPrintSet   := set(_SET_PRINTER,FALSE)
                cOldDeviceSet  := set(_SET_DEVICE,'SCREEN')
                cOldConsoleSet := set(_SET_CONSOLE,TRUE)

                setcolor('w+/r')

                k_TextBrowse(7,5,15,75,cPrintErrDesc,BOXTHICK,LABELBOTTOM,' Press ESC to Retry ')

                set(_SET_PRINTER,lOldPrintSet)
                set(_SET_DEVICE,cOldDeviceSet)
                set(_SET_CONSOLE,cOldConsoleSet)

                setcolor(cOldColor)

                if isprinter()
                    lRetry = .t.
                    exit
                else
                    lRetry = .f.
                endif


            otherwise

                lRetry = .f.
                exit

        end

    end

endif

If lRetry
    // skip the runtime error data collection and beep, and retry
    BREAK
endif

************************************************************************************************************************

// go ahead and come back to the screen - we aren't going back to any printout that might have
// been in progress anyway.

set(_SET_PRINTER,FALSE)
set(_SET_DEVICE,'SCREEN')
set(_SET_CONSOLE,TRUE)

// remind me why we are pausing so long...
tone(1000,1) ; tone(1000,1) ; tone(1000,.1)


cFile = iif(empty(cFile), 'ERRORLOG.TXT',cFile)

if !empty( cPath := alltrim(cPath) )
    if right(cPath,1) != '\'
        cPath += '\'
    endif
endif

cFile = cPath+cFile // cFile += 'ERRORLOG.TXT'

if !file( cFile )
    nFHandle = fcreate( cFile, FC_NORMAL )
else
    nFHandle := fopen( cFile, FO_WRITE )
endif


if ferror() = 0

    fseek(nFHandle,0,FS_END)

    k_FWriteLine(nFHandle,"")

    ******************************************************
    * error information from application and environment *
    ******************************************************

    k_FWriteLine(nFHandle,'Date       : '+dtoc(date()) )
    k_FWriteLine(nFHandle,'Time       : '+time() )
    k_FWriteLine(nFHandle,'User       : '+U_Name )
    k_FWriteLine(nFHandle,'Variable   : '+readvar() )
    k_FWriteLine(nFHandle,'Last Key   : '+ltrim(str(lastkey())) )
    k_FWriteLine(nFHandle,'Read Key   : '+ltrim(str(readkey())) )
    k_FWriteLine(nFHandle,'Next Key   : '+ltrim(str(nextkey())) )
    k_FWriteLine(nFHandle,'Memory     : '+ltrim(str(memory(0))) )

    /****

    Record Proc Call history

    call levels 0 and 1 will always be the same:

        0 = this function (__ErrorRecord())
        1 = b:k_Prepare()

    Start at call level 2 which will be the line in the user application
    where the error occured.

    */

    i = 2

    while .t.

        if !empty(procname(i))

            k_FWriteLine(nFHandle,'ProcName   : '+procname(i)+' Line: '+ltrim(str(procline(i))) )
            i++
        else
            EXIT
        endif

    end

    *********************************
    * save info from argument array *
    *********************************

    if valtype(bErrorObject:Args) = 'A'

        for i = 1 to len(bErrorObject:Args)

            k_FWriteLine(nFHandle,'Arg '+ltrim(str(i))+'      : '+;
                                  '[ Type:'+valtype(bErrorObject:Args[i])+' ] '+;
                                  k_ToChar( bErrorObject:Args[i] ) )

        next

    endif

    k_FWriteLine(nFHandle,'Description: '+k_ToChar( bErrorObject:Description ) )
    k_FWriteLine(nFHandle,'FileName   : '+k_ToChar( bErrorObject:FileName ) )
    k_FWriteLine(nFHandle,'GenCode    : '+k_ToChar( bErrorObject:GenCode ) )
    k_FWriteLine(nFHandle,'Operation  : '+k_ToChar( bErrorObject:Operation ) )
    k_FWriteLine(nFHandle,'OsCode     : '+k_ToChar( bErrorObject:OsCode ) )
    k_FWriteLine(nFHandle,'SubCode    : '+k_ToChar( bErrorObject:SubCode ) )
    k_FWriteLine(nFHandle,'SubSystem  : '+k_ToChar( bErrorObject:SubSystem ) )
    k_FWriteLine(nFHandle,'Tries      : '+k_ToChar( bErrorObject:Tries ) )


    k_FWriteLine(nFHandle,'Work Areas : ')

    for i = 1 to 254

        if !empty(alias(i))

            SELECT (i)

            k_FWriteLine(nFHandle,iif(i = nWorkArea,'->','  ')+ltrim(str(i))+': '+alias(i)+' Record#: '+ltrim(str(Recno())) )

        endif

    next

    k_FWriteLine(nFHandle,'')




    k_FWriteLine(nFHandle,'User Screen: ')

        __SaveScreen( nFHandle )

    k_FWriteLine(nFHandle,repl('*',80))


    fclose(nFhandle)


else
    tone(3000,3)

endif


END SEQUENCE

SetColor(cOldColor)

if !lRetry

    k_Ack('RunTime Error: '+procname(2)+'/'+ltrim(str(procline(2)))+' - Error Log Updated')
    k_Terminate('RunTime Error: '+procname(2)+'/'+ltrim(str(procline(2)))+LF+LF+'* PRESS ENTER *' )

endif

RETURN(lRetry)


FUNCTION k_ReadAppNote()

LOCAL    nNoteHandle
LOCAL    cTemp := ""

if file('AP'+k_Convert(dtoc(date()))+'.APN')

    nNoteHandle = fopen('AP'+k_Convert(dtoc(date()))+'.APN')

    cTemp = SaveScreen(0,0,maxrow(),maxcol())

    k_FScreen('Application Note','PgUp/PgDn, Press ESC when finished reading the note.' )

    k_Box(4,4,21,76)
    k_FileBrowse(5,5,20,75,nNoteHandle,4)

    fclose(nNoteHandle)

    restscreen(0,0,maxrow(),maxcol(),cTemp)

    CLEAR SCREEN

endif

RETURN(NIL)

