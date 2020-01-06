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
FuncPower=@(Signal) (norm(Signal)^2)/numel(Signal);
FuncGaosian =@(x,Miu,Var) 1/sqrt(2*pi*Var)*exp(-0.5*((x-Miu)^2)/(2*Var));
Numbers=[1,5,8];
VectfeautrePower=[];
%-------------------------Calc Mean And Variance feautre(Power)----------------------------------
for i = 1:numel(Numbers)
    SumX = 0;
    SumPowerX = 0;
    NumberSignals=TrainSet(Numbers(i),:);%kole signal haye yek adad (mesle 1 or 5 or 8)
    for j = 1:numel(NumberSignals)
        VectfeautrePower(i,j)=FuncPower(NumberSignals{:,j});% feautre Power       
        SumX = SumX +VectfeautrePower(i,j) ;%Sum(feautre))
        SumPowerX = SumPowerX + (VectfeautrePower(i,j)^2);%Sum(feautre^2)
    end
    Mean(end+1) = SumX/numel(NumberSignals);%E(feautre) har adad
    Variance(end+1) = (SumPowerX/numel(NumberSignals)) - (Mean(end)^2);%E(feautre^2)-(E(feautre))^2
  end
%-----------------------------------------------------------
Gavsian=[];
for i=1:numel(Numbers)
    feautre=VectfeautrePower(i,:);
    for j = 1:numel(NumberSignals)
         Gavsian(i,j)=FuncGaosian(feautre(:,j),Mean(i),Variance(i));
    end
end
hist(Mean,Numbers);
figure;
stem(Numbers,Gavsian);
