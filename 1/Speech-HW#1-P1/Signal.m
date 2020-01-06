function  Signal(  )
%Input Sound(A,S,Aseman) Then Call Energy and Power signal with plot Signal in time
%domain 
clc
clear
Power=[];
Energy=[];
figure
hold on

subplot(311)
[x,FS] = audioread('Sound\s.wav');
[Power,Energy]=Calc (x,FS,'Sound S',Power,Energy,'k');

subplot(312)
[x,FS] = audioread('Sound\aa.wav');
[Power,Energy]=Calc (x,FS,'Sound A',Power,Energy,'b');

subplot(313)
[x,FS] = audioread('Sound\aseman.wav');
[Power,Energy]=Calc (x,FS,'Sound Aseman',Power,Energy,'r');
%/////Print Enery & Pwer Signal
Disply={'Result Time domain','Sound S','Sound A','Sound Aseman'};
Disply(end+1,:)={'--------','--------','--------','--------'};
Disply(end+1,:)={'Power',num2str(Power(1)),num2str(Power(2)),num2str(Power(3))};
Disply(end+1,:)={'--------','--------','--------','--------'};

Disply(end+1,:)={'Energy',num2str(Energy(1)),num2str(Energy(2)),num2str(Energy(3))};
Disply(end+1,:)={'--------','--------','--------','--------'};
disp(Disply(:,:));
end

function  [Power,Energy]=Calc(x,FS,NameSound,Power,Energy,Color)
%Input Vector Sound $ Frequency & NameSound
%OutPut Energy and Power signal with plot Signal in time
N = length(x);
t = 0:N-1;

stem(t,x,Color);
xlabel('Time (s)'); ylabel('Amplitude');
title(strcat('Time domain -Input sequence',NameSound))
%Power & Energy

Power(end+1) = (norm(x)^2)/length(x);
Energy(end+1) = (norm(x)^2);

end

% 
% subplot(312)
% X=fft(x);%fft
% stem(t,abs(X),'r-','fill')
% xlabel('Frequency'); ylabel('Magnitude');
% title('Frequency domain -Magnitude response')
% subplot(313)
% stem(t,unwrap( angle(X)),'b-','fill')
% xlabel('Frequency'); ylabel('Phase');
% title('Frequency domain -Phase response')
% 
% %%%%%Sound aa
% figure
% x=aa;
% N = length(x);
% t = 0:N-1;
% subplot(311)
% stem(t,x,'k-','fill');
% xlabel('Time (s)'); ylabel('Amplitude');
% title('Time domain -Input sequence')
% subplot(312)
% X=fft(x);%fft
% stem(t,abs(X),'r-','fill')
% xlabel('Frequency'); ylabel('Magnitude');
% title('Frequency domain -Magnitude response')
% subplot(313)
% stem(t,unwrap( angle(X)),'b-','fill')
% xlabel('Frequency'); ylabel('Phase');
% title('Frequency domain -Phase response')
% %%%%%Sound man
% figure
% x=man;
% N = length(x);
% t = 0:N-1;
% subplot(311)
% stem(t,x,'k-','fill');
% xlabel('Time (s)'); ylabel('Amplitude');
% title('Time domain -Input sequence')
% subplot(312)
% X=fft(x);%fft
% stem(t,abs(X),'r-','fill')
% xlabel('Frequency'); ylabel('Magnitude');
% title('Frequency domain -Magnitude response')
% subplot(313)
% stem(t,unwrap( angle(X)),'b-','fill')
% xlabel('Frequency'); ylabel('Phase');
% title('Frequency domain -Phase response')
% %%%%%Sound aseman
% figure
% x=aseman;
% N = length(x);
% t = 0:N-1;
% subplot(311)
% stem(t,x,'k-','fill');
% xlabel('Time (s)'); ylabel('Amplitude');
% title('Time domain -Input sequence')
% subplot(312)
% X=fft(x);%fft
% stem(t,abs(X),'r-','fill')
% xlabel('Frequency'); ylabel('Magnitude');
% title('Frequency domain -Magnitude response')
% subplot(313)
% stem(t,unwrap( angle(X)),'b-','fill')
% xlabel('Frequency'); ylabel('Phase');
% title('Frequency domain -Phase response')
% 
% end

