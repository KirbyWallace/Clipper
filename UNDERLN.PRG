/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Underline( cWhat ) --> cString

PARAMETERS:

cWhat : String to print and then underline

SHORT:

Underline print data as it is sent to the printer.

DESCRIPTION:

k_Underline() is a printing function that prints its text string parameter 
and then backs up and underlines it.

This is actually done in reverse order.  The @ Say statement must have 
an argument to avoid a run-time error.  Thus, this function returns writes 
the underline to the length of the text parameter and then returns 
that parameter to satisfy the needs of the @ SAY statement.

NOTE:

If combined with the k_Bold() function, the k_Bold() function must contain 
the k_Underline() function:

@ prow(),pcol() say k_Bold(k_Underline('BOLD AND UNDERLINED'))

This causes the Bold to be printed, returning the original parameter 
to k_Underline() which underlines, which in turn returns the original 
parameter to satisfy the @ SAY statement.

EXAMPLE:

@ PROW(),PCOL() SAY k_Underline('THIS IS UNDERLINED')

******************************************************************************/

FUNCTION k_Underline(cWhat)

LOCAL    u_row := prow()
LOCAL    u_col := pcol()

@ u_row,u_col say repl('_',len(cWhat))
@ u_row,u_col say ''


RETURN(cWhat)

