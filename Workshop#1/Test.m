x1 = load('data_1.mat','x1'); % distorted signal
x1 = x1.x1;
x1 = x1';

s = load('true_signal.mat','s'); % True signal
s = s.s;
s = s';

samplefreq = load('data_1.mat','Fs');
samplefreq = samplefreq.Fs;

% To play the sound
%sound(x1,samplefreq);
P = 5;
MSE = zeros(1,P);

for p = 1:P
    a = zeros(1,p); 
    s_total = [];

    for i = 1:p
    s_total = [s_total ; s.^i]; 
    end


    eval(sprintf('a%d =  x1 * pinv(s_total)',p));

    err = x1 -  eval(sprintf('a%d',p))*s_total;
    MSE(1,p) = 10*log10(mean(err.^2));
end

