load('ADSP_exercising30Sept21.mat');

plot(y);

segmentedVoice = y(4332:6606); % Extract the useful part of the signal

plot(segmentedVoice);

h = [1;-1]; % We want to get dolbey voice

% We build convolution matrix of the signal
segConvMat = zeros(length(segmentedVoice)+length(h)-1, length(h));

for i = 1:length(h)
   segConvMat(i:i+length(segmentedVoice)-1,i) = segmentedVoice.';
end

Noiselessout = segConvMat * h;
sigmaList = [0.1:0.1:10];
MSETotal = zeros(1,length(sigmaList));
for k = 1:100
    for i = 1:length(sigmaList)
        sigma = sigmaList(i);
        noise = sigma * randn(length(Noiselessout),1);
        noisySig = Noiselessout + noise;
   
        % Want to find the estimate of h knowing the convolution matrix
        hestim = inv(segConvMat.'*segConvMat)*segConvMat.'*noisySig;
        error = h - hestim;
        MSE = error.'*error / length(h);
        MSETotal(i) =  MSETotal(i) + 10*log10(MSE);
    end
end

 MSETotal = MSETotal / k;