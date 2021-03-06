subroutine  ADVECT
  use simsphere_mod

! **  This subroutine calculates the geostrophic temperature
! **  advection based on the thermal wind equation and the
! **  vertical distribution of geostrophic wind.

!     INCLUDE 'modvars.h'

! **  The depth of the layer over which we compute geostrophic
! **  temperature advection is 1000 metres, Z(5)-Z(1)
 
  DATA DZ /1000/
 
  DTDX =  CF * OTEMP / (GRAV*DZ)*(VGD(5)-VGD(1))
  DTDY =  -CF * OTEMP / (GRAV*DZ)*(UGD(5)-UGD(1))
  ADVGT = -(UGD(3)*DTDX + VGD(3)*DTDY)
 
! **  Assume that actual temperature change is one-half that of
! **  geostrophic temperature advection.
 
  ADVGT = ADVGT/2

  return
end
