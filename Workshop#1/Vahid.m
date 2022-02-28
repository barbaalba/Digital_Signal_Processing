%%
clc
clear all
close all

load('true_signal.mat')
load('data_1.mat')
load('data_2.mat') 
%sound(s, Fs)
%sound(x1, Fs)
sound(x2, Fs)
Nx1=length(x1);
Nx2=length(x2);
Ns=length(s);
figure(1)
plot(s)
figure(2)
plot(x1)
%% segmenting
 seg=3000;
 x1_seg=x1(1:seg);
 x2_seg=x2(1:seg);
 s_seg=s(1:seg);
 Nx1_seg=length(x1_seg);
 Nx2_seg=length(x2_seg);
 Ns_seg=length(s_seg);
%% noise generation

sigma2=0.01;
sigma2_2=4e-4;

% sigma=sqrt(sigma2);
% 
% w=sigma*randn(Nx1,1);


%%  distortion parameters



for p=1:10
    H_seg=zeros(Nx1,p);
    for i=1:p
        H_seg(1:end,i)=s.^i;
    end
    
    % a_hat=H\x1_clean;
    %c_w=diag(ones(Nx1,1)*sigma2);
    
    % op1=inv((H_seg'*inv(c_w)*H_seg));
    % a_hat=op1*(H_seg'*inv(c_w))*x1_seg;
    a_hat=pinv(H_seg)*x1;
    x1_hat=a_hat(1)*s;
    %x1_hat(p+1)=x1_hat(p)+a_hat(p)*s.^p;
end
    
    
    
    %s_hat=(x1-a_hat(2)*s.^2)/a_hat(1);
   

%sound(s_hat,Fs)
%figure(1)
%plot(s)
%figure(2)
%plot(s_hat)


%%  testing

% H=zeros(Nx1,p);
% for i=1:p
%     H(1:end,i)=s.^i;
% end
% 
% % a_hat=H\x1_clean;
% x1_hat=H*a_hat;
% 
% a_hat=x1*pinv(a_hat);

%figure(1)
%plot(s)
%figure(2)
%plot(s_hat)
%% b
Nh=4;
c_w=diag(ones(Nx2_seg,1)*sigma2_2);
s_conv=convmtx(s_seg(1:end-Nh+1),Nh);
h_hat=inv((s_conv'*s_conv));
h_hat=h_hat*(s_conv')*x2_seg;


%% test

h_conv=convmtx(h_hat,Ns_seg);
h_conv=h_conv(1:end,:);
s_hat=h_conv\x2(1:seg+Nh-1);

figure(1)
plot(s_seg)
figure(2)
plot(s_hat)

































