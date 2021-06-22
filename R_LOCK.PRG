/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_RLock() --> lLockStatus

PARAMETERS:

None

SHORT:

Simple record lock.

DESCRIPTION:

k_RLock() is a general purpose record locking mechanism. k_RLock() employs 
a wait-forever approach, therefore, any program that employs it must take 
this into account.

NOTE:



EXAMPLE:

k_RLock()

An attempt is made to lock the current record.  Program does not return until 
the lock is successful.

******************************************************************************/

FUNCTION k_RLock()
LOCAL    Ret_Val := .f.
LOCAL    _rlock_scr := savescreen(MaxRow(),0,MaxRow(),MaxCol())

do while .t.

    @ MaxRow(),MaxCol()-5 say '[RL]'

    if rlock()
        ret_val = .t.
        exit
    else
        k_Clr(MaxRow())
        @ MaxRow(),00 say 'Record is Unavailable, Retrying Record Lock...'
    endif

    if inkey(1) != 27
        exit
    endif

enddo

restscreen(MaxRow(),0,MaxRow(),MaxCol(),_rlock_scr)

RETURN(Ret_Val)

