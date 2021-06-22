/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_XLog( cWhat, cWhere ) --> nAppendStatus

PARAMETERS:

cWhat   : Text String to Log
cWhere  : Log File Name (Default = EXEC_LOG.DAT

SHORT:

Log a line of text to a system log file.

DESCRIPTION:

k_XLog() accepts a string and logs it to a database. If the specified 
database does not exist it is created with the following structure: 

LOG_WHAT   Char  255

It has only one field as noted above.  Each line is date / time stamped as 
it comes in and the text is added to that. 

The log file does not have to be limited to this structure. You may create 
the file before hand and, so long as it at least has a character field (of 
any length) named LOG_WHAT, this function will work fine.

NOTE:

This function may be called at ANY time, while ANY other files are open.  If 
any database files are open when the call is made, the EXEC_LOG.DAT file is 
opened in an UNUSED area, the transaction takes place, the file is closed and 
the area that was current before the call was made is restored to current 
status.

This function is extremely useful for recording program activity and for 
recording important events and who performed them (in a network environment).

RETURNS:  0 Error: Undefined Error
         -1 Error: Area in Use
          1 Error: File Use Error

NOTE: WORK AREA 70 IS RESERVED FOR THIS FUNCTION (for the time being.  I'm 
due to get around to this function soon, and will be bringing it out of the 
Summer '87 dark ages.)


EXAMPLE:

Assume EXEC_LOG.DAT does not exist:

k_XLog('User BETTYG Logged On')

Result: The EXEC_LOG.DAT file is created with the default structure 
(LOG_WHAT, C, 100), a record is appended and replaced with a date/time 
stamp, and the text "User BETTYG Logged On".

******************************************************************************/


FUNCTION k_XLog( cWhat, cWhere )

MEMVAR _xLogPath

LOCAL    Ret_Val   := 0 // initialize to error, change if success
LOCAL    Old_Area  := Select()
LOCAL    _xlogfile := ''

if cWhere == NIL
    cWhere = 'EXEC_LOG.DAT'
else
    if valtype(cWhere) != 'C'
        cWhere = 'EXEC_LOG.DAT'
    //else
        //cWhere = alltrim(substr(cWhere+space(8),1,8))+'.DAT'
    endif
endif

if type('_xLogPath') = 'U'
    PUBLIC _xLogPath := ''
else
    if type('_xLogPath') != 'C'
        PUBLIC _xLogPath := ''
    else
        _xLogPath = alltrim(_xLogPath)

        if right(_xLogPath,1) != '\' .and. !empty(_xLogPath) // empty would make \xxx out of everything
            _xLogPath += '\'
        endif

    endif
endif

_xLogFile = _xLogPath+cWhere

if pcount() = 0
    cWhat = '?'
endif

BEGIN SEQUENCE

    // area 70 is reserved for this operation

    Old_Area = select()

    if Old_Area = 70
        tone(2000,1)
        tone(3000,1)
        tone(4000,1)
        tone(2000,1)
        tone(6000,1)
        Ret_Val = -1
        BREAK
    endif

    select 70

    if !file(_xLogFile)


        create temp
        append blank
        replace field_name with 'log_what', ;
                field_type with 'C', ;
                field_len  with 255, ;
                field_dec with 0

        CREATE &_xLogFile FROM temp
        use
        erase temp.dbf

    endif

    select 70
    k_SUse(_xLogFile,'EXECLOG')

    if neterr()
        // if file use conflict, Log entry cannot be made
        Ret_Val = 1
        BREAK
    endif

    append blank
    REPLACE Log_What with ( (dtos(date())+strtran(time(),':',''))+' '+cWhat )
    use

    Ret_Val = 0

END SEQUENCE

select (Old_Area)

RETURN(Ret_Val)


