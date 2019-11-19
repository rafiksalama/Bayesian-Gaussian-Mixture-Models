library(rjags)
data = c(rnorm(100,1,1),rnorm(100,10,1))
Y = data
#mu=(1-p)/p, mup=1-p, mup+p=1, p=1/(mu+1), with variance absent in this case, we will have to assume that variance is a function of mu of some sort
#
#mu=(1-p)/p, mup=1-p, mup+p=1, p=1/(mu+1)

#Now let us do this with rjags
model_string <- "model{

#Start with the data

  for(i in 1:length(Y)) 
  {
    Y[i] 
  }
  
  for(j in 1:4) {
    B[j] ~ dgamma(1,1)
  }

  ar ~ dgamma(1,1)
  br ~ dgamma(1,1)
  #am ~ dgamma(10,1)
  #bm ~ dgamma(1,1)

}
"

model <- jags.model(textConnection(model_string), data = list(Y=as.vector(data), X=X))

update(model, 10000, progress.bar="none")
samp <- coda.samples(model, variable.names=c("B","r"), n.iter=20000, progress.bar="none")
summary(samp)
