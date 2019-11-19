library(rstan)
X = cbind(rep(1,1000),apply(as.matrix(rgamma(9,1)),1,function(x){rnorm(1000,x)}))
B = as.matrix(c(10,rgamma(9,1)))
Y = X%*%B
Bhat = t((t(X)%*%Y))%*%solve(t(X)%*%X)
model = "data{
  int<lower=0> N;
  int<lower=0> m;
  matrix[N,m] X;
  vector[N] Y;
}

parameters{
  vector[m] beta;
  real<lower=0> sigma;
}

model{
  Y ~ normal(X*beta,sigma);
}"
dat <- list(N = 1000, m=10, X = X, Y=as.vector(Y))
fit <- stan(model_code = model, model_name = "fit_regression", 
            data = dat, iter = 1000, chains = 1, sample_file = 'norm.csv',
            verbose = TRUE) 
