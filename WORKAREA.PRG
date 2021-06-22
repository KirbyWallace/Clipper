/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_SaveWorkAreas( cSetName ) --> NIL

PARAMETERS:

cSetName: Name assigned to set for later reference to RestoreWorkAreas()

SHORT:

Save status of all databases and indexes.

DESCRIPTION:

k_SaveWorkAreas() / k_RestoreWorkAreas() are a pair of functions that save
the status of databases, indexes, record pointers and (soon) database
relations.  Each "status" is saved under a "named set" and can be restored
by using that same name with k_RestoreWorkAreas().

Since the functions save a "snapshot" of the databases and their states,
these functions can be stacked up pretty easily, with several calls made
to _Save... before any call to _Restore...  Also, it is possible to
manually CREATE a database status and _Restore... it, thereby creating
a status from scratch rather than from previous status.


NOTE:

There are limitations:

k_SaveWorkAreas(), because of a particularly annoying Clipper habit, cannot
save and restore workarea RELATIONS.  If you have relations set, you must
restore them yourself if you change them.

You cannot CLOSE the databases or indexes after saving the work area and then
restore later.  _Save/k_RestoreWorkAreas() will only reselect original states,
not RECREATE THEM.

You may SELECT other work areas, you may SET ORDER TO different indexes
and you may SEEK/GOTO different record numbers.  You may not CLOSE/USE
new areas, or INDEX ON/SET INDEX new indexes.  Anything that closes
any file, or opens new ones in an existing area cannot be restored later.

EXAMPLE:


    SIMPLIFIED


        k_SaveWorkAreas( "AreaName" )

        Select...
        Change Order....
        Move record pointers...
        etc...

        k_RestoreWorkAreas( "AreaName" )

    All is returned to the original state as it existed when k_SaveWorkAreas()
    was called.


******************************************************************************/


//
// stuff dealing with relations has been commented out because of the
// annoying habit of clipper to insist on jumping directly back
// to the line of code where a relation was set every time it moves
// the record pointer.  Since these states are saved in an array, and
// referenced by a loop counter that is no longer in scope when the
// function terminates, they are not accessible.
//

STATIC   axWorkStack := {}
STATIC   axWorkArea  := {}
STATIC   axRelations := {}

FUNCTION k_SaveWorkAreas( cSetName )

LOCAL    nOldArea := select(), i, j, lAddNew

axWorkArea  := {}                   //  { alias(), recno(), indexord(), {acRelations} }
axRelations := {}                   //  { dbRelation(), dbRSelect() }

if !empty(cSetname)

    cSetname = upper(cSetName)

    for i = 1 to 25

        if !empty(alias(i))

            select (i)

            axRelations = {}

            aadd( axWorkArea, { "", 0, 0,{ } } )

            axWorkArea[i,1] = alias()
            axWorkArea[i,2] = recno()
            axWorkArea[i,3] = indexord()

            for j = 1 to 25

                if !empty(dbRelation(j))
                    aadd(axRelations,{"",0})
                    axRelations[len(axRelations),1] = dbRelation(j)
                    axRelations[len(axRelations),2] = dbRSelect(j)
                else
                    EXIT
                endif

            next

            axWorkArea[i,4] = axRelations

        endif

    next

    SELECT (nOldArea)

    lAddNew = .T.

    for i = 1 to len(axWorkStack)

        if axWorkStack[i,1] = cSetName
            // replace existing set
            axWorkStack[i,2] = axWorkArea
            axWorkStack[i,3] = nOldArea
            lAddNew = .F.
            EXIT
        endif

    next

    if lAddNew

        // add a new set by this name
        aadd(axWorkStack, { "",{},0 } )
        axWorkStack[len(axWorkStack),1] = cSetName
        axWorkStack[len(axWorkStack),2] = axWorkArea
        axWorkStack[len(axWorkStack),3] = nOldArea

    endif

endif

RETURN(NIL)


/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            


FUNCTION:

k_RestoreWorkAreas( cSetName ) --> NIL

PARAMETERS:

cSetName: Name assigned to set by k_SaveWorkAreas()

SHORT:

Restore status of all databases and indexes in set named by cSetName.


DESCRIPTION:

See k_SaveWorkAreas() for discussion.

NOTE:

EXAMPLE:

******************************************************************************/

FUNCTION k_RestoreWorkAreas( cSetName )

LOCAL    i, j, k
LOCAL    axRetVal := {}


axWorkArea  := {}                   //  { alias(), recno(), indexord(), {acRelations} }
axRelations := {}                   //  { dbRelation(), dbRSelect() }

cSetname = upper(cSetName)

if !empty( cSetName )

    for i = 1 to len( axWorkStack )

        if axWorkStack[i,1] == cSetName

            // got the big picture...

            // REPEATING GROUPS UNDER THE DASH-LINE...
            //
            // --------------------------------------------------------------------     <---- axWorkStack[]
            //             ------------------------------------------------------       <---- axWorkArea[]
            //                                            ---------------------         <---- axRelations[]
            // { cSetName, { cAlias, nRecno, nIndexOrder, { cFieldName, nArea } } }

            axWorkArea = axWorkStack[i,2]

            for j = 1 to len( axWorkArea )

                dbSelectArea( axWorkArea[j,1] )
                dbGoTo( axWorkArea[j,2] )
                dbSetOrder( axWorkArea[j,3] )

                // due to clipper relation anomolies, the restore relations bit is commented out.
                // it tries to set a relation based upon the array - referenced by "k" which is
                // gone (out of scope) when the function terminates.
                //
                // axRelations = axWorkArea[j,4]
                //
                // for k = 1 to len(axRelations)
                //     dbSetRelation( alias(axRelations[k,2]), { || (axRelations[k,1]) } , (axRelations[k,1]) )
                //     //SET RELATION TO (axRelations[k,1])  INTO (alias(axRelations[k,2]))
                // next

            next

            // got our set, restore the original current work area and get out now rather than look at the rest...

            SELECT ( axWorkStack[i,3] )

            EXIT

        endif

    next

endif


RETURN(NIL)

