module ionufft
  implicit none
contains

  subroutine nufft1d2(nj,ms)
    implicit none
    integer, intent(in) :: ms,nj
    integer :: i,ier,iflag,j,k1
    integer, parameter :: mx=10000
    real(8) :: xj(mx), sk(mx)
    real(8) :: err,eps
    real(8), parameter :: pi=3.141592653589793238462643383279502884197d0
    complex(16) :: cj(mx),cj0(mx),cj1(mx)
    complex(16) :: fk0(mx),fk1(mx)
    i=1
    do i = 1,nj
       xj(i) = 2*pi*real(i)/ms 
    enddo

    do j = 1,ms/2          
       fk0(j)= dcmplx(real(j+ms/2),0.0)
    enddo
    do j = ms/2+1,ms          
       fk0(j)= dcmplx(real(j-ms/2),0.0)
    enddo

    iflag = -1
    print*,' Start 1D testing: ', ' nj =',nj, ' ms =',ms
    i=6
    if (i.eq.1) eps=1d-4
    if (i.eq.2) eps=1d-8
    if (i.eq.3) eps=1d-12
    if (i.eq.4) eps=1d-16
    if (i.eq.5) eps=1d-20
    if (i.eq.6) eps=1d-24
    if (i.eq.7) eps=1d-28
    if (i.eq.8) eps=1d-32
    print*,' '
    print*,' Requested precision eps =',eps
    print*,' '
    call dirft1d2(nj,xj,cj0,iflag, ms,fk0,ier)
    call nufft1d2f90(nj,xj,cj1,iflag, eps, ms,fk0,ier)
    print *,' ier = ',ier
    print *,' type 2 error = ',err


  end subroutine nufft1d2


end module ionufft