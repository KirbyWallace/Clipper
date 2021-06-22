/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_FLock() --> lLockStatus

PARAMETERS:

None

SHORT:

Lock current database file if possible.

DESCRIPTION:

k_FLock() is a general purpose file locking mechanism.

Like k_RLock() and k_SUse()/k_XUse(), this function waits indefinately until the 
lock is resolved.  That is to say, no exception can be made.  Program 
execution stops until the file lock is successful.

NOTE:



EXAMPLE:

k_FLock()

Result: File is locked and unavailable for SHARED use by any other user.

******************************************************************************/

FUNCTION k_FLock()
LOCAL    Ret_Val := .f.
LOCAL    _flock_scr := savescreen(MaxRow(),0,MaxRow(),MaxCol())

do while .t.

    @ MaxRow(),MaxCol()-5 say '[FL]'

    if flock()
        ret_val = .t.
        exit
    else
        k_Clr(MaxRow())
        @ MaxRow(),00 say 'File is Unavailable, Retrying File Lock...'
    endif

    if inkey(1) != 27
        exit
    endif

enddo

restscreen(MaxRow(),0,MaxRow(),MaxCol(),_flock_scr)

RETURN(Ret_Val)


