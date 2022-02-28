load('data_1.mat');
%plot(s(:,1));
%hold on;
%plot(s(:,2));

%% Listen to the voice

%sound(s,Fs);

%% Evaluate DToA
%Eq. 20.5 from the book

rss = xcorr(s(:,1),s(:,2)); % cross correlation
%plot(rss); % plot the cross correlation
[M , Im] = max(rss); % find the index

Ts = 1/Fs; % sampling time (Seconds)
tau = (Im-length(s(:,1))) * Ts; % averaged TDoA


%% True curve
v = 335;
r = 5; 
d1 = 0.2; % right one
d2 = -0.2; % left one
theta = 0:pi/360:2*pi;
dist1 = sqrt(d1^2 + r^2 - 2*r*d1*cos(theta));
dist2 = sqrt(d2^2 + r^2 - 2*r*d2*cos(theta));
tau1 = dist1 / v;
tau2 = dist2 / v;
difftau = tau1 - tau2;
plot(rad2deg(theta),difftau);

%% Slotted DToA estimation
tauave = [];
acctot = [];
for windowsize = [1000:50:7000]
    
    numWin = floor(length(s)/windowsize);
    tau = zeros(numWin,1);
  
    theta = 0:2*pi/numWin:2*pi-2*pi/numWin;
    dist1 = sqrt(d1^2 + r^2 - 2*r*d1*cos(theta));
    dist2 = sqrt(d2^2 + r^2 - 2*r*d2*cos(theta));
    tau1 = dist1 / v;
    tau2 = dist2 / v;
    difftau = tau1 - tau2;

    for i = 1:floor(length(s)/windowsize)
    
        rss = xcorr(s((i-1)*windowsize+1:i*windowsize,1),s((i-1)*windowsize+1:i*windowsize,2)); 
        [M , Im] = max(rss);
        delta = (rss(Im-1) - rss(Im+1)) / (2*(rss(Im-1) + rss(Im+1) - 2*M));
        tau(i,1) = ( Im-windowsize + delta ) * Ts; 
    
    end
    
    accuracy = mean(abs(difftau - tau'));
    
    tauave = [tauave mean(tau)];
    acctot = [acctot accuracy];
    %figure;
    %plot(tau);
    %title(['WS = ' num2str(windowsize)]);
   
end

[~,I] = min(acctot);
windowing = 1000:50:7000;
BestWinSize = windowing(I);
plot(1000:50:7000,acctot);

%% Start and the end of the signal

