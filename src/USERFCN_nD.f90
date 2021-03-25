!     Automatic Time-stamp: <Last changed by martino on Tuesday 07 April 2020 at CEST 18:34:52>
!################################### USERFCN DEFINITION #####################################



      FUNCTION USERFCN_nD(x,npar,val,funcname)
      IMPLICIT NONE
      INTEGER(4) :: npar, maxdim=40
      REAL(8), DIMENSION(npar) :: val
      REAL(8), DIMENSION(:) :: x(maxdim)
      REAL(8) ::  USERFCN_nD, GAUSS_3D
      CHARACTER(64) :: funcname

!     Choose your model (see below for definition)
      IF(funcname.EQ.'GAUSS_3D') THEN
         USERFCN_nD = GAUSS_3D(x,npar,val)

      ELSE
         WRITE(*,*) 'Error in the function name def. in USERFCN'
         WRITE(*,*) 'Check in the manual and in the input.dat file'
         STOP
      END IF

      RETURN
      END


!################################### LINESHAPE DEFINITIONS #####################################


      FUNCTION GAUSS_3D(X,npar,val)
!     Normalized Gaussian distribution plus background
!     The value of 'amp' is the value of the surface below the curve
      IMPLICIT NONE
      INTEGER*4 npar
      REAL*8 val(npar)
      REAL*8 x(3)
      REAL*8 GAUSS_3D 
      REAL*8 pi
      PARAMETER(pi=3.141592653589793d0)
      REAL*8 x0, y0, z0, amp, sigmax, sigmay, sigmaz, bg
      REAL*8  x_, y_, z_, expx, expy, expz,pref
      LOGICAL plot
      COMMON /func_plot/ plot

      !x(1) = x_
      !x(2) = y_
      !x(3) = z_

      bg    = val(1)
      x0    = val(2)
      y0    = val(3)
      z0    = val(4)
      amp   = val(5)
      sigmax= val(6)
      sigmay= val(7)
      sigmaz= val(8)

!     Test of under of underflow first
      expx = -(x(1)-x0)**2/(2*sigmax**2)
      expy = -(x(2)-y0)**2/(2*sigmay**2)
      expz = -(x(3)-z0)**2/(2*sigmaz**2)
      IF(ABS(expx + expy + expz).LT.700) THEN
         pref = amp/(dsqrt((2*pi)**3)*sigmax*sigmay*sigmaz)
         GAUSS_3D = pref*exp(expx+expy+expz)
      ELSE
         GAUSS_3D = 0.d0
      END IF      
      
 
      RETURN
      END





! ##############################################################################################
