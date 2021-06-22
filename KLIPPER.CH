/*
    KLIPPER.LIB Header File

    For use with applications with KLIPPER.LIB functions

*/


//#ifndef GLOBAL
//    #define GLOBAL                  PUBLIC
//#endif

#ifndef K_BIN
    #define K_BIN                    2
#endif

#ifndef K_OCT
    #define K_OCT                    8
#endif

#ifndef K_DEC
    #define K_DEC                    10
#endif

#ifndef K_HEX
    #define K_HEX                    16
#endif





#ifndef SCAT_ATTR
    #define SCAT_ATTR                1
#endif

#ifndef SCAT_NAME
    #define SCAT_NAME                2
#endif

#ifndef SCAT_DATA
    #define SCAT_DATA                3
#endif

#ifndef SCAT_SRCE
    #define SCAT_SRCE                4
#endif


#ifndef KT_RESET
    #define KT_RESET                 0
#endif

#ifndef KT_START
    #define KT_START                 1
#endif

#ifndef KT_STOP
    #define KT_STOP                  2
#endif

#ifndef KT_READ
    #define KT_READ                  3
#endif

#ifndef KT_SET_TO
    #define KT_SET_TO                4
#endif

#ifndef KT_SWITCH
    #define KT_SWITCH                5
#endif

#ifndef KT_ASSIGN
    #define KT_ASSIGN                6
#endif

#ifndef KCRC_GENERATE
    #define KCRC_GENERATE           0
#endif

#ifndef KCRC_TEST
    #define KCRC_TEST               1
#endif

#ifndef KCRC_EXTRACT
    #define KCRC_EXTRACT            2
#endif

#ifndef KFP_NEXT
    #define KFP_NEXT                1
#endif

#ifndef KFP_PREV
    #define KFP_PREV                2
#endif

#ifndef NULL
    #define NULL                  chr(0)
#endif

#ifndef CRLF
    #define  CRLF                 chr(13)+chr(10)
#endif

#ifndef FLUSHKEYS
    #define  FLUSHKEYS            __KeyBoard("")
#endif

#ifndef BOXSINGLE
    #define  BOXSINGLE            1
#endif

#ifndef BOXDOUBLESIDE
    #define  BOXDOUBLESIDE        2
#endif

#ifndef BOXDOUBLETOP
    #define  BOXDOUBLETOP         3
#endif

#ifndef BOXDOUBLE
    #define  BOXDOUBLE            4
#endif

#ifndef BOXTHICK
    #define  BOXTHICK             5
#endif

#ifndef BOXNONE
    #define  BOXNONE              6
#endif

#ifndef LABELBOTTOM
    #define  LABELBOTTOM          1
#endif

#ifndef LABEL_ARROWS_RIGHT
    #define  LABEL_ARROWS_RIGHT   4
#endif

#ifndef LABEL_ARROWS_LEFT
    #define  LABEL_ARROWS_LEFT    5
#endif

#ifndef BORDER
    #define BORDER                .T.
#endif

#ifndef NOBORDER
    #define NOBORDER              .F.
#endif

#ifndef ALL_RECORDS
    #define ALL_RECORDS   !EOF()
#endif

#ifndef NO_RECORDS
    #define NO_RECORDS    EOF()
#endif

#ifndef NEXTREC
    #define NEXTREC       SKIP
#endif

#ifndef NO_INTERRUPT
    #define NO_INTERRUPT  .t.
#endif

#ifndef NO_CLOCK
    #define NO_CLOCK      .t.
#endif

#ifndef AND
    #define  AND           .and.
#endif

#ifndef OR
    #define  OR            .or.
#endif

#ifndef CLOSEAREA
    #define  CLOSEAREA     dbCloseArea()
#endif

#ifndef CLOSEINDEXES
    #define  CLOSEINDEXES  dbClearIndex()
#endif

#ifndef TRUE
    #define   TRUE         .t.
#endif

#ifndef FALSE
    #define   FALSE        .f.
#endif

#ifndef END_OF_FILE
    #define   END_OF_FILE  eof()
#endif

#ifndef LF
    #define   LF           chr(13)+chr(10)
#endif


// SETCURS.CH addition

#ifndef SC_BLOCK
    #define SC_BLOCK        3  // They call this SPECIAL1 in the standard SETCURS.CH I prefer BLOCK
#endif

#ifndef KFO_TRUNC
    #define KFO_TRUNC      3
#endif

#ifndef KFO_OVERWRITE
    #define KFO_OVERWRITE  2
#endif

#ifndef KFO_APPEND
    #define KFO_APPEND     1
#endif

#ifndef KFO_FAIL
    #define KFO_FAIL         -1
#endif

#ifndef K_TORF
    #define K_TORF    1
#endif

#ifndef K_POS
    #define K_POS     2
#endif

#ifndef K_EXTRACT
    #define K_EXTRACT 3
#endif

#ifndef AS
    #define  AS       :=
#endif

#ifndef TYPE_STRING
    #define  TYPE_STRING   ""
#endif

#ifndef TYPE_INTEGER
    #define  TYPE_INTEGER  0
#endif

#ifndef TYPE_FLOAT
    #define  TYPE_FLOAT    0.00
#endif

#ifndef TYPE_DATE
    #define  TYPE_DATE     ctod("")
#endif

#ifndef TYPE_LOGICAL
    #define  TYPE_LOGICAL  FALSE
#endif

#ifndef TYPE_ARRAY
    #define  TYPE_ARRAY  {}
#endif

#ifndef TYPE_VARIABLE
    #define  TYPE_VARIABLE  TYPE_STRING
#endif

#ifndef STANDARD_FORE
    #define STANDARD_FORE  1
#endif

#ifndef STANDARD_BACK
    #define STANDARD_BACK  2
#endif

#ifndef ENHANCED_FORE
    #define ENHANCED_FORE  3
#endif

#ifndef ENHANCED_BACK
    #define ENHANCED_BACK  4
#endif

#ifndef UNSELECT_FORE
    #define UNSELECT_FORE  5
#endif

#ifndef UNSELECT_BACK
    #define UNSELECT_BACK  6
#endif


// color defines for COLOROF()
// not to be confused with the above,
// used for _ColorSay(), _Color2Num(),
// _ReColor() etc...

#ifndef STANDARD_COLOR
    #define  STANDARD_COLOR   1
#endif

#ifndef ENHANCED_COLOR
    #define  ENHANCED_COLOR   2
#endif

#ifndef BORDER_COLOR
    #define  BORDER_COLOR     3
#endif

#ifndef BACKGROUND_COLOR
    #define  BACKGROUND_COLOR 4
#endif

#ifndef UNSELECTED_COLOR
    #define  UNSELECTED_COLOR 5
#endif

// k_Parse()

#ifndef PARSE_FPATH
    #define PARSE_FPATH    1
#endif

#ifndef PARSE_FNAME
    #define PARSE_FNAME    2
#endif

#ifndef PARSE_FEXT
    #define PARSE_FEXT     3
#endif


