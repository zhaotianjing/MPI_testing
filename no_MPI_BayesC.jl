using LinearAlgebra
using Distributions
using Random

function IIBLMM()

    nRow=50_001  #npar
    nCol=50_000  #nMarker



    Xa  = randn(nRow,nCol) #(50_001,50_000)
    α   = randn(nCol)      #50_000
    Xty = randn(nCol)      #50_000
    meanAlpha = zeros(nCol)
    y   = randn(10_000)
    sum_y       = sum(y)
    dot_y       = dot(y,y)
    mu          = mean(y)
    nind        = length(y)

    J           = randn(nRow)  #50_001   Xa[:,1]

    vare        = 1.0
    vara        = 1.0
    d           = 6954.57
    meanMu      = 0.0


    nuRes       = 4
    scaleRes    = vare*(nuRes-2)/nuRes
    dfEffectVar = 4
    scaleVar    = vara*(nuRes-2)/nuRes
    π           = 0.99
    logPi       = log(π)
    logPiComp   = log(1.0-π)

    meanVare    = 0.0
    meanVara    = 0.0

    @time for iter = 1:100
      iIter = 1.0/iter

      #sample y_new
      ya = Xa * α + J*mu + randn(nRow)*sqrt(vare)  #50_001
      # sample intercept
      rhs_mu  = sum_y + dot(J,ya) #scaler

      mu      = rhs_mu/d + randn()*sqrt(vare/d) #scaler
      meanMu += (mu - meanMu)*iIter #scaler

      #sample marker effects
      rhs       = Xty + (Xa' * ya) #50_000
      lhs       = d + vare/vara    #scaler
      meanm     = rhs/lhs   #50_000
      varm      = vare/lhs
      α         = meanm + randn(nCol)*sqrt(varm)  #50_000

      #sample indicators
      v0        = d*vare
      v1        = v0+d^2*vara
      logDelta0 = -0.5*(rhs.^2/v0 .+ log(v0)) .+ logPi  #
      logDelta1 = -0.5*(rhs.^2/v1 .+ log(v1)) .+ logPiComp #
      probDelta1= 1.0 ./ (exp.(logDelta0-logDelta1) .+ 1.0) #
      includeit = rand(nCol) .< probDelta1  #
      α         = α.*includeit       #
      meanAlpha += (α-meanAlpha)*iIter #

      #sample vare
      yctyc = dot_y + dot(ya,ya) + d*mu^2 + d*dot(α,α) - 2*mu*rhs_mu-2*dot(α,rhs)
      vare  = (yctyc + nuRes*scaleRes)/rand(Chisq(nRow+nind+nuRes)) #all
      vare = sqrt(abs(vare))
      meanVare += (vare - meanVare)*iIter #scaler  all

      #sample varEffects
      nLoci = sum(includeit)  #all  !same in all task
      vara =  (dot(α,α) + dfEffectVar*scaleVar)/rand(Chisq(nLoci+dfEffectVar)) #all
      meanVara += (vara - meanVara)*iIter
    end

end




IIBLMM()
