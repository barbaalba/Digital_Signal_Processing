x2 = load('data_2.mat','x2');
x2 = x2.x2;

s = load('true_signal.mat','s'); % True signal
s = s.s;

trunc = 5000;
s_new = s(1:trunc,1);

samplefreq = load('data_1.mat','Fs');
samplefreq = samplefreq.Fs;

% To play the sound
%sound(x2,samplefreq);

% the model is H * s ~ x2

P = 1000;
p = 100:100:P;

MSE = zeros(1,numel(p));

for i = 1:numel(p) 
   
    sconv = zeros(numel(s_new)+p(i)-1,p(i));
    
    for j = 1:p(i)
       sconv(j:j+numel(s_new)-1,j) = s_new; 
    end
    
    x2_new = x2(1:numel(s_new) + p(i) - 1,1);
   
    h =  pinv(sconv) * x2_new;
    
    xapprox = conv(h,s_new);
    
    err = x2_new - xapprox;
    
    MSE(1,i) = 10*log10(mean(err.^2));

end