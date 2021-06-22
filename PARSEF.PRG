/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ParseF( cString, nType ) --> cString

PARAMETERS:

cString : String from which Path, Filename or Ext is to be extracted from
nType   : Which of the above to return:

            PARSE_FPATH  Return PATH from string
            PARSE_FNAME  Return file NAME from string
            PARSE_FEXT   Return file EXTENTION from string

SHORT:

Extract path, filename, or extention from a fully qualified filename.

DESCRIPTION:

k_ParseF() receives a fully qualified filename string (one including Drive
letter, path, filename and extention such as "C:\DOS\FILENAME.EXT") and
returns either the PATH, file NAME or file EXTENTION, as specified in
nType.

Any and all parts of the string may be missing.  That is, fully qualified
is still fully qualified even if a path is not present.  k_ParseF() will
return empty() for any missing parts.

The following are all examples of strings that can be parsed:

    1.  C:\DOS\FILENAME.EXT

            PARSE_FPATH returns "C:\DOS\"
            PARSE_FNAME returns "FILENAME"
            PARSE_FEXT  returns "EXT"

        Important: Note that k_ParseF() cannot determine whether FILENAME.EXT
        is a file or a directory.  The function is not designed to validate
        file or directory existence, only to parse paths from files and
        extentions.  Since FILENAME.EXT is a perfectly valid directory name,
        the function returns FILENAME and EXT as the filename and file
        extention regardless.


    2. C:\ABC\DEF\GHI.DIR\FILENAME.EXT

            PARSE_FPATH returns "C:\ABC\DEF\GHI.DIR\"
            PARSE_FNAME returns "FILENAME"
            PARSE_FEXT  returns "EXT"

    3. C:\ABC\DEF\GHI.DIR\FILENAME

            PARSE_FPATH returns "C:\ABC\DEF\GHI.DIR\"
            PARSE_FNAME returns "FILENAME"
            PARSE_FEXT  returns ""

    4. C:\ABC\

            PARSE_FPATH returns "C:\ABC\"
            PARSE_FNAME returns ""
            PARSE_FEXT  returns ""

    5. \ABC\

            PARSE_FPATH returns "\ABC\"
            PARSE_FNAME returns ""
            PARSE_FEXT  returns ""

    6. \ABC

            PARSE_FPATH returns "\"
            PARSE_FNAME returns "ABC"
            PARSE_FEXT  returns ""

    7. \FILENAME.EXT

            PARSE_FPATH returns "\"
            PARSE_FNAME returns "FILENAME"
            PARSE_FEXT  returns "EXT"

    8. FILENAME.EXT

            PARSE_FPATH returns ""
            PARSE_FNAME returns "FILENAME"
            PARSE_FEXT  returns "EXT"

    9. FILENAME

            PARSE_FPATH returns ""
            PARSE_FNAME returns "FILENAME"
            PARSE_FEXT  returns ""


The action is performed according to the following rules:

Rules:

1. If the string contains a ":", there is a drive letter present.  Remove
   all characters up to the ":" leaving only the path\filename.ext that we
   wish to parse.  The drive letter will be added back to the PATH once we
   have isolated it.

   "C:\DOS\STUFF\FILENAME.EXT" --> "\DOS\STUFF\FILENAME.EXT"

   cDRIVE = "C:"
   cPATH  = "\DOS\STUFF\"
   cFILE  = "FILENAME"
   cEXT   = "EXT"


2. If there is a "." anywhere in the string, we may have a filename with
   extention, or we may have a directory name with extension.

   "\ABC.DIR\FILENAME.EXT"

   cPath = \ABC.DIR\"
   cFile = "FILENAME"
   cExt  = "EXT"

   Note that FILENAME.EXT may actually be a directory!


3. If there is more than one ".", then at least one of the "file/ext"
   combinations is a directory name.  The number of directories is
   "n" dots -1.

   \ABC.DIR\DEF.DIR\FILENAME.EXT

   Three dots: Two definate directories and one filename/directory.



4. If string ends in "\" the whole thing is a path.

    "C:\DOS\"
    "DOS\"
    "\"


5. If string contains NO "\" the whole thing is a file name or a directory
   name (still considered a file name since the function cannot distinguish
   the two - keep in mind that this function is receiving a string from
   somewhere, and may not represent any real file or directory that exists
   to be checked...)


NOTE:

The drive letter, if present in the string, is always returned in the path.

If nType is incorrectly specified, or NOT specified, the return string is
empty.  Use the pre-processor #defines to eliminate this error:

    PARSE_FPATH  Return PATH from string
    PARSE_FNAME  Return FILENAME from string
    PARSE_FEXT   Return FILE EXTENTION from string

EXAMPLE:

//   get fully qualified filename of current program
//   ie, t = 

cProgram = k_ExeName()  // cProgram = "F:\APPS\NOTES\READER.EXE"

cExePath = k_Parse(cProgram, PARSE_FPATH)
cExeFile = k_Parse(cProgram, PARSE_FNAME)+"."+k_Parse(cProgram, PARSE_FEXT)

? cExePath    // "F:\APPS\NOTES\"
? cExeFile    // "READER.EXE"

INCLUDE: klipper.ch

******************************************************************************/
#include "klipper.ch"

FUNCTION k_ParseF( cString , nType )

LOCAL    cDrive  := ""
LOCAL    cPath   := ""
LOCAL    cName   := ""
LOCAL    cExt    := ""
LOCAL    cRetVal := ""

LOCAL    i          := 0

BEGIN SEQUENCE

if nType < PARSE_FPATH .or. nType > PARSE_FEXT
    BREAK
endif

if ":" $ cString
    // Drive letter present - Rule #1 applies...
    cDrive  = substr(cString,1,at(":",cString))
    cString = substr(cString,at(":",cString)+1)
endif

if at("\",cString) = 0

    // No "\" - Rule #5 applies...

    cName = cString

    if "." $ cName

        cExt  = substr(cName,at(".",cName)+1)
        cName = substr(cName,1,at(".",cName)-1)

    endif

else

    if right(cString,1) = "\"

        // Ends in "\" - Rule #4 applies
        cPath = cString

    else

        for i = 1 to k_ChCount("\",cString)+1

            if i <= k_ChCount("\",cString)
                cPath += k_Extract(cString,"\",i)+"\"
            else
                cName = k_Extract(cString,"\",i)
            endif

        next

        if "." $ cName

            cExt  = substr(cName,at(".",cName)+1)
            cName = substr(cName,1,at(".",cName)-1)

        endif

    endif

endif

cPath = cDrive+cPath

do case

    case nType = PARSE_FPATH
        cRetVal = cPath

    case nType = PARSE_FNAME
        cRetVal = cName

    case nType = PARSE_FEXT
        cRetVal = cExt

endcase

END SEQUENCE

RETURN( cRetVal )

