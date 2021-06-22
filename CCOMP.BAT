@echo off

REM Remember to create "liberr" and "comperr" directories from the
REM current directory before using these batch files.  Either that
REM or get rid of the " > liberr\%1.err" bits.

REM   This command line has all commandline params needed
REM   for Clipper->C compiles

CL /c /AL /FPa /Gs /Oalt /Zl %1.c > comperr\%1.err

IF errorlevel 1 GOTO comperr

LIB kf95c -+%1,  listfile.txt; > liberr\%1.err

IF errorlevel 1 GOTO liberr

GOTO END

:COMPERR
ECHO C COMPILER ERROR %1
PAUSE
GOTO END

:LIBERR
ECHO LIB ERROR %1
PAUSE


GOTO end

:END

REM Somehow or another, the process leaves a turd: a zero-len file
REM called "C"  On CompuServe, try GO FIGURE.

DEL C > NUL

