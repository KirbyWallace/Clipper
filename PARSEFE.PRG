/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ParseFE( cString ) --> cFilenameEXTENSION

PARAMETERS:

cString : String filename to extract filename extention from

SHORT:

Extract the filename EXTENTION from a fully qualified filename.

DESCRIPTION:

k_ParseFE() accepts a string that contains a file name.  The string
may contain any valid file name, including drive letter and path,
(ie, "C:\DOS\FORMAT.COM") or a simple unqualified filename (ie,
"FORMAT.EXE").

k_ParseFE() returns the filename EXTENTION from the string.  If the
filename string does not contain a filename extention, then an
empty string is returned.

NOTE:

This is NOT a filename validation routine.  No attempt is made to
ensure that the filename in the string is a valid OS filename.

A runtime error will occur if cString is non-string or NIL.

EXAMPLE:

k_ParseFE( "C:\ABC\DOS\dotat19.COM" )                // "COM"
k_ParseFE( "C:\ABC\DEF\DOS\nodot1" )                 // ""
k_ParseFE( "C:ABC\DEF\DOS\dotat22.EXE" )             // "EXE"
k_ParseFE( "DOS\dotat12.TXT" )                       // "TXT"
k_ParseFE( "XYZ\DOS\dotat16.DB" )                    // "DB"
k_ParseFE( "\abc\def\geg\jjfsdf\fw\001\dotat09.1" )  // "1"
k_ParseFE( "\nodot5" )                               // ""
k_ParseFE( "dotat08." )                              // ""
k_ParseFE( "nodot6" )                                // ""

******************************************************************************/

FUNCTION k_ParseFE( cString )

LOCAL    cFileExt := ""
LOCAL    nDotAt   := 0
LOCAL    n        := 0
LOCAL    i        := 0

if (nDotAt := at(".",cString)) == 0

    cString += "."
    nDotAt = len(cString)

endif

cFileExt = substr(cString,nDotAt+1)

RETURN( cFileExt )

