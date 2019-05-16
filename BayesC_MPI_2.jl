using MPI
using LinearAlgebra
using Distributions
using Random

function IIBLMM()
    MPI.Init()

    comm = MPI.COMM_WORLD
    my_rank = MPI.Comm_rank(comm)
    cluster_size = MPI.Comm_size(comm)

    nRow=50_001  #npar
    nCol=50_000  #nMarker

    batch_size = Int(nCol/cluster_size)  # m
    batch_ele = Int(batch_size * nRow)

    if my_rank==0
        Xa  = randn(nRow,nCol)
        α   = randn(nCol)
        Xty = randn(nCol)
        meanAlpha = zeros(nCol)
        y   = randn(10_000)
        sum_y       = sum(y)
        dot_y       = dot(y,y)
        mu          = mean(y)
        nind        = length(y)
    else
        Xa = Float64[]
        α  = Float64[]
        Xty = Float64[]
        meanAlpha = Float64[]
        sum_y = Float64[]
        dot_y = Float64[]
        mu = Float64[]
        nind  = Float64[]
    end

    Xa = MPI.Scatter(Xa,batch_ele,0,comm)
    Xa = reshape(Xa,(nRow,batch_size))    # 50_001 * m
    α  = MPI.Scatter(α,batch_size,0,comm)  # m
    Xty = MPI.Scatter(Xty,batch_size,0,comm) #m
    meanAlpha = MPI.Scatter(meanAlpha,batch_size,0,comm) #m

    Random.seed!(1234)  #why I have to put seed exactly before J?
    J           = randn(nRow)  #50_001   Xa[:,1]

    sum_y       = MPI.bcast(sum_y,0,comm)
    dot_y       = MPI.bcast(dot_y,0,comm)
    mu          = MPI.bcast(mu,0,comm)
    nind        = MPI.bcast(nind,0,comm)
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

   @show my_rank
    @time for iter = 1:5
      iIter = 1.0/iter

      #sample y_new
      local_xaα = Xa * α  #50_001
      ya = MPI.Allreduce(local_xaα, MPI.SUM, comm) + J*mu + randn(nRow)*sqrt(vare)  #50_001 all_ya
      # sample intercept
      rhs_mu  = sum_y + dot(J,ya) #scaler all  ! rhs_mu not same!!

      mu      = rhs_mu/d + randn()*sqrt(vare/d) #scaler all
      meanMu += (mu - meanMu)*iIter #scaler all

      #sample marker effects
      rhs       = Xty + (Xa' * ya)#m + (m,50_001)*(50_001,1) local_rhs
      lhs       = d + vare/vara
      meanm     = rhs/lhs   #m local meann
      varm      = vare/lhs
      α         = meanm + randn(batch_size)*sqrt(varm)  #m local_α

      #sample indicators
      v0        = d*vare
      v1        = v0+d^2*vara
      logDelta0 = -0.5*(rhs.^2/v0 .+ log(v0)) .+ logPi  #m local logDelta0
      logDelta1 = -0.5*(rhs.^2/v1 .+ log(v1)) .+ logPiComp #m local logDelta1
      probDelta1= 1.0 ./ (exp.(logDelta0-logDelta1) .+ 1.0) #m local probDelta1
      includeit = rand(batch_size) .< probDelta1  #m local includeit
      α         = α.*includeit       #m local_α
      meanAlpha += (α-meanAlpha)*iIter #m local meanAlpha

      #sample vare
      local_dot_α = dot(α,α)
      dot_α = MPI.Allreduce(local_dot_α, MPI.SUM, comm)
      local_dot_α_rhs = dot(α,rhs)
      dot_α_rhs = MPI.Allreduce(local_dot_α_rhs, MPI.SUM, comm)

      yctyc = dot_y + dot(ya,ya) + d*mu^2 + d*dot_α - 2*mu*rhs_mu-2*dot_α_rhs #scaler all

      vare  = (yctyc + nuRes*scaleRes)/rand(Chisq(nRow+nind+nuRes)) #all
      vare = sqrt(abs(vare))
      meanVare += (vare - meanVare)*iIter #scaler  all

      #sample varEffects
      local_nLoci= sum(includeit)
      nLoci = MPI.Allreduce(local_nLoci, MPI.SUM, comm)  #all  !same in all task
      vara =  (dot_α + dfEffectVar*scaleVar)/rand(Chisq(nLoci+dfEffectVar)) #all
      meanVara += (vara - meanVara)*iIter
    end


    # all_meanAlpha = MPI.Gather(meanAlpha,0,comm)
    # println("rank: ",my_rank,", meanVara: ",meanVara,", meanVare: ",meanVare,", meanMu: ", meanMu)

    MPI.Finalize()
end




IIBLMM()
