/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_PrimaryKey( cIndexString ) --> cPrimaryKeyFieldName

PARAMETERS:

cIndexString : Index string ( get it with indexkey() )

SHORT:

Determine the primary index key field name.

DESCRIPTION:

k_PrimaryKey() returns the fieldname that is Primary (referenced first, or
highest in order in the key) in the specified index string.  The index
string is compared to the open database in the CURRENT workarea.  If no
database is open when k_PrimaryKey() is called, the function returns an
empty string.

When no field in the CURRENT database matches any field in the index (this
should NEVER happen - it indicates an improper use of the index), the
function also returns an empty string.

The function is useful when you want to SEEK a value and need to know
what field/column in the database it will be looking through.

NOTE:

k_PrimaryKey() does *NOT* change the case of the primary key field.  It
is returned exactly as it appears in the index key expression, which may
be of mixed case.  For comparisons, it is recommended that you UPPER()
both sides of the expression.  ie:

        if upper( fieldname(i) ) == upper( k_PrimaryKey(indexkey()) )
        .
        .
        .

The function assumes that you have less than 999 fields in your database
and that your index key does not exceed 999 bytes.  Once of these is
impossible, and the other tends to suggest that you ought to take a
class in data modelling or normalizing, so neither of these ought to be
a problem.

EXAMPLE:

    USE test ALIAS test NEW SHARED

    INDEX ON   Wow + Yikes + Yowza                        TO TEST1
    INDEX ON   Yipe + Duhhh + Booger                      TO TEST2
    INDEX ON   Me + You + andadognamedboo                 TO TEST3
    INDEX ON   Descend(The_Stairway) + upper(From_Heaven) TO TEST3
    

    SET INDEX TO test1, test2, test3
    SET ORDER TO 2


    ?  k_PrimaryKey( INDEXKEY() )
    
    Returns the primary field in the current index key.  ie, "Yipe"

    ?  k_PrimaryKey( INDEXKEY(3) )

    Returns the primary field of the third index. ie, "Me"

    ?  k_PrimaryKey( INDEXKEY(4) )

    Returns the primary field of the third index. ie, "The_Stairway"

******************************************************************************/

FUNCTION k_PrimaryKey( cIndexString )

LOCAL    cPrimaryKeyField := ""

cPrimaryKeyField = k_Extract(k_FieldString(cIndexString),",",1)

RETURN( cPrimaryKeyField )




//LOCAL    nMinFieldNum   := 9999
//LOCAL    nMinFieldAt    := 9999
//LOCAL    i
//
//for i = 1 to fcount()
//
//    if upper( fieldname(i) ) $ upper( k_FieldString( cIndexString) )
//
//        *-- fieldname appears in the index string.  make sure it (the fieldname)
//        *-- appears as a whole word.  ie, I do not want PDAFERC->FERC to key on
//        *-- the "FERC" that appears in the alias portion (or the function call
//        *-- portion, or whatever else happens to be there.)
//
//        if at( upper(fieldname(i)), upper(cIndexString) ) < nMinFieldAt
//
//            nMinFieldAt = at( upper(fieldname(i)), upper(cIndexString) )
//            nMinFieldNum = i
//
//        endif
//
//    endif
//
//next
//
//// If nMinFieldNum = 9999, then for whatever reason, the index key
//// contains *NO* fields from the database!!!
//
//if nMinFieldNum != 9999
//    cPrimaryKeyField = upper(fieldname(nMinFieldNum))
//endif

