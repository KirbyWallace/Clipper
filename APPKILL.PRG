/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_AppKill(cKillFileName) --> NIL

PARAMETERS:

cKillFileName : File to display as application terminates

SHORT:

Prevent an application from being run, or stop one that is already running.

DESCRIPTION:

k_AppKill() is run from k_Prepare().  It takes a single parameter indicating 
the file name of a file whose presence will trigger the termination of an 
application.

The default file name is @DISABLE.!!!  If you use the default name, you 
needn't specify any parameter to the function.

When the function is called, it checks the current directory for a file 
called @DISABLE.!!! (or the file name in cKillFileName, if specified).  This 
file serves two related purposes: (1) to cause the application running to be 
terminated, and (2) to hold the contents of a message that is to be displayed 
as the system is shutting down.  If the file exists, the program is 
terminated.  If the file exists but is empty, then no display is given other 
than "Press any key..." and the application simply returns to a command line 
(or whatever called it).  If the file exists and contains data, that data is 
displayed before the "press any key" message.

By the judicial scattering around of this function call in key places (such 
as in menu loops and before and after edit screens), a system administrator 
may contain complete control of the application at all times.  When updates 
or other maintenance need to be performed, users can be notified that the 
application will be unavailable in X minutes, and then you simply copy the 
disable file to the applications working directory.  All users applications 
will immediately be terminated without terminating their network connection.  
They all receive the message that is contained in the disable file (remember 
the default name of this file is "@DISABLE.!!!")

NOTE:



EXAMPLE:

// A file called "KILL_ME.TXT" exists in the current directory.  It's
// contents are:
//
// THE SYSTEM ADMINISTRATOR HAS TEMPORARILY DISABLED THIS APPLICATION
// SO THAT EMERGENCY MAINTENANCE CAN BE PERFORMED.  WE APOLOGIZE FOR 
// THIS INCONVENIENCE.


k_Terminate()

Result: The application terminates.  The default file name of @DISABLE.!!! is 
assumed.

k_Terminate("NOEXIST.TXT")

Result: Since NOEXIST.TXT doesn't exist, the effect is exactly the same as 
the previous call.

k_Terminate("KILL_ME.TXT")

Result: The application is terminated and the user sees the message that 
appears in the comment above.

******************************************************************************/
FUNCTION k_AppKill(cKillFileName)

cKillFileName = iif(cKillFileName = NIL, '@DISABLE.!!!',cKillFileName)

if file(cKillFileName)

    k_Terminate(memoread(cKillFileName))

endif

RETURN(NIL)

