/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Cascade( cStartDir, cUDFName ) --> nInteger

PARAMETERS:

cStartDir : Directory where cascade begins
cUDFName  : Name of UDF to be executed in each directory.

SHORT:

Execute a function in every subdirectory.

DESCRIPTION:

k_Cascade() starts at the current directory (if not specified otherwise 
in cStartDir), and executes the UDF named in cUDFName, one time in 
the current/specified directory and once in each subdirectory thereof.

Note that you cannot change drives with this function.  i.e., you cannot 
pass "D:\STARTDIR" to cStartDir and expect to see directories on that drive.

k_Cascade() only changes the current directory to the specified directory, 
and does not log new drives.  You must do this yourself if it is necessary. 
 You can see exactly why by typing a CD command yourself on the DOS 
command line.  While on C: and with a diskette in A:, type CD A:\DIRNAME. 
 Notice that the directory is indeed changed ON DRIVE A:.  But you are 
still logged on Drive C:.  Same thing happens here.  !!Be on the drive 
you want before calling k_Cascade().

In a network environment, you may want to specifically log the drive you 
need:

! M:

and then call k_Cascade(). 

k_Cascade() returns -1 if the UDF specified is not present, or if the 
starting directory specified does not exist.

NOTE:

*** IMPORTANT ***
                                                                      
BLINKER USERS: This function will use SWPRUNCMD() to execute it's DOS 
environment commands.  You do not need to do anything to take advantage of 
Blinkers Swap Function.
                                                                      
RTLINK USERS: This function will use "!/RUN" to execute it's DOS commands.  
You cannot avoid this, however you will get UNDEFINED SYMBOL warnings from 
the Linker.  This is because a test is made to see if Blinker was used to 
link the program, and the test itself references Blinker's function library.  
The program should work fine, though, since if the test fails, (ie, not 
Blinker), no Blinker functions are used and "!/RUN" commands are issued 
instead.  

If I were you, I'd just get Blinker... :-)
                                                                      
OTHERLINK USERS.  I don't know.  You may be outta luck!! But if nothing 
else, source code is available and you can modify the function 
specifically for your needs.

EXAMPLE:

k_Cascade(,"ShowFiles('*.exe')"

Result: ShowFiles() will be called on the current directory and 
any subdirectories.


k_Cascade("C:\SUBDIR\DUNGEON","Wash('*.axe','SpotLess')"

Result: ShowFiles() will be called first on C:\SUBDIR\DUNGEON and then in 
any subdirectories under the DUNGEON.

******************************************************************************/

FUNCTION k_Cascade( cStartDir, cUDFName )

LOCAL    acDir    := {}
LOCAL    lBlink   := iif(type('swpcurdir()') == 'UI',.T.,.F.)
LOCAL    nRetVal  := -1
LOCAL    cOldPath := ""
LOCAL    i, xNul

STATIC   nCallLevel := 0

if nCallLevel = 0
    cOldPath = curdir()
endif

BEGIN SEQUENCE

nCallLevel++

if lBlink
    swpcurdir(.F.)
endif

// touch up parameters, if necessary

if cUDFName = NIL
    BREAK
else

    nRetVal = 0

    if right(alltrim(cUDFName),1) != ')'
        cUDFName = alltrim(cUDFName)+'()'
    endif

endif

if cStartDir != NIL .and. nCallLevel = 1

    // Switch to specified directory

    if lBlink
        swpruncmd( "CD "+cStartDir )
    else
        ! ("CD "+cStartDir)
    endif

endif

acDir   := directory('*.*','D')

// Execute UDF here...

if type(cUDFName) == 'UI'
    xNul = &cUDFName
endif


// recurse any subdirectories...

for i = 1 to len(acDir)

    if 'D' $ acDir[i,5] .and. substr(acDir[i,1],1,1) != '.'

        if lBlink
            swpruncmd( "CD "+acDir[i,1] )
        else
            ! ( "CD "+acDir[i,1] )
        endif

        // subsequent calls must NOT recall the original start directory!

        k_Cascade(,cUDFName)

        if lBlink
            swpruncmd( "CD .." )
        else
            ! CD ..
        endif

    endif

next

END SEQUENCE


nCallLevel--

// reset to original directory

if nCallLevel = 0

    if lBlink
        swpruncmd( "CD \"+cOldPath )
    else
        ! ( "CD \"+cOldPath )
    endif
endif

RETURN(NIL)

