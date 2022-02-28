load('ADSP_exercising30Sept21.mat');

plot(y);

segmentedVoice = y(4332:6606); % Extract the useful part of the signal

plot(segmentedVoice);

h = [1;-1]; % We want to get dolbey voice (filter)

% We build convolution matrix of the signal
segConvMat = zeros(length(segmentedVoice)+length(h)-1, length(h));

for i = 1:length(h)
   segConvMat(i:i+length(segmentedVoice)-1,i) = segmentedVoice.';
end

Noiselessout = segConvMat * h;
sigmaList = [0.1:0.1:10];
MSETotal = zeros(1,length(sigmaList));
for k = 1:400
    for i = 1:length(sigmaList)
        sigma = sigmaList(i);
        noise = sigma * randn(length(Noiselessout),1);
        noisySig = Noiselessout + noise;
   
        % Want to find the estimate of h knowing the convolution matrix
        hestim = inv(segConvMat.'*segConvMat)*...
            segConvMat.'*noisySig; % Least squared error estimation
        error = h - hestim;
        MSE = error.'*error / length(h);
        MSETotal(i) =  MSETotal(i) + 10*log10(MSE);
    end
end
 MSETotal = MSETotal / k;
 plot(sigmaList,MSETotal);
 
 %% Generate correlated noise 
 
 A = [1 0.9]; % coefficients of the z-transform in the denominator 
 noisewhite = randn(1000,1000); % uncorrelated mu= 0  and sigma = 1
 cov = zeros(1000);
 for i = 1:1000
 cov = cov + noisewhite(:,i)*noisewhite(:,i)';
 end
 cov = cov/1000;
 
 noise = filter(1,A,noisewhite);

 covcolored = zeros(1000);
 for i = 1:1000
 cov = covcolored + noise(:,i)*noise(:,i)';
 end
 
 %% Use filter function 
 
 % A(Z) = 1 - ru * z^(-1) whcih is w[n] = w[n] - w[n-1]
N = 20;
rho = 0.9;
sigma_u = 2;
w = sqrt(sigma_u) * randn(N,1);

u = zeros(N+1);
for n = 1 : N
   u(n) = w(n) - rho * u(n-1)
end

%%  

sigma_u = 2*[1 -rho ; -rho 1];
u = mvnrnd(0,sigma_u,100);