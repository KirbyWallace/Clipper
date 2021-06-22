@echo off

REM Remember to create "liberr" and "comperr" directories from the
REM current directory before using these batch files.  Either that
REM or get rid of the " > liberr\%1.err" bits.

ECHO *******************************************************************************
ECHO * %1 COMPILE/LIBR kf95 LIB
ECHO *******************************************************************************

CLIPPER %1 -m -w -n -b /tc:\temp > comperr\%1.err

IF errorlevel 1 GOTO comperr

LIB kf95 -+%1,  listfile.txt; > liberr\%1.err
IF errorlevel 1 GOTO liberr

GOTO end

REM -------------------------------------------------------------
REM STOP is a batch file which is run only so it won't return.
REM UPDATE is CALLed by COMPALL.BAT repeatedly.  If there is a
REM compile error, or a lib error, I want to stop and that means
REM calling a batch from which we won't return.
REM -------------------------------------------------------------

:COMPERR
 ECHO COMPILE ERROR: %1
 ECHO BATCH PROCESS HALTED... BREAK or CONTINUE...
 PAUSE

:LIBERR
 ECHO LIB ERROR: %1
 PAUSE

:END
ECHO %1 Compile Done...
ECHO þ
dir comperr\%1.err | FIND "-"
ECHO þ
