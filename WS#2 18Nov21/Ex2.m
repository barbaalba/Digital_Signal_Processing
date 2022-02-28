clear;
clc;
load('data_2.mat');

%% Initalization

N = 10;% length of the filter to design
u = 0.5;%step size [0 1]

h =zeros(1,N);

wref = zeros(N,2);
wref(N,:) = w1(1,:);

for i = 1:length(x1)

west = conv(h',wref); % estimate noise 
%error = x1 - west; % wanna minimize to the signal value

%update filter
%h = h + u * (error*wref);
wref = circshift(wref,-1); 
wref(N) = w1(i+1,1);

end
