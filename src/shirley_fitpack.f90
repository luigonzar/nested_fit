
! Time-stamp: <Last changed by martino on Wednesday 08 January 2020 at CET 18:29:08>

SUBROUTINE INIT_SHIRLEY(ndata,x_data,nc_data)
  ! Initialization for Shirely bacground consisting in an integral of the data input spectrum to add to the peak functions
  ! Shirley function requires that the data are already ordered and equally spaced
  IMPLICIT NONE
  INTEGER(4), INTENT(IN) :: ndata
  REAL(8), INTENT(IN), DIMENSION(ndata) :: x_data, nc_data
  REAL(8) :: dx_sh, x0_sh
  INTEGER(4) :: i, ninterp=0
  CHARACTER :: lr*1
  !Interpolation subroutine variables
  INTEGER(4), PARAMETER :: maxdata=10000
  REAL(8), DIMENSION(maxdata) :: x_shirley=0., y_shirley=0., w_shirley=1.
  INTEGER(4) :: k=3, nn, ier, itmp
  INTEGER(4), PARAMETER :: iopt=0, nest=1000, lwrk=20000
  REAL(8) :: fp
  REAL(8), PARAMETER :: s=0. ! Simple interpolation
  REAL(8), DIMENSION(nest) :: t, c
  INTEGER(4), DIMENSION(nest) :: iwrk
  REAL(8), DIMENSION(lwrk) :: wrk
  REAL(8) :: xp, yp

  COMMON /func_exp/ lr
  COMMON /func_shirely/t, c, k, nn
  !COMMON /aux_shirely/dx_sh, x0_sh


  ! Sort x and en values with increasing x values
  !CALL SORTN(ndata,1,x,nc)

  ! Calculate binning for shirley subtraction of bacground
  dx_sh = x_data(2) - x_data(1)
  x0_sh = x_data(1)

  ! Calculation of the Shirley background (integration with respect to one sense or the other)
  IF(lr.EQ.'r'.OR.lr.EQ.'R') THEN
     x_shirley(1) = x_data(1)
     y_shirley(1) = 0.
     DO i=2,ndata
        x_shirley(i) = x_data(i)
        y_shirley(i) = y_shirley(i-1) + nc_data(i) - nc_data(1)
     ENDDO
  ELSE IF(lr.EQ.'l'.OR.lr.EQ.'L') THEN
     x_shirley(ndata) = x_data(ndata)
     y_shirley(ndata) = 0.
     DO i=2,ndata
        x_shirley(ndata-i+1) = x_data(ndata-i+1)
        y_shirley(ndata-i+1) = y_shirley(ndata-i+2) + nc_data(ndata-i+1) - nc_data(ndata)
     ENDDO
  END IF

  ninterp = ndata



  ! Interpolate for an easy calculation ________________________________


  !     Calculate the parameter for the spline interpolation
  CALL CURFIT(iopt,ninterp,x_shirley,y_shirley,w_shirley,&
       x_shirley(1),x_shirley(ninterp),k,s,nest,nn,t,c,fp,wrk,lwrk,iwrk,ier)

  IF(ier.GT.0) THEN
     WRITE(*,*) 'Problem with CURVFIT. IER = ', ier
     WRITE(*,*) 'iopt = ', iopt, 'k = ', k, 'ninterp = ', ninterp
     WRITE(*,*) 'fp = ', fp, 'ndata = ', ndata, 'Max allowed is 1000'
     STOP
  END IF

  ! Test
  OPEN(100,FILE='shirley_out.dat',STATUS= 'UNKNOWN')
  DO I=1,ndata
     WRITE(100,*) x_shirley(i),y_shirley(i)
  END DO
  CLOSE(100)
  OPEN(20,FILE='shirley_out_interp.dat',STATUS= 'UNKNOWN')
  DO i = 1, 1000
     xp = x_shirley(1) + (x_shirley(ninterp)-x_shirley(1))/1000*(i-1)
     CALL SPLEV(t,nn,c,k,xp,yp,1,1,ier)
     WRITE(20,*) xp, yp
  ENDDO
  CLOSE(20)

END SUBROUTINE INIT_SHIRLEY


!--------------------------------------------------------------------------------------------------
FUNCTION SHIRLEY(x)
  ! Shirley function
  REAL(8) :: x, y, SHIRLEY
  !INTEGER(4), PARAMETER :: maxdata=10000
  !REAL(8), DIMENSION(maxdata) :: ndata, x_shirley, y_shirley, y2_shirley
  INTEGER(4) :: i, ninterp
  CHARACTER :: lr*1

  ! Interpolation variables
  INTEGER(4) :: k, nn, ier
  INTEGER(4), PARAMETER :: nest=1000
  REAL(8), DIMENSION(nest) :: t, c
  COMMON /func_shirely/t, c, k, nn

  COMMON /func_exp/ lr

  CALL SPLEV(t,nn,c,k,x,y,1,1,ier)

  SHIRLEY = y


END FUNCTION SHIRLEY
