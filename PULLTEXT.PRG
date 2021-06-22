/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PullText( nFile, cFromText, cToText ) --> cString

PARAMETERS:

nFile    : File handle of previously opened text file
cFromText: Text to copy FROM but not including
cToText  : Text to copy TO but not including

SHORT:

_PullText extracts lines from a text file between two tokens.

DESCRIPTION:

k_PullText() scans an ASCII TEXT file, line by line, looking for the occurance 
of the cFromText token. 

When and if it is found, text is copied from the line following until the 
end token is reached, or the end of file is encountered.  

The tokens MUST MATCH CASE.  Case *is* sensitive.

The Begin and end tokens must appear on a line by themselves at column one. 
 Anything following the token on that line is ignored.  Text is read 
starting at the first line AFTER the begin token and ends on the first 
line BEFORE the end token.

Notes:

1. If no cFromText token exists, _PullString() will return an empty string. 

2. If cFromText token DOES exist, but cToText token DOES NOT exist, you are 
going to get back the entire file, from the cFromText point all the way to 
the bottom of the file, including ALL the other begin and end tokens and 
their text as well as anything you have "embedded" between the tokens in 
"unused" areas.

NOTE:



EXAMPLE:

A VERY short example.  The following text file is for ALL of the 
following examples.

<************** TOP OF PULLTEXT.TXT FILE *****************>

|------ Column Position ------|
1         2         3
0....5....0....5....0....5....0

Tom, the plaintiff, made these comments on 11.23.93

:BeginThomas
Hi!  I'm Tom.  Edward and Percy bonked me on the
head yesterday.
:EndTom

Following are Edward's Comments.

:BeginEdward
Hullo!  I'm Edward.  Percy did it all by 'imself.
:EndEdward

Percival's comments were made on 11/23/93

#BeginPercy
Percival Here!  That's a damned lie. Both of them.
I was never near the place.
#EndPercy

(*** The judge delivers the sentence ***)

!BeginJudge
Guilty!  Life!
!EndJudge

<****************** EOF PULLTEXT.TXT FILE ***************>

Examples:


nFile = fopen('case.txt')

*******************************************************
* FIRST PULL note that the begin and end tokens       *
* are slightly different.  That's fine.  call them    *
* whatever you like, just be sure you call them right.*
*******************************************************

? k_PullText(nFile,':BeginThomas',':EndTom')

"Hi!  I'm Tom.  Edward and Percy bonked me on the
head yesterday."

***************
* SECOND PULL *
***************

? k_PullText(nFile,':BeginEdward',':EndEdward')

"Hullo!  I'm Edward.  Percy did it all by 'imself."

******************************************************
* THIRD PULL - notice the different tokens for this  *
* one.  This is fine.  Again, you can use anything   *
* you like, and as many different tokens as you      *
* like - just remember what they are.  Personally    *
* I'd recommend using the same tokenizing pattern.   *
******************************************************

? k_PullText(nFile,'#BeginPercy','#EndPercy')

"Percival Here!  That's a damned lie. Both of them.
I was never near the place."

*************
* FNAL PULL *
*************

? k_PullText(nFile,'!BeginJudge','!EndJudge')
"Guilty!  Life!"

*----------------------------------------------------------*


If you looked at it this way:

? k_PullText(nFile,':BeginThomas',':EndTom')
?
? k_PullText(nFile,':BeginEdward',':EndEdward')
?
? k_PullText(nFile,'#BeginPercy','#EndPercy')
?
? k_PullText(nFile,'!BeginJudge','!EndJudge')

Hi!  I'm Tom.  Edward and Percy bonked me on the
head yesterday.

Hullo!  I'm Edward.  Percy did it all by 'imself.

Percival Here!  That's a damned lie. Both of them.
I was never near the place.

Guilty!  Life!

Watch Out for the following:

? k_PullText(nFile,'#BeginPercy','#Endpercy')
?
? k_PullText(nFile,'!BeginJudge','!EndJudge')


Result:

    Percival Here!  That's a damned lie. Both of them.
    I was never near the place.
    #EndPercy

    (*** The judge delivers the sentence ***)

    !BeginJudge
    Guilty!  Life!
    !EndJudge


    Gulty!  Life!

Note that the end token for Percy was not properly specified.  They are 
case sensitive.  Since it never found the specified end token, the 
function returned the entire file from begin-token to end-of-file. 
This included all the other begin and end tokens, all the inbetween texts - 
all because the end token you specified didn't exist!
 
Be careful with your token naming scheme.  I suggest using a standard  
say, ALL CAPS with only a preceeding ":" for instance.

On NEXT call the function found it's delimiting tokens with no problem 
and returned the (now duplicated) "Guilty!  Life!!" sentence.

******************************************************************************/


#include "klipper.ch"
#include "fileio.ch"

FUNCTION k_PullText(nFile,cFromText,cToText)

LOCAL    cString := ""
LOCAL    nOldFPtr := fseek(nFile,0,FS_RELATIVE)
LOCAL    cThisLine


BEGIN SEQUENCE

    fseek(nFile,0,FS_SET)

    while !k_FEOF(nFile)

        cThisLine = k_ReadLine(nFile)

        if cFromText $ cThisLine

            // cString = substr(cThisLine,at(cFromText,cThisLine)+len(cFromText))+LF

            while !k_FEOF(nFile)

                cThisLine = k_ReadLine(nFile)

                if cToText $ cThisLine
                    // cString += substr(cThisLine,1,at(cToText,cThisLine))
                    BREAK
                else
                    cString += cThisLine+LF
                endif

            end

        endif

    end

END SEQUENCE

fseek(nFile,0,nOldFPtr)

RETURN(cString)

