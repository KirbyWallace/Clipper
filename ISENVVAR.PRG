/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IsEnvVar( acVarNames, lContent ) --> xElement

PARAMETERS:

acVarNames : Array of strings to use as DOS Environment var names
lContent   : TRUE  = Return CONTENTS of found variable (DEFAULT)
             FALSE = Return NUMBER of array element found

SHORT:

Tests existence of, and optionally returns, contents of DOS env variables.

DESCRIPTION:

k_IsEnvVar() scans the environment looking for any of the environment 
variables listed in acVarNames.

As soon as one is found:

If lContent is TRUE, the contents of the variable are returned as a 
string.  Else, the element number of the found variable is returned.



If none of the variable names in acVarNames[] matches a DOS Environment:

If lContent is TRUE, the return value is empty (""). Else, the return value 
is 0.

The variable name elements are case insensitive.  The search stops at the 
FIRST match.

NOTE:



EXAMPLE:

Scenario: 

    DOS Environment variables "U_NAME=KIRBY_WALLACE" and
    "LOGIN_NAME="KIRBYW".  None of the others exist.

#define CONTENT .T.
#define ELEMENT .F.

acVars = {  "USERID"     ,
            "USERNAME"   ,
            "USER_NAME"  ,
            "U_NAME"     ,
            "USER_ID"    ,
            "LOGIN_NAME"   }

t = k_IsEnvVar( acVars, CONTENT )
Result: t = "KIRBY_WALLACE"


t = k_IsEnvVar(acVars, ELEMENT )
Result: t = 4


In this example, I have asked the function to look for any of the DOS 
environment variables in acVars.  In this case, U_NAME *and* LOGIN_NAME 
exist.  Since U_NAME is referenced first, the function will return either the 
contents or the element number of U_NAME.

Basically, this is a function that get information from a list of *possible* 
DOS env. vars.  It is used, for example, in k_FScreen() to put the user name 
on the screen if it is defined in any of a number of popular user name 
variables that are likely to exist at run-time.

******************************************************************************/

#include "klipper.ch"

FUNCTION k_IsEnvVar(acVarNames, lContent)

LOCAL    xRetVal := ""
LOCAL    i


lContent = iif( lContent = NIL, TRUE, lContent )

for i = 1 to len( acVarNames )

    if !empty( (xRetVal := gete(upper(acVarNames[i]))) )

        if !lContent
            xRetVal = i
        endif

        EXIT

    endif

next


RETURN(xRetVal)

