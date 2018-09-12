subroutine  CO2FLX
  use simsphere_mod

!       INCLUDE 'modvars.h'

!      created 11/2/90; MODIFIED 06/17/91

!      CI =  120. suggested value for c4 plants
!      CI =  210  suggested value for c3 plants
!      CO =  330  50 m above the canopy

  CHAX = USTAR**2 / ( UTEN - UAF )

  PEX  = ( XLAI / 2.0 ) + 1.
  RAIR =  1.0 / CHAX + RZASCR
  RROE =  1.83
  RAFCANOPY = RAF * PEX / XLAI

!    RAFCANOPY IS RAF SCALED FOR XLAI TO A CANOPY
!    RROE IS DENSITY OF PURE CARBON DIOXIDE (KG M-3) AT 20 C
!    SUBROUTINE COMPUTES CARBON DIOXIDE FLUXES
!    WE FOLLOW CLOSELY GOUDRIAAN'S BOOK, CHAPTER 3
!      (CROP MICROMETEOROLOGY:  A SIMULATION STUDY; 1977)

!    CI IS INTERNAL CO2 CONCENTRATION IN LEAF
!      (120 VPM FOR C4 PLANT (CORN); 220 FOR C3 PLANT (BEANS))
!      - CO IS AMBIENT CO2 CONCENTRATION ABOVE CANOPY - - 330 VPM
!    MULTIPLY CONCENTRATIONS BY 10-6 TO GET FRACTIONAL AMOUNT

!   RESISTANCES FOR STOMATAL RESISTANCE (RST)
!                   LEAF BOUNDARY LAYER (RAF)
!                   TOP OF CANOPY (1/CHAX) TO 2 METERS
!                   SCREEN LEVEL (2 M) TO 50 METERS (RZASCR)
!   LEAF BOUNDARY LAYER RESISTANCE RAF CORRECTED FOR CO2 MOLECULAR
!                   DIFFUSIVITY  (S M-1): FACTOR OF 1.32
!   STOMATAL RESISTANCE CORRECTED FOR CO2 DIFFUSIVITY (FACTOR OF 1.66)
!          CALCULATE FLUX OF CO2 TO ENVIRONMENT
!          FACTORS 1.32 AND 1.66 ADJUST VALUES FROM H20 TO CO2.

  RRTOT = 1.32 * RAFCANOPY + 1.66*RST + RAIR

  FCO2 = RROE * ( CO - CI )  / RRTOT

  FCO2 = (FCO2 * FRVEG) / 0.044 ! In moles/m2/s
!
!      CALCULATE CO2 FLUX IN CANOPY FCO2; ADJUST FOR
!         PARTIAL VEGETATION FRACTION FRVEG
!      UNITS OF FLUX  (FCO2) ARE KG (CO2) PER METER SQUARED PER SECOND
!         IN CONCENTRATION (CCAM)  PARTS VOLUME PER MILLION (VPM)

!         **** NOTE SOME PAPERS LIST CO2 FLUX IN MOLES PER M2 PER S ****
!
!         *****    ONE MOLE OF CO2 IS 46 GRAMS    *****

  CCAN  =  CO - ( CO - CI ) * RAIR * FRVEG / RRTOT

!      CALCULATE CO2 CONCENTRATION JUST INSIDE CANOPY - - CCAN

  return
end