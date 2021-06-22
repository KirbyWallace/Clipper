LOCAL FA
LOCAL KA

#xtran FILE_BEGIN <file> => if !file(#<file>);FA := {};KA=Select();Select 0 ;

#xtran FILE_END <newfile> => ;
        dbCreate(#<newfile>, FA); use ; select (KA) ; endif

#xtran BEGIN_FILE <file> => if !file(#<file>);FA := {};KA=Select();Select 0 ;

#xtran END_FILE <newfile> => ;
        dbCreate(#<newfile>, FA); use ; select (KA) ; endif

#xtran FLD <id1>, <id2> [,<id3> [,<id4>]] => ;
        aadd(FA,{#<id1>,#<id2> ,#<id3> ,#<id4> }) ;;
        FA\[len(FA),3] := iif(!empty(FA\[len(FA),3]),val(FA\[len(FA),3]),0) ;;
        FA\[len(FA),4] := iif(!empty(FA\[len(FA),4]),val(FA\[len(FA),4]),0) ;

/***********************************************************************************

USAGE NOTES:

FILE_BEGIN
FILE_END
FLD

SOURCE CODE PLACEMENT
---------------------

This xtrans command also requires a LOCAL declaration to be made.  For that
reason, to avoid warnings, include the KFILE.CH  INSIDE your FUNCTION
declaration.

    FUNCTION MyFunc()
    #include "kfile.ch"     <------------------------- here!

    LOCAL   x,y,z

    statement...
    statement...
    statement...
    statement...

    RETURN(nil)


FA ARRAY NAME - FA reserved identifier
-----------------------------------------------------

The FA array name (Short for File Array) was chosen because it is short:
only two characters.  This became necessary when the array was referenced
six times in one line.  It would be too large to easily read, and since this
code is "FOR THE PRE-PROCs EYES ONLY", it doesn' matter much.  Still, the
FA identifier is reserved.


FILE_BEGIN, FILE_END & FLD PREPROCESSOR DIRECTIVES
-----------------------------------------------------

Allows an abbreviated form of creating databases from extended structure files.
The first example is a typical method of creating a database, and the second
is the legal abbreviated form.

1. Use no quotes around text or numeric.
2. Field Data can simply be typed and separated by a comma.
3. Length/Decimals Optional for Date, Memo, Integer Fields)
4. File name MUST have file name extention.
5. The identifier FA is reserved.

Briefly, the purpose is to facilitate an easy method of checking the
existence of a particular file, and creating it if necessary.  The typical
use is to include these directives at the beginning of every application for
two reasons:  (1) to initially create the necessary databases the FIRST time
the program is run (negating the need for dBASE or DBU.EXE) and (2) regularly
checking the existence of the files each time the program runs to see if any
have been deleted.  Once created, these directives do nothing if the file is
present.  If the file is not present, it is created according to the FLD
definitions.  Thus, accidental deletions will not cause a run-time error.

The Directives amount to the following:

IF .NOT. FILE("YOURFILE.DBF")             // FILE_BEGIN YOURFILE.DBF

    CREATE TEMP

    DEFINE FIELDS                         // FLD ...
    .                                     // FLD ...
    .                                     // FLD ...
    .                                     // FLD ...

    CREATE YOURFILE.DBF FROM TEMP
    ERASE TEMP

ENDIF                                     // END_FILE YOURFILE.DBF

                               CAUTION
---------------------------------------------------------------------------

MS-DOS utilities are available for unerasing an accidentally erased file.
However, this task is made much more difficult if since the original file
was deleted, another has been created with the SAME FILE NAME.  Thus, the
potential for recovery is drastically improved when (1), no other file has
been created with the same name, and (2) as little disk writing as possible
has occured since the accidental erasure.

These directives will create the database named by FILE_BEGIN.  If the file
originally WAS present, and then accidentally deleted, and these directives
re-create the database with the same name, you will have made recovery of the
original very, very difficult.  Use only in cases of transient databases which
can be easily re-created or else add safegaurds. *

* Continued Next Page 

One possible solution to the "overwriting originals" problem may be to check
your data files via a separate routine that uses FILE_BEGIN/END only where
permissible, or use a routine that adds a prompt before creating:

START OF APPLICATION

// Check Critcal Files

if !FILE('critical.dbf')
    if Ask_User('Would you like to create the missing Critical File?) = 'Y'

        FILE_BEGIN CRITICAL.DBF
            FLD ...
            FLD ...
            FLD ...
        FILE_END CRITICAL.DBF
    else
        Tell_User('Not Created, Contact CAD Representative...)
    endif
endif

// Check Transient or Non-Ccritical Files

FILE_BEGIN NON_CRITICAL.DBF

    FLD ...
    FLD ...
    FLD ...

FILE_END NON_CRITICAL.DBF

*****************************************************************************

In the case of CRITICAL.DBF, you make the file existence check redundant,
(YOU check for it, and then FILE_BEGIN xxxxxx.xxx checks for it again) but
it allows YOU to get control before FILE_BEGIN does; creating the file only
after you have had an opportunity to approve.  Had you not added the statement
"IF !FILE()", the FILE_BEGIN directive would have checked and created the
missing file without question, thus making any possibility of retreiving an
accidentally erased file much more remote.

Concerning the Identifier Names
-------------------------------

The identifier FLD (for Field structure), MUST be in UPPER CASE in your
source code, both in the #xtranslate definition, and in the source code
instance.  If you wish any other form, you need to modify both accordingly.
I.E. If you want to use "Fld" instead of "FLD", you must change both.
In a nutshell, the #xtranslate directive IS case sensitive.  You do not have
to use "FLD", you can change it to anything you like, perhaps "MoRgRiFy"
if you like.

Kirby L. Wallace

* Examples Follow on Next Page 

***************************
* STANDARD CLIPPER METHOD *
***************************

if !file('SYSTEM.DBF')
        
        create temp
        
        APPEND BLANK
        REPLACE field_name WITH 'USER', ;
                field_type WITH 'C', ;
                field_len  WITH 10, ;
                field_dec  WITH 0
        
        APPEND BLANK
        REPLACE field_name WITH 'SYSTEM', ;
                field_type WITH 'C', ;
                field_len  WITH 10, ;
                field_dec  WITH 0
        
        APPEND BLANK
        REPLACE field_name WITH 'SECURITY', ;
                field_type WITH 'N', ;
                field_len  WITH 2, ;
                field_dec  WITH 0
        
        APPEND BLANK
        REPLACE field_name WITH 'APPL_ADM', ;
                field_type WITH 'L'
        
        APPEND BLANK
        REPLACE field_name WITH 'HAVE_MAIL', ;
                field_type WITH 'L'
        
        APPEND BLANK
        REPLACE field_name WITH 'LAST_USE', ;
                field_type WITH 'D'
        
        APPEND BLANK
        REPLACE field_name WITH 'EXPIRES', ;
                field_type WITH 'D'
        
        
        create SYSTEM from TEMP
        use
        erase TEMP.DBF
        
endif

* Continues Next Page 

**************************************************************************
* The following lines are the equivalent w/ the #xtranslate directives   *
**************************************************************************
        
FILE_BEGIN SYSTEM.DAT
        
    FLD USER,     C, 10
    FLD SYSTEM,   C, 10
    FLD SECURITY, N, 2
    FLD BALANCE,  N, 8, 2
    FLD APPL_ADM, L
    FLD EXPIRES,  D
    FLD LAST_USE, D
        
FILE_END SYSTEM.DAT

******************************************************************************/

