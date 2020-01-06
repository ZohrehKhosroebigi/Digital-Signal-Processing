function  FFTSignal(  )
%Input Sound(A,S,Man,Aseman) Then Call Energy and Power signal with plot Signal in time
%domain 
clc
clear
Power=[];
Energy=[];

[x,FS] = audioread('Sound\s.wav');
[Power,Energy]=Calc (x,FS,'Sound S',Power,Energy);

[x,FS] = audioread('Sound\aa.wav');
[Power,Energy]=Calc (x,FS,'Sound A',Power,Energy);

fprintf('\n -------------------------------------------\n');
Disply={'Result','Sound S','Sound A'};
Disply(end+1,:)={'--------','--------','--------'};
Disply(end+1,:)={'Power',num2str(Power(1)),num2str(Power(2))};
Disply(end+1,:)={'--------','--------','--------'};

Disply(end+1,:)={'Energy',num2str(Energy(1)),num2str(Energy(2))};
Disply(end+1,:)={'--------','--------','--------'};

disp(Disply(:,:));

end

function  [Power,Energy]=Calc(x,FS,NameSound,Power,Energy)
%Input Vector Sound $ Frequency & NameSound
%OutPut Energy and Power signal with plot Signal in time
 f=figure('Visible','on');
N = length(x);
t = 0:N-1;
subplot(311)
stem(t,x,'k-','fill');
xlabel('Time (s)'); ylabel('Amplitude');
title(strcat('Time domain -Input sequence',NameSound))
%fft
X=fft(x);
X=fftshift(X);
%%%%%%%%
fprintf('\n---------4 First Sample :%s---------\n',NameSound);
disp(X(1:4));
fprintf('\n---------4 End Sample :%s---------\n',NameSound);
disp(X(N-3:end));
%%%%%%%%
subplot(312)
stem(t,abs(X),'r-','fill')
xlabel('Frequency'); ylabel('Magnitude');
title('Frequency domain -Magnitude response')
subplot(313)
stem(t,unwrap( angle(X)),'b-','fill')
xlabel('Frequency'); ylabel('Phase');
title('Frequency domain -Phase response')

%Power & Energy
Power(end+1) = (norm(X)^2)/length(X);
Energy(end+1) = (norm(X)^2);

end

