/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LockKey(cProc, nLine, cVar, cPassword) --> NIL

PARAMETERS:

cProc    : Calling Procedure (supplied when called via SET KEY)
nLine    : Line number       (supplied when called via SET KEY)
cVar     : current variable  (supplied when called via SET KEY)
cPassword: Password to unlock keyboard (Optional)

SHORT:

Clear and lock-up screen with password.

DESCRIPTION:

k_LockKey() prompts the user for a keyboard lockup password, clears the screen 
and waits for that same password to be re-entered.  If the re-entered 
password matches the lockup password, the function returns control to the 
calling program.

If the optional cPassword is passed to the function, k_LockKey() skips the 
"enter password" step and locks the keyboard with the password specified in 
cPassword.

In either case, the same password must be entered again to unlock 
the keyboard.





NOTE:

When ANY function is called via SET KEY TO ... it automatically receives 
THREE parameters indicating the calling procedure, the line number and 
the current variable (if any). 

This means that the first three arguments must always be specified in order 
to ensure that the password ends up in the fourth, whether called directly 
or via a SET KEY call.

If you call this function directly, you MUST pass either dummy arguments, 
or better yet, NIL for the first three arguments (cProc, nLine and cVar), 
and the password in the fourth argument, cPassword!

TO CALL VIA HOTKEY:
-------------------

k_LockKey()

Result: LockKey is supplied the three default arguments, and the 
fourth, cPassword, is NIL.  This causes a prompt for the lockup password 
AND the unlock password  which must both be the same.

TO CALL DIRECTLY:
-----------------

k_LockKey('',0,'','PASSWORD')

or better yet:

k_LockKey(,,,'PASSWORD')

Result: The three arguments for cProc, nLine and cVar receive either dummy 
or NIL arguments and the password 'PASSWORD' is supplied to the 
fourth parameter, cPassword. 

No lockup password is prompted and an UNLOCK prompt is presented in which 
you must enter "PASSWORD" to unlock.

In EITHER case, cProc, nLine, and cVar are ignored.


EXAMPLE:

k_LockKey()

Result: The user is prompted for a password to lockup the keyboard with.  
A password prompt is presented and the same password must be re-entered 
to unlock the keyboard. 

k_LockKey('BUBBA')

Result: A password prompt is immediately presented and BUBBA must be entered 
to unlock the keyboard.  The user is not prompted to enter a password for 
unlock, but rather the password "BUBBA" is assumed.

******************************************************************************/

FUNCTION k_LockKey(cProc,nLine,cVar,cPassword)
LOCAL    cKeyPass   := space(10)
LOCAL    cKeyScreen := savescreen(0,0,MaxRow(),MaxCol())
MEMVAR   GetList

if cPassword = NIL
    cPassword = upper(k_Password(10,10,'Enter Lockup Password',10))
endif

while .t.

    k_PopBox(0,0,MaxRow(),MaxCol(),5,chr(177))

    cKeyPass = upper(k_Password(10,10,'The System Has Been Locked! Enter UnLock Password',10))

    if cPassword == cKeyPass
        exit
    else
        tone(2000,15)
    endif

end

restscreen(0,0,MaxRow(),MaxCol(),cKeyScreen)

RETURN(NIL)

