
function MLPPowerZCR100( )
clc;
clear All
FeatureExtract();
load '.\Data\DatatrainPZ100';
load '.\Data\DataTestPZ100';
Target=(2*eye(10)-ones(10));
sizedata=size(Datatrain,2)-1;
%-----------------------------------------------------------------
Alpha=0.1;
disp('-----------------------------------------------------------------------------------');
Disply={' Error Terain',' Error Test','Iteration'};
Disply(end+1,:)={'--------','--------','------------'};
NumberNeronHidden=25;
ErrorTest=[];
ErrorTrain=[];
ArrayErr=[];
Stop=0;
Iteration=0;
MaxInteration=1000;
DeltaV=zeros(NumberNeronHidden,sizedata);
V=-ones(NumberNeronHidden,sizedata)+(0.2);
DeltaW=zeros(size(Target,2),NumberNeronHidden+1);
W=-ones(size(Target,2),NumberNeronHidden+1)+(0.2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while(Stop~=1)
    cnt =0;
    Iteration=Iteration+1;
    FunActive= @(x) (2/(1+exp(-x)))-1;
    FunPrim=@(F) (1/2)*((1+F)*(1-F));
    shuffle=[1:1900];%randperm(size(Datatrain,1));
    for i=1:length(shuffle)
        cnt=Datatrain(shuffle(i),102);
        %-----------------------------------
        z_in=[];
        Z=[];
        y_in=[];
        Y=[];
        delta_2=[];
        delta_in=[];
        delta_1=[];
        for j=1:NumberNeronHidden
            z_in(j)=sum(V(j,:).*(Datatrain(shuffle(i),1:101)));
            Z(j)=FunActive(z_in(j));
        end
        Z(j+1)=1;%bias
        for j=1:size(Target,2)
            y_in(j)=sum(W(j,:).*(Z));
            Y(j)=FunActive(y_in(j));
            if abs(Target(cnt,j)-Y(j))<=0.4
                Y(j)=Target(cnt,j);
            end
        end
        %------------------------------------------------
        for j=1:size(Target,2)
            delta_2(j)=FunPrim(Y(j))*(Target(cnt,j)-Y(j));
        end
        for j=1:size(Target,2)
            for k=1:NumberNeronHidden+1
                DeltaW(j,k)=Alpha*delta_2(:,j)*Z(:,k);
            end
        end
        for k=1:NumberNeronHidden
            delta_in(k)=sum(W(:,k).*(delta_2'));
            delta_1(k)=delta_in(k)*FunPrim(Z(k));
        end
        
        for k=1:NumberNeronHidden
            DeltaV(k,:)=Alpha*delta_1(:,k)*Datatrain(shuffle(i),1:101);
        end
        %--------------------------------update weights
        W=DeltaW+W;
        V=DeltaV+V;
        %         if mod(i,190)==0
        %             cnt=cnt+1;
        %         end
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ErrorTrain=RateError(NumberNeronHidden,Target,Datatrain,V,W,FunActive);
    ErrorTest=RateError(NumberNeronHidden,Target,Datatest,V,W,FunActive);
    ArrayErr=[ArrayErr;Iteration ErrorTrain ErrorTest];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Iteration>=MaxInteration || ErrorTrain==0 || ErrorTest<=10 )
        Stop=1;
        Disply(end+1,:)={num2str(ErrorTrain),num2str(ErrorTest),num2str(Iteration)};
    end
end
if ~(exist('.\Plot','file'))
    mkdir('.\Plot');
end
f=figure('Visible','on');
hold on
grid minor
title({['alpha : ' num2str(Alpha)];...
    ['Number Of Hiden Layer Neurons : ' num2str(NumberNeronHidden)]});
xlabel('Iteration');
ylabel('% Error');
plot(ArrayErr(:,1),ArrayErr(:,2),'r');legend1='ErrorTrain';
plot(ArrayErr(:,1),ArrayErr(:,3),'b');legend2='ErrorTest';
legend(legend1,legend2);
filename=strcat('.\Plot\PLOT-alpha',num2str(Alpha),'-N',num2str(NumberNeronHidden),'.jpg');
if  exist(filename,'file')
    delete (filename);
end
saveas(f,filename,'jpg')
disp(Disply);
end
function Error=RateError(NumberNeronHidden,Target,Data,V,W,FunActive)
cnt=1;
lendata=size(Data,1);
for i=1:lendata
    cnt=Data(i,102);
    %-----------------------------------
    for j=1:NumberNeronHidden
        z_in(j)=sum(V(j,:).*(Data(i,1:101)));
        Z(j)=FunActive(z_in(j));
    end
    Z(j+1)=1;%bias
    for j=1:size(Target,2)
        y_in(j)=sum(W(j,:).*(Z));
        Y(i,j)=FunActive(y_in(j));
        if abs(Target(cnt,j)-Y(i,j))<=0.4
            Y(i,j)=Target(cnt,j);
        end
    end
    %------------------------------------------------
    %     if mod(i,190)==0
    %         cnt=cnt+1;
    %     end
end
trcorrect = 0;
cnt =1;
for i=1:lendata
    cnt=Data(i,102);
    if sum(Y(i,:)==Target(cnt,:))==10
        trcorrect = trcorrect+1;
        
    end
    %     if mod(i,190)==0
    %         cnt=cnt+1;
    %     end
end
Error=((lendata-trcorrect)/lendata)*100;
end

function FeatureExtract()
Datatrain=[];
Datatest=[];
FuncPower=@(Signal) (sum(Signal.^2))/numel(Signal);
FuncZCR=@(X,Y) sum(abs(sign(sign(X)-sign(Y))));

%----------------------------------read Data From TrainSet  And TestSet
s=0;
if ~(exist('.\Data','file'))
    mkdir('.\Data');
end
if  ~(exist('.\Data\DataTrainPZ100.mat'))
    for i = 1:10
        path=strcat('.\TrainSet\',num2str(i-1));
        folder=dir(path);
        for j=3:size(folder,1)
            WaveFile=folder(j).name;
            WaveFile=strcat(path,'\',WaveFile);
            Signal=audioread(WaveFile);
            lensegment=length(Signal)/50;
            s=s+1;
            d=0;
            for k=1:50
                Segment = Signal(round((k-1)*lensegment+1):round(k*lensegment));
                d=d+1;
                Datatrain(s,d) = FuncPower(Segment);
                d=d+1;
                Datatrain(s,d) =FuncZCR(Segment(2:numel(Segment)),Segment(1:numel(Segment)-1));
                
            end
            
            Datatrain(s,102) = i;
        end
    end
    Datatrain(:,101)=1;
    if ~(exist('.\Data','file'))
        mkdir('.\Data');
    end
    save('.\Data\DataTrainPZ100.mat','Datatrain');
end
s=0;
if~(exist('.\Data\DataTestPZ100.mat'))
    for i = 1:10
        path=strcat('.\TestSet\',num2str(i-1));
        folder=dir(path);
        for j=3:size(folder,1)
            WaveFile=folder(j).name;
            WaveFile=strcat(path,'\',WaveFile);
            Signal=audioread(WaveFile);
            lensegment=length(Signal)/50;
            s=s+1;
            d=0;
            for k=1:50
                Segment = Signal(round((k-1)*lensegment+1):round(k*lensegment));
                d=d+1;
                Datatest(s,d) = FuncPower(Segment);
                d=d+1;
                Datatest(s,d) =FuncZCR(Segment(2:numel(Segment)),Segment(1:numel(Segment)-1));
                
            end
            
            Datatest(s,102) = i;
            
        end
    end
    Datatest(:,101)=1;
    save('.\Data\DataTestPZ100.mat','Datatest');
    
end
end


