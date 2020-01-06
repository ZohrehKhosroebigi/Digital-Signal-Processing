%----------------------------------read Data From TrainSet  And TestSet
if  ~(exist('.\TrainSet.mat'))
    TrainSet={};
    for i = 1:10
        path=strcat('.\TrainSet\',num2str(i-1));
        folder=dir(path);
        for j=3:size(folder,1)
            WaveFile=folder(j).name;
            WaveFile=strcat(path,'\',WaveFile);
            VecCep=audioread(WaveFile);
            TrainSet(i,j-2)={VecCep};
        end
    end
    save('.\TrainSet.mat','TrainSet');
end
if~(exist('.\TestSet.mat'))
    TestSet={};
    for i = 1:10
        path=strcat('.\TestSet\',num2str(i-1));
        folder=dir(path);
        for j=3:size(folder,1)
            WaveFile=folder(j).name;
            WaveFile=strcat(path,'\',WaveFile);
            VecCep=audioread(WaveFile);
            TestSet(i,j-2)={VecCep};
        end
    end
    save('.\TestSet.mat','TestSet');
end
%-----------------------------Load Data-------------------------
close all ;
clear;
clc;
load('TrainSet');
load('TestSet');
%-----------------------------Calc Mean and Variance-------------------------
% w = repmat(struct('miu' , 0 , 'var' , 0),10,1);
Mean=[];
Variance=[];
%ZCR= Sum OF Change Sign=>sum(abs(sign(sign(X[n])-sign(X[n-1]))))
FuncZCR=@(X,Y) sum(abs(sign(sign(X)-sign(Y))));
FuncGaosian =@(x,Miu,Var) (1/sqrt(2*pi*Var))*exp(-(((x-Miu)^2)/(2*Var)));
Numbers=[1,5,8];
VectfeautreZCR=[];
%-------------------------Calc Mean And Variance feautre(ZCR)----------------------------------
for i = 1:numel(Numbers)
    SumX = 0;
    SumzeroX = 0;
    NumberSignals=TrainSet(Numbers(i)+1,:);%kole signal haye yek adad (mesle 1 or 5 or 8)
    for j = 1:numel(NumberSignals)
        Signal=NumberSignals{:,j};
        VectfeautreZCR(i,j)=1e-3*FuncZCR(Signal(2:numel(Signal)),Signal(1:numel(Signal)-1));% feautre ZCR       
        SumX = SumX +VectfeautreZCR(i,j) ;%Sum(feautre))
        SumzeroX = SumzeroX + (VectfeautreZCR(i,j)^2);%Sum(feautre^2)
    end
    Mean = SumX/numel(NumberSignals);%E(feautre) har adad
    Variance = (SumzeroX/numel(NumberSignals)) - (Mean^2);%E(feautre^2)-(E(feautre))^2
    M1 = min(VectfeautreZCR(i,:));
    M2 = max(VectfeautreZCR(i,:));
    f = @(x) normpdf(x, Mean,Variance);
    integral(f,2,10);
    x =M1:0.01:M2;
    figure
    plot(x,f(x))
    title({['Norm Number Of : ' num2str(Numbers(i))]});
    figure
    histogram(VectfeautreZCR(i,:))
    title({['Histogram Number Of : ' num2str(Numbers(i))]});
  end
%-----------------------------------------------------------
