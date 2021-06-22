/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_Timer(nChannel, nAction, nOptVal) --> nTimerData

PARAMETERS:

nChannel: Timer Channel Number (1-16 DEAFAULT: 1)
nAction : Timer Action:

        KT_RESET   Reset specified timer to ZERO
        KT_START   Start specified timer
        KT_STOP    Stop specified timer
        KT_READ    Read specified timer
        KT_SET_TO  Set Channel: <nChannel> to the value of channel <nOptVal>
        KT_SWITCH  Stop other channels & start channel nChannel
        KT_ASSIGN  Set specified timer to a specific value.

nOptVal : Numeric setting for SET action KT_SET_TO.
          (See KT_SET_TO)

SHORT:

16 channel "timer & stopwatch."

DESCRIPTION:

k_Timer() contains 16 individual timers (assigned to "channels").

KT_RESET resets a timer channel to ZERO.  Any previous time on that channel 
is lost.

KT_START starts the specified nChannel timer.  Time accumulates until a 
KT_STOP, or KT_SWITCH is issued. 

KT_STOP stops a timer channel, but does not reset it's value. It remains 
stopped until a KT_START, or a KT_SWITCH to that channel is issued. 

KT_READ reads the time on the specified timer channel.  If the timer is 
running, it continues to run after the KT_READ.  If it is stopped, it remains 
stopped.

KT_SET_TO causes the specified timer channel to be set to the time
currently in the timer channel specified in nOptVal.

KT_SWITCH causes all timers to be stopped, and the specified channel to be 
started.

KT_ASSIGN allows you to set a timer to a specific value.  Thus, a timer could 
continue to accumulate time through several separate runs of an application 
by saving the timer contents (retrieved by KT_READ) and, when the application 
is run again, setting the timer to it's previous value.  KT_ASSIGN sets the 
ELAPSED TIME to the specified value and clears the START and STOP time 
(effectively STOPPING the timer).  Thus, when you KT_ASSIGN a timer channel, 
you must also start it (if desired).


Begin by KT_RESETing the desired channel to ZERO.  Then start and stop the 
timer as necessary.  At any point, you can obtain a reading of any given 
timer by KT_READing it. 

You may also KT_SET_TO one timer to the current time on another channel. This 
will allow you to keep one overall time reading by way of multiple channels.

All 16 timers are intially assigned a ZERO time.

NOTE:


EXAMPLE:

k_Timer( n, KT_ASSIGN, k_Timer(i,KT_READ) )  // set timer n to timer i

  - is the same as -

k_Timer( n, KT_SET_TO, i )                   // ditto


See DEMOS\TIMER\MAIN.PRG for example.

******************************************************************************/

#include "klipper.ch"
#include "inkey.ch"
#include "set.ch"

#define T_ELAPSED   1
#define T_START     2
#define T_STOP      3

#define IS_STOPPED  timer[nChannel,T_START]=timer[nChannel,T_STOP]
#define IS_RUNNING  timer[nChannel,T_START]!=timer[nChannel,T_STOP]

FUNCTION k_Timer(nChannel,nAction,nOptVal)

STATIC   timer := {{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0}, ;
                   {0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0},{0,0,0}}

// 1 total elapsed time on channel
// 2 seconds when channel started
// 3 seconds when channel stopped


LOCAL    nRetVal := 0
LOCAL    i

do case

    case nAction = KT_RESET

        timer[nChannel,T_ELAPSED] = 0
        timer[nChannel,T_START]   = 0
        timer[nChannel,T_STOP]    = 0

    case nAction = KT_START

        if IS_STOPPED
            timer[nChannel,T_START] = k_LongSeconds()
        endif

    case nAction = KT_STOP

        if IS_RUNNING
            timer[nChannel,T_STOP]     = k_LongSeconds()
            timer[nChannel,T_ELAPSED] += k_LongSeconds()-timer[nChannel,T_START]
            timer[nChannel,T_START]    = timer[nChannel,T_STOP]
        endif

    case nAction = KT_READ

        // reads current time but alters no settings (continues to accumulate time)

        if IS_STOPPED
            // if timer is stopped, START and STOP will be the same, indicating a stopped timer
            // the timer value is in T_ELAPSED

            nRetVal = timer[nChannel,T_ELAPSED]

        else
            // if start != stop, then then the timer is currently running and we need to add
            // the time accumulated since last "stop"

            nRetVal = timer[nChannel,T_ELAPSED]+(k_LongSeconds()-timer[nChannel,T_START])

        endif


    case nAction = KT_SET_TO

        timer[nChannel,T_ELAPSED] = timer[nOptVal,T_ELAPSED]
        timer[nChannel,T_START]   = timer[nOptVal,T_START]
        timer[nChannel,T_STOP]    = timer[nOptVal,T_STOP]

    case nAction = KT_SWITCH

        // stop all other running timers other than nChannel (starting nChannel at the same time)

        for i = 1 to 16

            // this is the same thing as IS_RUNNING, using "i" vice "nChannel"

            if i != nChannel

                if timer[i,T_START]!=timer[i,T_STOP]

                    timer[i,T_STOP]     = k_LongSeconds()
                    timer[i,T_ELAPSED] += k_LongSeconds()-timer[i,T_START]
                    timer[i,T_START]    = timer[i,T_STOP]

                endif

            else

                // start specified timer

                timer[nChannel,T_START] = k_LongSeconds()

            endif

        next

    case nAction = KT_ASSIGN

        timer[nChannel,T_ELAPSED] = nOptVal
        timer[nChannel,T_START]   = 0
        timer[nChannel,T_STOP]    = 0

endcase

RETURN(nRetVal)

