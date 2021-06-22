/******************************************************************************
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_ExeName()

PARAMETERS:

none

SHORT:

Return current application .EXE name and path.

DESCRIPTION:

k_ExeName() returns the current application .EXE name and path.

NOTE:

This function shamelessly stolen from the public domain function
_PROGRAM() by Frank Imburgio, and slightly modified.  Thanks Frank!

EXAMPLE:

******************************************************************************/

#include "extend.h"

#define MK_FP(seg,ofs)  ((void far *) (((unsigned long)(seg) << 16) | (unsigned)(ofs)))
#define FP_OFF(fp)	((unsigned)(fp))
#define FP_SEG(fp)	((unsigned)((unsigned long)(fp) >> 16))

// Progam segment pointer holds all PATH stuff, including program name
// _psp is a global under both Turbo and Microsoft C

extern  unsigned    _psp;

CLIPPER k_ExeName()
{
    char far *Env;
    unsigned far *EnvSeg;

    EnvSeg =  MK_FP(_psp,0x2c);
    Env    =  MK_FP(*EnvSeg,0x00);

    while(1) {

        if (*Env++==0)
            if (*Env++==0)
                break;
   }

   Env++;
   Env++;

   _retc(Env);

   return;
}

