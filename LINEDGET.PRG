/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_LineEdGet( cKey, cAlias, cField ) --> cString

PARAMETERS:

cKey   : Index Key Value for Text-Comment File
cAlias : Text-Comment File Alias
cField : Field name in the cAlias work area for text

SHORT:

Retrieve text from LineEdit comment database.

DESCRIPTION:

In the following discussion, it is assumed that you understand the basic 
principle by which MEMO fields operate, as well as their inherent 
inefficiency.

The LineEdit comments manager is a collection of functions that allow you to 
replace the inefficent MEMO field (*.DBT) with a more efficient 
database-based free-form text storage recycling system.  I say "recycling" 
because at the core of these functions lies an implementation of an already 
well known technique: that of reusing the space previously occupied by 
deleted records for new records, and appending new records only when there 
are no recyclable records available.

In a nutshell, there are five functions that allow you to store, 
retrieve, check the size of a comment, and check available storage 
capacity, for comments or any free-form text.  These functions are 
discussed next.

There is a complete demonstration of these functions under DEMOS\LINEEDIT, 
along with some realistic, (albeit unscientific) comparisons of LineEdit 
databases with conventional MEMO fields. The results may suprise you.

Another good example is the DEMOS\UTILS\LE_RESIZ\LERESIZE.PRG program, which 
will enable you to resize a comment base AFTER it has been created and used.

*****************************************************************************

k_LineEdGet() retrieves text from the database and field named in cAlias
and cField for all records matching cKey. 

The database MUST be open and aliased by the name in cAlias, although it need 
not be the current work area.  All of these functions select the file by the 
alias specified in cAlias and restore whatever the current database was 
before the call was made.


If no records match cKey, then the function returns an empty string.  
Test with EMPTY().  To test the length of the RETURNED string use LEN().  
To test the size of the comment BEFORE extracting it, use 
k_LineEdSize(), which will return the size of the comment for the
specified key and let you decide whether to k_LineEdGet() it or not.

*****************************************************************************


k_LineEdPut() writes to the text database.  Comments kept, created,
and written with k_LineEdPut() are encrypted (and decrypted
by k_LineEdGet()).  In addition, records no longer in use are recycled
for use in other comments.  This occurs when a text note is deleted or 
reduced in size.  The extra space that was once used by the text is freed 
to be used by another comment.

To recycle a record, chr(219) is replicated throughout the length of the 
key field and SEEK'd before APPENDING any more records. This accomplishes 
two things.  First, speed is increased by not ALWAYS having to append 
and write new records as new comments are added, but rather existing 
records are recycled (if available) and second, and probably most notable, 
the disk storage needed to store text is GREATLY diminished in the 
most commonplace circumstances.


NOTE then, that you cannot use chr(219) as an index key for the note file 
or, subsequently, the database that the text is attached to.  A chr(219) 
can occur in the key, but the key cannot be entirely composed of them or 
the record will be taken as an unused record, available to be overwritten 
by another comment.

Any attempt to SEEK a null string (empty() or otherwise) will 
immediately result in "" as a return value.  This is a safety 
precaution because a SEEK on a null string may match EVERYTHING in the 
note database (depending on the setting of "SET EXACT").

*****************************************************************************

k_LineEdSize() returns the size of a comment that is stored in a
LineEdit database.  This may a necessary step in cases where comments 
may approach Clipper's 64K string length limit. 

Theoritically, a comment stored in a LineEdit database may be of any size  
limited only by disk space.  However, any ability to manipulate this comment 
as a single text string is limited to 64K bytes by Clipper.

Given that the database must be written by k_LineEdPut() in order to be
retrievable by k_LineEdGet(), this is very unlikely if at all possible.

However, if you intend to add functionality to your application by having 
your own routines add to the database (this is possible if you have the 
source code to these functions), then you would do well to have the ability 
to check the size of the stored comment before attempting to extract it with 
k_LineEdGet().  In other cases, you may simply want to know ahead of time
the size of the comment field before actually getting it.  On some 80286, and 
especially on any XT system (and I won't even mention PC's), the time to 
extract the comment may cause a noticeable pause which you may want to 
prepare your user for.

The size returned by k_LineEdSize() includes some non-printable
characters, such as CRLF pairs and "soft returns."  These characters are 
not seen during memoedit or most other editing mechanism as they 
are interpreted by most of them as formatting characters.  However, when 
they are converted to a disk file or database field, they are present and 
add to the overall length of the string.

Generally speaking, you should add two bytes for each line of text to 
cover these formatting characters. 

Most text editing mechanisms, given the following, would report 18 bytes:

<top of string/file>
ABCDEFG
HIJKLMN
<end>

because in addition to the 14 characters, there are two CRLF pairs at the 
end of each line which occupy two bytes each. 

*****************************************************************************

k_LineEdAvail() returns the number of bytes of comment storage space
that exist in recycleable records.  This is the number of bytes of 
storage available without increasing the size of the database.  In a 
comment editing system that averages about the same number of bytes added 
as bytes deleted, usually about 50% of the size of the database will 
be available.  On systems where comments are only added and never 
deleted, then this function will return "0 bytes available."  Even in 
this case, the efficiency is better than plain MEMO fields which still 
grow exponentially even when you are repeatedly adding text. When comments 
are frequently edited, the database will contain more recycleable space.

*****************************************************************************

k_LineEdKill() deletes records from the comment database by overwritting
the key and comment fields of the comment database with a special 
character, effectively deleting them while leaving them in the file to 
be recycled for other comments.

*****************************************************************************

HOW TO MAKE A LINEEDIT DATABASE FOR FREE-FORM COMMENTS:

Let's say you have a database (COMPANY.DBF) with the following structure, 
with which you wish to keep free-form text comments: 

COMPANY.DBF:

1 COMP_NAME, C, 35
2 COMP_ACCT, C, 10
...
...
...
n ...

Let's also suppose that the database's primary key index is on Company 
Account Number (COMP_ACCT).  To attach LineEdit text/comments to this 
database, you will need to create a database that has at least two fields: 
COMP_ACCT and a comment field.  You choose the name of the field, and it's 
length.  The minimum length is 30 bytes.  70 to 100 or more is recommended.

Generally speaking, there is a balance point between the size of the 
comment field and the speed of the LineEdit functions.  On the one hand, a 
larger comment field holds more data, decreasing the number of records needed 
to store a large comment, resulting in faster processing.  On the other hand, 
a larger comment field will result in more "white space" being stored, and is 
thus less space efficient.  Again, 70 to 100 bytes or more is recommended.  
It depends on the nature of the comments you are keeping. If you are 
typically adding one-line comments of 80 chars or so, then 90 chars is 
probably best.

Create the LineEdit database with any name you like.  You will 
specifically refer to it later by the alias under which you open it. Let's 
say we decide to call it "SALENOTE.DBF."

Create your database with at least the COMP_ACCT field identical to the 
same field in the primary database (for relational indexing) and the 
comment field.  Let's say you decide to call it SALE_NOTES, C, 80.

Other fields unrelated to the text storage can be added for your own 
purposes, but they will be ignored by the LineEdit functions unless they are 
a part of the index key (ie, your primary database index key may be built 
on multiple fields.)

Now you have:

COMPANY.DBF:

1  COMP_NAME, C, 35
2  COMP_ACCT, C, 10  (INDEX KEY)
...
...
...
n  ...

SALENOTE.DBF:

1  COMP_ACCT,  C, 10
2  SALE_NOTES  C, 80

All that remains is to relate the two with an index on SALENOTE.DBF that 
will order it by the same key as the primary database.  You are really 
just doing what you have always been doing with multiple databases - 
creating a relation on index keys.

There is one more step however.
-------------------------------

The index key of the comment database must match exactly the primary 
database index key PLUS the FIRST FOUR BYTES OF THE COMMENT FIELD.

See the DEMOS\LINEEDIT\MAIN.PRG for a simple example.

It's very simple, really.  Whatever your primary index key is on the 
parent database, use it in the comment database ADDING the first four bytes 
of the comment field:

USE COMPANY.DBF  ALIAS Company  NEW SHARED
INDEX ON Comp_Acct

USE SALENOTE.DBF ALIAS SaleNotes NEW SHARED
INDEX ON Comp_Acct+substr(Sale_Notes,1,4)

Suppose you use a multiple field index key on the primary database? 
No problemo:

USE COMPANY.DBF  ALIAS Company  NEW SHARED
INDEX ON Comp_Acct + Comp_Name

USE SALENOTE.DBF ALIAS SaleNotes NEW SHARED
INDEX ON Comp_Acct + Comp_Name + substr(Sale_Notes,1,4)

The reason for this is that the comment field needs a sequencer in order 
to keep the lines in the correct order once the primary index key order 
has been satisfied.  Remember, after the index order, the records fall 
into natural order (ie, physical record number).  Since comments fields 
are commonly recycled from other deleted comments, these record numbers 
may fall in almost ANY order.  Thus the sequencer in the index key.

Rule of Thumb:  Whatever your parent database index key  use it for 
the LineEdit database key, adding only the SUBSTR(field,1,4).  It will 
all work fine after that.

Comparative Examples:

In the following table are the results of some comparisons I made between 
a LineEdit database, and a MEMO field.  The DEMO\LINEEDIT\BLITZ.PRG 
demo program is the program that I used to do this comparison.

It simply adds and deletes the SAME comments, in a (ahem) "random" order.

The "random" numbers are selected from a database of numbers 
(NUMBERS.DAT) that I entered at random on the keyboard.  This is so I 
could always run the exact same pattern several times with different 
comment field sizes. I simply bashed away at the keyboard number pad until 
I had a "roughly" equivalent number of each digit.  The results are good.  
Any given run of the BLITZ.PRG program will almost always report 
approximately 50/50 percent adds to deletes, maybe about 4% high on the 
ADD side.  See the program source for a fuller explanation of it's operation. 

In the test, I ran my LineEdit database with a comment field size of 80 
bytes, for 100, 500, 1000, and 10000 repetitions.  The program adds the 
exact same comment to both the LineEdit comment field and the MEMO field 
to ensure an accurate comparrison.  (Would one of you users please write 
me and tell me the correct way to spell "comparrison?").

The results:

                  80 BYTE           MEMOEDIT
               comment field:        Field

                   LineEdit         .DBT
       # Reps      File Size        File Size

        100         8k                30k
        500        16k               268k
       1000        16k               523k
      10000        16k             5,381k (Yeah!  5+Megabytes!)


What you will notice from these results is that the memo field behaves as 
it always does.  But with the LineEdit database, when the number of adds 
and deletes is approximately equal, the LineEdit file reaches a point 
of "equallibrium" where the number of available recyclable records is 
just sufficient to satisfy the needs of new comments being added.  At 
this point, the database, at any given point is about half and half 
actual comments and deleted records.

This principle does not change when you increase the size of the comment 
field.  For instance, in my tests, I also did the same test above with a 300 
byte comment field.  The LineEdit database reached equallibrium at 15K again. 

A comment requires about the same storage, no matter how you chop it up!
Since, unlike MEMO fields, no file space is wasted, the program acheives 
about the same efficiency.  The advantage to a larger comment field is SPEED. 

The 300 byte comment field stored and retrieved comments MUCH faster than
the 80 byte field because fewer records had to be retrieved to recreate the 
comment.  And in the case of this demo program, the 300 byte comment field 
was actually MORE efficient both in speed and storage requirements.

The most efficient size of the comment field depends much on your needs. 
Experimentation will reveal the best size for your needs.  Typically, 80 
bytes or more will do fine for "one-liner" comments.

NOTE:

CAUTION!!!

GET IT RIGHT THE FIRST TIME!

When determining the size of your comment base comment field, try as best as 
you can to get it right the first time.  Changing the structure of the 
comment base after it has been put to use is VERY complicated!  It can be 
done, but it is time consuming.  If in doubt, go with the HIGHER estimate for 
the size of the comment field.

Remember, the smaller the length of the comment field, the MORE records 
necessary to store a comment.  This means MORE time reading records.  This 
can become significant as time passes and the comment base reaches several 
thousand records.

There is a program "template" that you can use to resize a comment base - 
after it has been created and put to use - under DEMOS\UTILS\LE_RESIZ.


EXAMPLE:

USE First ALIAS SmoothStuff NEW SHARED
INDEX ON Da_Field TO First

USE second  ALIAS UserComments  NEW SHARED
INDEX ON Da_Field + substr(Notes,1,4) TO Second

SELECT SmoothStuff

k_LineEdPut('519-00-4349','UserComments','NOTES',

memoedit(k_LineEdGet('519-00-4349', 'UserComments', 'NOTES'),5,1,16,70))

Result: memoedit() receives a string from the function to edit and 
then rewrites it to the database.  Work area SmoothStuff is still active 
in the current work area when the function returns, and the record pointer 
of work area UserComments is where it was before the function was called.

The above example is a single-line example of how k_LineEdGet() can
be literally embedded in the k_LineEdPut() function call.  If it
is confusing, it is essentially the same thing as the following, with 
an intervening variable used: 

* 1. get the comment from the database
cString = k_LineEdGet('519-00-4349','UserComments','NOTES')

* 2. edit it - in this case with memoedit()
cString = memoedit(cString,5,1,16,70)

* 3. save it back to the database
k_LineEdPut('519-00-4349','UserComments','NOTES',cString)


On step 1, you could have added the k_LineEdSize() check:

if k_LineEdSize('519-00-4349','UserComments','NOTES') < 64000
    k_LineEdGet('519-00-4349','UserComments','NOTES')
endif

******************************************************************************/
#include "klipper.ch"

FUNCTION k_LineEdGet(cKey, cAlias, cField, cPassword)
LOCAL    cString := ""
LOCAL    nRec := recno()
LOCAL    nArea := select()

FIELD    Serno, Name, Comment

cPassword = iif((cPassword = NIL .or. empty(cPassword)),'DATAKEY',cPassword)

k_PushSet(_SET_EXACT,set(_SET_EXACT,FALSE))

BEGIN SEQUENCE

    if empty(cKey)
        //cString = NIL
        BREAK
    endif

    SELECT (cAlias)

    SEEK trim((cKey))

    if found()

        while &(indexkey(indexord())) = trim(cKey) .and. !eof()

            ****************************************************************
            * The first four bytes of the comment field are reserved       *
            * for the sequencer bytes which order the lines.  I had        *
            * horrible experiences with trying to keep a bunch of          *
            * text lines in order.  See docs.                              *
            ****************************************************************

            cString += substr(fieldget(fieldpos(cField)),5)

            SKIP

        end

    endif

    GOTO nRec

    if nArea != 0
        SELECT (nArea)
    end

    cString = trim(cString) ; k_Crypto(@cString,cPassword)

END SEQUENCE

set(_SET_EXACT,k_PopSet(_SET_EXACT))

RETURN(cString)


