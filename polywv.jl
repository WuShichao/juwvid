module polywv
##### DO NOT WORKING YET ####
# Chandra Sekhar and Sreenivas 02
import Interpolations

function tfrpowv(x,y=NaN,t=NaN,N=NaN,silent=0)
    println("DON'T USE !!! DO NOT WORKING YET.")
    #f :frequency array
    # the six-order polynomial q=6
    xrow = size(x)[1] 
    if isnan(t)[1] t=collect(1:xrow) end
    if isnan(N) N=xrow end
    #information
    if isnan(y)[1]
        if silent ==0  println("Single polynomial Wigner Ville (6-th order)") end
        y=x
        xi = Interpolations.interpolate((t,),x, Interpolations.Gridded(Interpolations.Linear()));
        yi=xi
        sw=0
    else 
        if silent==0 println("Cross polynomial Wigner Ville (6-th order)") end
        xi = Interpolations.interpolate((t,),x, Interpolations.Gridded(Interpolations.Linear()));
        yi = Interpolations.interpolate((t,),y, Interpolations.Gridded(Interpolations.Linear()));
        sw=1
    end

    d1=0.675
    d2=0.85
    #interpolation

#    tau = 1/d2
    tau = 1/d1

#    tau=0.1
    M=N
    tfr=zeros(Complex64,M,M) # plane by default

    for icol=1:N
        ti=t[icol]
        taumax=minimum([ti-1,N-ti,round(N/2)-1])
        taumax=round(Int,taumax*d2/tau)
        taumax=minimum([taumax,N])
        taumax=maximum([taumax,1])

#        println("--",icol,"--",taumax)
        for mrow=-taumax:taumax
            mrowx=round(Int64,rem(N+mrow,N)+1)
#            println(mrowx," ",mrow," ",ti+d2*mrow*tau," ",t[end]," ",ti-d2*mrow*tau," ",1)
            tfr[mrowx,icol] = xi[ti+d1*mrow*tau].*yi[ti+d1*mrow*tau].*conj(yi[ti-d1*mrow*tau]).*conj(yi[ti-d1*mrow*tau]).*conj(yi[ti+d2*mrow*tau]).*yi[ti-d2*mrow*tau]
        end
    end

    for i=1:N
        tfr[:,i]=fft(tfr[:,i])
    end
#    println(tfr)
#    exit()
#    if sw==0
#        tfr=real(tfr)
#    end

    return tfr
end
end

#import DSP
#y=linspace(0.0,16.0,16)
#z=DSP.Util.hilbert(y) # transpose is necessary 
#tfr=polywv.tfrpowv(z)
