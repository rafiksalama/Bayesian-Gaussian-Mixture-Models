library(rjags)
data = c(rnbinom(100,mu=10,size=.1),rnbinom(100,mu=10,size=10))

#size = 

#Now let us do this with rjags
model_string <- "model{

#Start with the data

  for(i in 1:length(Y)) 
  {
    mu[i] ~ dgamma(am,bm)
    p[i,1] = r[i,1]/(mu[i]+r[i,1])
    p[i,2] = r[i,2]/(mu[i]+r[i,2])
    r[i,1] ~ dgamma(ar1,br1)
    r[i,2] ~ dgamma(ar2,br2)
    model.index[i] ~ dbern(pi)
    Y[i] ~ dnegbin(p[i,model.index[i]+1],r[i,model.index[i]+1])
  }
  
  pi ~ dbeta(0.5,0.5)
  ar1 ~ dgamma(1,1)
  br1 ~ dgamma(1,1)
  ar2 ~ dgamma(1,1)
  br2 ~ dgamma(1,1)
  am ~ dgamma(1,1)
  bm ~ dgamma(1,1)

}
"

model <- jags.model(textConnection(model_string), data = list(Y=as.vector(data)))

update(model, 10000, progress.bar="none")
samp <- coda.samples(model, variable.names=c("ar1","br1","ar2","br2","am","bm","model.index"), n.iter=20000, progress.bar="none")
summary(samp)
