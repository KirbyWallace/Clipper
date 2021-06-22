/****************************************************************************** 
                 The Klipper Library, for CA-Clipper 5.x                        
        Copyright (c), 1994, Wallace Information Systems Engineering            

FUNCTION:

k_MetricConvert( nVal, cTypeConvert ) --> nVal

PARAMETERS:

nVal         : Metric or American Measurement for conversion.
cTypeConvert : Type of conversion to perform on nVal

SHORT:

Perform various metric/American conversions.

DESCRIPTION:

k_MetricConvert() converts values between Metric and American both ways.  
The following table describes the KMETRIC.CH header file which should be 
used to specify the value for cTypeConvert:

    C_TO_F     Centigrade to Fahrenheit
    F_TO_C     Fahrenheit to Centigrade
    F_TO_M     Feet into Meters
    M_TO_F     Meters to Feet
    I_TO_C     Inches to Centimeters
    C_TO_I     Centimeters to Inches
    K_TO_P     Kilograms to Pounds
    P_TO_K     Pounds to Kilograms
    G_TO_L     Gallons to Liters
    L_TO_G     Liters to Gallons
    CF_TO_G    Cubic Feet Luquid to Gallons
    G_TO_CF    Gallons to Cubic Feet Liquid
    CM_TO_G    Cubic Meters Liquid to Gallons
    G_TO_CM    Gallons to Cubic Meters Liquid
    K_TO_M     Kilometers to Miles
    M_TO_K     Miles to Kilometers
    M_TO_KNT   Miles to Knots
    KNT_TO_M   Knots to Miles
    MPG_TO_KPL Miles per Gallons to Kilometers per Liter
    KPL_TO_MPG Kilometers per Liter to Miles per Gallon
    CC_TO_CI   Cubic Centimeters to Cubic Inches
    CI_TO_CC   Cubic Inches to Cubic Centimeters
    KSC_TO_PSI Kilograms Per Square Centimeter to Pounds Per Square Inch
    PSI_TO_KSC Pounds Per Square Inch to Kilograms Per Square Centimeter
    SF_TO_SM   Square Feet to Square Meters
    SM_TO_SF   Square Meters to Square Feet
    SF_TO_A    Square Feet to Acres
    A_TO_SF    Acres to Square Feet
    SM_TO_A    Square Miles to Acres
    A_TO_SM    Acres to Square Miles
    A_TO_HA    Acres to Hectacres
    HA_TO_A    Hectacres to Acres
    LB_TO_ST   Pounds to Stones
    ST_TO_LB   Stones to Pounds

NOTE:

Be aware of your DECIMALS setting when using these functions!

CREDIT: Thanks to Mark Lussier and Timothy W. Cook of AppVision Software for 
preventing me from having to reinvent the wheel.  The formulas for 32 of 
these conversions are extracted from their thirty-two separate functions 
contained in their public domain _Metric! Library_.

EXAMPLE:

[Just SOME examples, not all...]

// Convert 100 degrees Centigrade to Farenheit
t = k_MetricConvert( 100, C_TO_F )

// Convert 100 Miles to Kilometers
t = k_MetricConvert( 100, M_TO_K )

// Convert 100 Feet to Meters
t = k_MetricConvert( 100, F_TO_M )

// Convert 100 Centimeters to inches
t = k_MetricConvert( 100, C_TO_I )

// Convert 175 Pounds to Stones
t = k_MetricConvert( 175, LB_TO_ST )

// Convert 175 Stones to Pounds
t = k_MetricConvert( 175, ST_TO_LB )

******************************************************************************/

#include "kmetric.ch"

FUNCTION k_MetricConvert( nVal, cTypeConvert )
LOCAL nRetVal := NIL

if valtype(nVal) == 'N'

    do case

        case cTypeConvert == C_TO_F

            nRetVal = ( 32 + ( nVal * 1.8 ) )

        case cTypeConvert == F_TO_C

            nRetVal = ( ( nVal - 32 ) / 1.8 )

        case cTypeConvert == F_TO_M

            nRetVal = ( nVal * 0.3048 )

        case cTypeConvert == M_TO_F

            nRetVal = ( nVal / 0.3048 )

        case cTypeConvert == I_TO_C

            nRetVal = ( nVal * 2.5399986 )

        case cTypeConvert == C_TO_I

            nRetVal = ( nVal * 0.393701 )

        case cTypeConvert == K_TO_P

            nRetVal = ( nVal * 2.2046226 )

        case cTypeConvert == P_TO_K

            nRetVal = ( nVal / 2.2046226 )

        case cTypeConvert == G_TO_L

            nRetVal = ( nVal * 3.785306 )

        case cTypeConvert == L_TO_G

            nRetVal = ( nVal / 3.785306 )

        case cTypeConvert == CF_TO_G

            nRetVal = ( nVal * 7.480520  )

        case cTypeConvert == G_TO_CF

            nRetVal = ( nVal / 7.480520 )

        case cTypeConvert == CM_TO_G

            nRetVal = ( nVal * 264.17205 )

        case cTypeConvert == G_TO_CM

            nRetVal = ( nVal / 264.17205 )

        case cTypeConvert == K_TO_M

            nRetVal = ( nVal * .6213712 )

        case cTypeConvert == M_TO_K

            nRetVal = ( nVal / .6213712 )

        case cTypeConvert == M_TO_KNT

            nRetVal = ( nVal / 1.15078 )

        case cTypeConvert == KNT_TO_M

            nRetVal = ( nVal * 1.15078 )

        case cTypeConvert == MPG_TO_KPL

            nRetVal = ( nVal * 0.42515581 )

        case cTypeConvert == KPL_TO_MPG

            nRetVal = ( nVal / 0.42515581 )

        case cTypeConvert == CC_TO_CI

            nRetVal = ( nVal / 16.387064 )

        case cTypeConvert == CI_TO_CC

            nRetVal = ( nVal * 16.387064 )

        case cTypeConvert == KSC_TO_PSI

            nRetVal = ( nVal * 2.9264019 )

        case cTypeConvert == PSI_TO_KSC

            nRetVal = ( nVal / 209264019 )

        case cTypeConvert == SF_TO_SM

            nRetVal = ( nVal / 10.76391 )

        case cTypeConvert == SM_TO_SF

            nRetVal = ( nVal * 10.76391 )

        case cTypeConvert == SF_TO_A

            nRetVal = ( nVal / 43560 )

        case cTypeConvert == A_TO_SF

            nRetVal = ( nVal * 43560 )

        case cTypeConvert == SM_TO_A

            nRetVal = ( nVal * 640 )

        case cTypeConvert == A_TO_SM

            nRetVal = ( nVal * 0.0015625 )

        case cTypeConvert == A_TO_HA

            nRetVal = ( nVal / 2.471054 )

        case cTypeConvert == HA_TO_A

            nRetVal = ( nVal * 2.471054 )

        case cTypeConvert == LB_TO_ST

            nRetVal = ( nVal / 14 )

        case cTypeConvert == ST_TO_LB

            nRetVal = ( nVal * 14 )

    endcase

endif

RETURN(nRetVal)


