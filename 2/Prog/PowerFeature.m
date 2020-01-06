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
% vector = repmat(struct('E' , 0 , 'var' , 0),10,1);
Mean=[];
Variance=[];
FuncPower=@(Signal) (sum(Signal.^2))/numel(Signal);
FuncGaosian =@(x,Miu,Var) (1/sqrt(2*pi*Var))*exp(-(((x-Miu)^2)/(2*Var)));
Numbers=[1,5,8];
VectfeautrePower=[];
%-------------------------Calc Mean And Variance feautre(Power)----------------------------------
for i = 1:numel(Numbers)
    SumX = 0;
    SumPowerX = 0;
    NumberSignals=TrainSet(Numbers(i)+1,:);%kole signal haye yek adad (mesle 1 or 5 or 8)
    for j = 1:numel(NumberSignals)
        Signal=NumberSignals{:,j};
        VectfeautrePower(i,j)=1e+1*FuncPower(Signal);% feautre Power
        SumX = (SumX +VectfeautrePower(i,j)) ;%Sum(feautre))
        SumPowerX = SumPowerX + (VectfeautrePower(i,j)^2);%Sum(feautre^2)
    end
    Mean = SumX/numel(NumberSignals);%E(feautre) har adad
    Variance = (SumPowerX/numel(NumberSignals)) - (Mean(end)^2);%E(feautre^2)-(E(feautre))^2
    M1 = min(VectfeautrePower(i,:));
    M2 = max(VectfeautrePower(i,:));
    x = -M1:0.0001:M2;
    figure
    plot(x,normpdf(x, Mean,Variance))
    title({['Norm Number Of : ' num2str(Numbers(i))]});
    figure
    histogram(VectfeautrePower(i,:))
    title({['Histogram Number Of : ' num2str(Numbers(i))]});
    
end
%-----------------------------------------------------------


