/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_IndexFields() --> acFieldList

PARAMETERS:

None

SHORT:

Build an array containing field names referenced in the current index.

DESCRIPTION:

k_IndexFields() parses out field names from the index key expression of 
the current index of the current database in the current workarea, and 
returns an array containing one field name per element.

k_IndexFields() returns an empty array when an index expression contains 
no field names (however that came to be), or if there was no database open, 
or no index open, in the current area.

NOTE:



EXAMPLE:

USE Danger.DBF ALIAS Danger SHARED NEW
INDEX ON Weapon+Anti_Tank+Mine TO Danger

acMineFields = k_IndexFields()

Result: acMineFields[] contains:

    acMineFields[1] == 'WEAPON'
    acMineFields[2] == 'ANTI_TANK'
    acMineFields[3] == 'MINE'

******************************************************************************/

FUNCTION k_IndexFields()
LOCAL    acFields := {}
LOCAL    i

for i = 1 to fcount()

    if field(i) $ upper(indexkey(indexord()))
        aadd(acFields,field(i))
    endif

next

RETURN(acFields)

