/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_XUse( cFile, cAlias, nArea, nSecs ) --> lError

PARAMETERS:

cFile  : File to Open
cAlias : Alias To Open Under
cArea  : Work Area Number to Open in
nSecs  : Seconds to wait before fail

SHORT:

General Purpose EXCLUSIVE file opener.

DESCRIPTION:

k_XUse() is a general purpose network file open function. It attempts to open 
a database file for EXCLUSIVE use. 

By default, it employs a "wait-forever" approach in that it will not 
return until it has secured the file in exclusive mode.  To change 
this, specify the number of seconds to wait before an open fail is assumed. 
 To wait forever, either specify 0 for nSecs, or nothing (ie, NIL).

If the cAlias is not specified, the file name is used as the alias.  If 
the file begins with a digit, it is removed ( aliases cannot begin with 
a digit) and an "A" is put in it's place.  Be careful, because 1DATA.DBF 
and 2DATA.DBF would therefore both be opened as "ADATA".

Also, any non alphabetic characters are removed and not replaced 
with anything.

NOTE:

cArea is a work are NUMBER.  If it is not specified, then the database 
is opened in the CURRENT area CLOSING whatever is open in that area.  To 
open in the first unused work area, specify 0 (zero) for cArea.  The file 
will be opened in that area and that area will become the current work area.

k_XUse() respects the setting of the DOS Environment variable _KFILEPATH, 
if present.  See KLIPPER.DOC for details on DOS Environment variables.

EXAMPLE:

k_XUse('BUDGET','BUDGET',5)

Result: If available, BUDGET is opened for EXCLUSIVE mode in work area 5


k_XUse('BUDGET','BUDGET',select(0))

Result: If available, BUDGET is opened for EXCLUSIVE mode in the first 
unused work area.

******************************************************************************/
#include "klipper.ch"
#include "inkey.ch"

FUNCTION k_XUse(cFile,cAlias,cArea,nSecs)
LOCAL    lRetVal
LOCAL    _DB_Path
LOCAL    i := -1
MEMVAR   _KFILEPATH

lRetVal = FALSE

nSecs = iif(nSecs = NIL,0,nSecs)

if cAlias == NIL
    cAlias = iif(isalpha(cFile),k_Convert(cFile),'a'+k_Convert(cFile))
endif

if cArea == NIL
    cArea = select()
endif

if type('_KFILEPATH') = 'U'
    _DB_Path = ''
else
    _DB_Path = _KFILEPATH
endif

cFile = alltrim(_DB_Path)+cFile

while TRUE

    SELECT (cArea)

    USE &cFile EXCLUSIVE ALIAS &cAlias

    if !neterr()
        lRetVal = TRUE
        EXIT
    endif

    if inkey(1) = K_ESC
        exit
    endif

    i = i+iif((nSecs != NIL .and. nSecs != 0),1,0)

    if i >= nSecs
        EXIT
    endif

end

RETURN(lRetVal)

