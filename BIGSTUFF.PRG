/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_BigStuff(cString, acFindText )

PARAMETERS:

cString    : String to find and replce characters in.
acFindText : Array of multiple find and replace texts.

SHORT:

Find and replace multiple occurances of multiple strings.

DESCRIPTION:

k_BigStuff() uses an array of FIND/REPLACE texts and finds and replaces all
of them in the given string.


//                FIND            REPLACE
//                -----------------------

acBigStuff[1] = {"Cat"     ,     "Wife"          }
acBigStuff[2] = {"Frog"    ,     "Two-year old"  }
acBigStuff[3] = {"Little"  ,     "Big"           }
acBigStuff[.] = {.               .               }
acBigStuff[.] = {.               .               }
acBigStuff[.] = {.               .               }
acBigStuff[n] = {"Species" ,     "Britches"      }

t := k_BigStuff("I have a cat, and a frog.  Both are pretty little for
                 their species.", acBigStuff )

Result:

 "t" contains "I have a Wife, and a Two-year old.  Both are pretty big for
               their britches."


NOTE:

Be aware that as replacements are made from the array of find/replace pairs,
the text that subsequent replaces are going to work on will be changed and
may include more or fewer instances of the find text than they would have
at the start:


    "aabbccddeeffgg"

    Say we want to change "a's to b's," all "b's to c's", etc etc on through
    "g's to h's."


    Look at the EXAMPLE:


EXAMPLE:

**************************************************************************

cString := "aabbccddeeffgg"

cReps   := { {"a","b"},{"b","c"},{"c","d"},{"d","e"},{"e","f"},{"f","g"} }

**************************************************************************


 The result will not be:                    but rather:
--------------------------        -----------------------------
Original :  aabbccddeeffgg        Original :  aabbccddeeffgg

Result   :  bbccddeeffgghh        Result   :  hhhhhhhhhhhhhh



Look at it in terms of individual steps.    aabbccddeeffgg
                                            bbbbccddeeffgg
                                            ccccccddeeffgg
                                            ddddddddeeffgg
                                            eeeeeeeeeeffgg
                                            ffffffffffffgg
                                            gggggggggggggg
                                            hhhhhhhhhhhhhh

Another good example of this:

cString2 := "This is the End of the line!"
cReps2   := { {"This","Dis"},{"is","be"},{"the","de"},{"of","o'"} }

    You would expect:

"This is the end of the line!" ---> "Dis be de end o' de line!"

    What you get is:

"This is the end of the line!" ---> "Dbe be de end o' de line!"

Remember, we asked it to replace "is" with "be" - thus "Dis" became "Dbe."


One last Example:

cString2 := "THIS IS THE END OF THE LINE!"
cReps2   := { {"This","Dis"},{"is","be"},{"the","de"},{"of","o'"} }


? cString2
? k_BigStuff(cString2, cReps2 )
?
?
? cString2
? k_BigStuff(cString2, cReps2, .T.)   // <----- CASE SENSITIVE REPLACE!

Result:


THIS IS THE END OF THE LINE!
Dbe be de END o' de LINE!


THIS IS THE END OF THE LINE!
THIS IS THE END OF THE LINE!


In the first case, the search and replace was case INSENSITIVE. It matched
and replaced everything it could.  That's why "END" and "LINE" are still
Upper case - nothing matched them and they were left untouched.

But in the second case, the case SENSITIVE find/replace, NOTHING matched
because the string was all caps, and we asked it to look for lower case
and mixed case words, and told it to consider UPPER CASE different from
lower case.

******************************************************************************/

#define FIND_TEXT     acReplacements[i,1]
#define REPLACE_TEXT  acReplacements[i,2]

FUNCTION k_BigStuff( cString, acReplacements, lCaseSense )

LOCAL i

lCaseSense = iif( lCaseSense = NIL, .F., lCaseSense )

for i = 1 to len(acReplacements)

    if lCaseSense

        cString = strtran( cString, FIND_TEXT, REPLACE_TEXT )

    else

        while (upper(FIND_TEXT) $ upper(cString))
            cString = stuff(cString,at(upper(FIND_TEXT),upper(cString)),len(FIND_TEXT),REPLACE_TEXT)
        end

    endif

next i

RETURN(cString)

