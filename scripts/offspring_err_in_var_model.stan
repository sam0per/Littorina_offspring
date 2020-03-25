//
// This Stan program defines a Simple regression with measurement error in x an y
// https://discourse.mc-stan.org/t/estimating-slope-and-intercept-linear-regression-for-data-x-vs-y-with-uncertainties-in-both-x-and-y/5457/4
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data are vectors 'x', 'sd_x', 'y' and 'sd_y' of length 'N'.
data {
  int<lower=0> N;
  vector[N] x;
  vector<lower=0>[N] sd_x;
  vector[N] y;
  vector<lower=0>[N] sd_y;
}

// The parameters accepted by the model.
parameters {
  vector[N] x_lat;
  vector[N] y_lat;
  real alpha;
  real beta;
  real<lower=0> sigma;
}

transformed parameters {
  vector[N] mu_yhat = alpha + beta * x_lat;
}

// The model to be estimated. We model the output
// 'y_mean' to be normally distributed with mean 'alpha + beta * x'
// and standard deviation 'sigma_y'.
model {
  alpha ~ normal(0., 5.);
  beta ~ normal(1., 5.);
  sigma ~ cauchy(0., 5);
  
  xhat ~ normal(x_lat, sd_x);
  y_lat ~ normal(mu_yhat, sigma);
  yhat ~ normal(y_lat, sd_y);
}

