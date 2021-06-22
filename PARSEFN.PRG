/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ParseFN( cString ) --> cFileNAME

PARAMETERS:

cString : String filename to extract file name from

SHORT:

Extract the file NAME (NO EXTENTION) from a fully qualified filename.

DESCRIPTION:

k_ParseFN() accepts a string that contains a file name.  The string
may contain any valid file name, including drive letter and path,
(ie, "C:\DOS\FORMAT.COM") or a simple unqualified filename (ie,
"FORMAT.EXE").

k_ParseFN() returns the file NAME from the string.  If the filename
string does not contain a file name, then an empty string is returned.

NOTE:

This is NOT a filename validation routine.  No attempt is made to
ensure that the filename in the string is a valid OS filename.

A runtime error will occur if cString is non-string or NIL.

EXAMPLE:

k_ParseFN( "C:\ABC\DOS\dotat19.COM" )                // "dotat19"
k_ParseFN( "C:\ABC\DEF\DOS\nodot1" )                 // ""
k_ParseFN( "C:ABC\DEF\DOS\dotat22.EXE" )             // "dotat22"
k_ParseFN( "DOS\dotat12.TXT" )                       // "dotat12"
k_ParseFN( "XYZ\DOS\dotat16.DB" )                    // "dotat16"
k_ParseFN( "\OS2\def\geg\jjfsdf\fw\001\dotat09.1" )  // "dotat09"
k_ParseFN( "\nodot5" )                               // "nodot5"
k_ParseFN( "dotat08." )                              // "dotat08"
k_ParseFN( "C:\" )                                   // ""
k_ParseFN( "C:" )                                    // ""

******************************************************************************/

FUNCTION k_ParseFN( cString )

LOCAL    cFileName := ""
LOCAL    nDotAt    := 0
LOCAL    n         := 0
LOCAL    i         := 0

if (nDotAt := at(".",cString)) == 0

    cString += "."
    nDotAt = len(cString)

endif

for i = nDotAt-1 to 1 STEP -1

    if substr(cString,i,1) $ ":\"

        cFileName = k_Snatch(cString,i+1,nDotAt-1)
        EXIT

    endif

next

if i = 0
    cFileName = k_Snatch(cString,1,nDotAt-1)
endif

RETURN( cFileName )

