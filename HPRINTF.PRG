/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_HPrintf( cFont_Id, nF_Val ) --> lPrinterStatus

PARAMETERS:

cFont_Id  type font, orientation, or reset code:

    "courier"
    "line"    usually 16 (condensed)
    "port"
    "land"
    "lpi"     usually 6
    "lpp"     usually 66
    "left"    usually 0
    "right"
    "top"     usually 0
    "perf"    usually on
    "copies"  usually 1
    "reset"

nF_Val    Numeric value for Font_ID's that require a numeric 
parameter:

    16.6 For Line Printer
    10.0 For Courier

SHORT:

Set various Hewlett Packard LaserJet font options.

DESCRIPTION:

k_HPrintf() contains several printer setup capabilities for the Hewlett 
Packard Laserjet Series II.

NOTE:

This function will be NOT be in future versions of the KLIPPER Library. It 
will be replaced with another, more flexible function.  Backward 
compatibility or at least ease of translation will be considered in designing 
the new function.  Stay tuned.

EXAMPLE:

k_HPrintf('line')      // sets laserjet to compress print
k_HPrintf('courier')   // sets printer to 10 CPI courier font
k_HPrintf('Reset')     // resets laserjet to default power-on values
k_HPrintf('lpi',8)     // sets the printer to 8 lines per inch

******************************************************************************/

FUNCTION k_HPrintf( cFont_Id, nF_Val )


    if cFont_Id = 'line'
        nF_Val = iif(valtype(nF_Val) = 'U',16.6,nF_Val)
    endif

    if cFont_Id = 'lpi'
        nF_Val = iif(valtype(nF_Val) = 'U',6,nF_Val)
    endif

    if cFont_Id = 'left'
        nF_Val = iif(valtype(nF_Val) = 'U',0,nF_Val)
    endif

    if cFont_Id = 'right'
        nF_Val = iif(valtype(nF_Val) = 'U',90,nF_Val)
    endif

    if cFont_Id = 'top'
        nF_Val = iif(valtype(nF_Val) = 'U',0,nF_Val)
    endif

    if cFont_Id = 'perf'
        nF_Val = iif(valtype(nF_Val) = 'U',1,nF_Val)
    endif

    if cFont_Id = 'lpp'
        nF_Val = iif(valtype(nF_Val) = 'U',66,nF_Val)
    endif

    if cFont_Id = 'copies' && (normally one)
        nF_Val = iif(valtype(nF_Val) = 'U',1,nF_Val)
    endif

    k_ToPrn()

    do case

        case lower(cFont_Id) = 'courier'
            k_LPrint(chr(27)+'(s3t0b10H')

        case lower(cFont_Id) = 'line'  && usually 16 (condensed)
            k_LPrint(chr(27)+'(s0t0b'+ltrim(str(nF_Val))+'H')

        case lower(cFont_Id) = 'port'
            k_LPrint(chr(27)+'&l0O')

        case lower(cFont_Id) = 'land'
            k_LPrint(chr(27)+'&l1O')

        case lower(cFont_Id) = 'lpi'  && usually 6
            k_LPrint(chr(27)+'&l'+ltrim(str(nF_Val))+'D')

        case lower(cFont_Id) = 'lpp'  && usually 66
            k_LPrint(chr(27)+'&l'+ltrim(str(nF_Val))+'F')

        case lower(cFont_Id) = 'left' && usually 0
            k_LPrint(chr(27)+'&a'+ltrim(str(nF_Val))+'L')

        case lower(cFont_Id) = 'right'
            k_LPrint(chr(27)+'&a'+ltrim(str(nF_Val))+'M')

        case lower(cFont_Id) = 'top' && usually 0
            k_LPrint(chr(27)+'&l'+ltrim(str(nF_Val))+'E')

        case lower(cFont_Id) = 'perf' && usually on
            k_LPrint(chr(27)+'&l'+ltrim(str(nF_Val))+'L')

        case lower(cFont_Id) = 'copies' && usually one
            k_LPrint(chr(27)+'&l'+ltrim(str(nF_Val))+'X')

        case lower(cFont_Id) = 'reset'
            k_LPrint(chr(27)+'E')

    endcase


RETURN(isprinter())

