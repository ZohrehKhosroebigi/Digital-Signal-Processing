function  SmoothSound(  )
%Input Sound Then Call Smooth Function For Smoothind Sound
% Attention: Median is Array in 100,1000,3000
clc
clear
[x,FS] = audioread('Sound\s.wav');
Smooth (x,FS,'Sound S');
[x,FS] = audioread('Sound\aa.wav');
Smooth (x,FS,'Sound A');
[x,FS] = audioread('Sound\aseman.wav');
Smooth (x,FS,'Sound Aseman');

end

function  Smooth(x,FS,NameSound)
%Input Vector Sound $ Frequency & NameSound
%OutPut Sound Smooth & Chart
[S100] = audioread('Sound\SmoothS100.wav');
[S1000] = audioread('Sound\SmoothS1000.wav');
[S3000] = audioread('Sound\SmoothS3000.wav');
[A100] = audioread('Sound\SmoothA100.wav');
[A1000] = audioread('Sound\SmoothA1000.wav');
[A3000] = audioread('Sound\SmoothA3000.wav');
[Aseman100] = audioread('Sound\SmoothAseman100.wav');
[Aseman1000] = audioread('Sound\SmoothAseman1000.wav');
[Aseman3000] = audioread('Sound\SmoothAseman3000.wav');
%Clac Smoothing Sound With N=100 ,1000,3000 And Play 
N=[100,1000,3000];
Len = length(x);
Y=zeros(length(x),1);
for i=1:length(N)
    L=N(i)/2;
    for Nselect=1: Len
        if Nselect-L<0
            sample=x(1:Nselect+L-1);
        elseif Nselect-L==0
            sample=x(1:Nselect+L);
        elseif Nselect+L>=Len
            sample=x(Nselect-L+1:Len);
        else
            sample=x(Nselect-L+1:Nselect+L);
        end
        Y(Nselect)=median(sample);
    end
    %Play Info Type Sound
    switch NameSound
        case 'Sound A'
            if N(i)==100
                pause(5)
                sound(A100,FS);
            elseif N(i)==1000
                pause(5)
                sound(A1000,FS);
            else
                pause(5)
                sound(A3000,FS);
            end
            
        case 'Sound S'
            if N(i)==100
                pause(5)
                sound(S100,FS);
            elseif N(i)==1000
                pause(5)
                sound(S1000,FS);
            else
                pause(5)
                sound(S3000,FS);
            end
            
        otherwise
            if N(i)==100
                pause(5)
                sound(Aseman100,FS);
            elseif N(i)==1000
                pause(5)
                sound(Aseman1000,FS);
            else
                pause(5)
                sound(Aseman3000,FS);
            end
            
    end
    %Play Smooth Sound
    pause(5)
    sound(Y,FS);
    %Drowing Plot
    f=figure('Visible','off');
    t = 0:Len-1;
    subplot(311)
    plot(t,x,'b-');
    xlabel('Time (s)'); ylabel('Amplitude');
    Title=strcat('Time domain -',NameSound ,'-N=',num2str(N(i)));
    title(Title)
    subplot(312)
    X=Y;
    plot(t,abs(X),'r-')
    xlabel('Time (s)'); ylabel('Amplitude');
    Title=strcat('Time domain -Smooth -',NameSound ,'-N=',num2str(N(i)));
    title(Title)
    %Save Sound &Plot Smooth Sound
    if ~(exist('.\Plot\','file'))
        mkdir('.\Plot\');
    end
    if ~(exist('.\Smooth\','file'))
        mkdir('.\Smooth\');
    end
    NameFilePlot=strcat('.\Plot\',NameSound ,'-N=',num2str(N(i)),'.jpg');
    NameFileSound=strcat('.\Smooth\',NameSound ,'-N=',num2str(N(i)),'.wav');
    wavwrite(real(Y),FS,NameFileSound);
    saveas(f,NameFilePlot,'jpg');
    
end
end

