
function MLPNormaliz( )
clc;
clear All
Speech_MFCC;
load '.\Data\DataTrainCMS';
load '.\Data\DataTestCMS';
Target=(2*eye(10)-ones(10));
sizedata=size(DataTrainCMS,2)-1;
%-----------------------------------------------------------------
Alpha=0.2;
disp('-----------------------------------------------------------------------------------');
Disply={' Error Terain',' Error Test','Iteration'};
Disply(end+1,:)={'--------','--------','------------'};
NumberNeronHidden=1500;
ErrorTest=[];
ErrorTrain=[];
ArrayErr=[];
Stop=0;
Iteration=0;
MaxInteration=500;
DeltaV=zeros(NumberNeronHidden,sizedata);
a=-0.2;b=0.2;A=a+(b-a)*rand(NumberNeronHidden,sizedata);V=A;

DeltaW=zeros(size(Target,2),NumberNeronHidden+1);
a=-0.2;b=0.2;A=a+(b-a)*rand(size(Target,2),NumberNeronHidden+1);W=A;

%%%%%%%%%%%%%%%%%%%%%%%%%   CMS    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Temp=DataTrain(:,1:sizedata-1);
% Temp=Temp-repmat(mean(Temp(:)),size(Temp,1),size(Temp,2));
% Temp(:,end+1)=1;
% Temp(:,end+1)=DataTrain(:,sizedata+1);
% DataTrain=Temp;
%
% Temp=DataTest(:,1:sizedata-1);
% Temp=Temp-repmat(mean(Temp(:)),size(Temp,1),size(Temp,2));
% Temp(:,end+1)=1;
% Temp(:,end+1)=DataTest(:,sizedata+1);
% DataTest=Temp;
%_________________________________________________________________________
f=figure('Visible','on');
hold on
grid minor
if ~(exist('.\Plot','file'))
    mkdir('.\Plot');
end

while(Stop~=1)
    cnt =0;
    Iteration=Iteration+1;
    
    FunActive= @(x) (2/(1+exp(-x)))-1;
    FunPrim=@(F) (1/2)*((1+F)*(1-F));
    shuffle=randperm(size(DataTrainCMS,1));
    for i=1:length(shuffle)
        cnt=DataTrainCMS(shuffle(i),sizedata+1);
        %-----------------------------------
        z_in=[];
        Z=[];
        y_in=[];
        Y=[];
        delta_2=[];
        delta_in=[];
        delta_1=[];
        for j=1:NumberNeronHidden
            z_in(j)=sum((V(j,:).*(DataTrainCMS(shuffle(i),1:sizedata))));
            Z(j)=FunActive(z_in(j));
        end
        Z(j+1)=1;%bias
        for j=1:size(Target,2)
            y_in(j)=sum((W(j,:).*(Z)));
            Y(j)=FunActive(y_in(j));
        end
        Y=(softmax(Y'))';
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
            DeltaV(k,:)=Alpha*delta_1(:,k)*DataTrainCMS(shuffle(i),1:sizedata);
        end
        %--------------------------------update weights
        W=DeltaW+W;
        V=DeltaV+V;
       
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save  ('W1','W');
    save  ('V1','V');
    save('ArrayErr','ArrayErr');
    save('Iteration','Iteration');
    [ErrorTrain,ConfusionMatrix]=RateError(NumberNeronHidden,Target,DataTrainCMS,V,W,FunActive,sizedata);
    [ErrorTest,ConfusionMatrix]=RateError(NumberNeronHidden,Target,DataTestCMS,V,W,FunActive,sizedata);
    ArrayErr=[ArrayErr;Iteration ErrorTrain ErrorTest];
    title({['alpha : ' num2str(Alpha)];...
        ['Number Of Hiden Layer Neurons : ' num2str(NumberNeronHidden)]});
    xlabel('Iteration');
    ylabel('% Error');
    plot(ArrayErr(:,1),ArrayErr(:,2),'r');legend1='ErrorTrainCMS';
    plot(ArrayErr(:,1),ArrayErr(:,3),'b');legend2='ErrorTestCMS';
    legend(legend1,legend2);
    filename=strcat('.\Plot\PLOTCMS-alpha',num2str(Alpha),'-N',num2str(NumberNeronHidden),'.jpg');
    if  exist(filename,'file')
        delete (filename);
    end
    saveas(f,filename,'jpg')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Iteration>=MaxInteration || ErrorTrain==0 || ErrorTest<=10 )
        f1 = figure('name','Test set Confusion Matrix');
        t = uitable(f1,'Data',ConfusionMatrix);
        t = uitable(f1,'Data',ConfusionMatrix,'BackgroundColor',[1 0 1;1 1 1]);
        t.Position = [20 10 1000  430];
        t.ColumnName = {0:9};
        t.RowName = {0:9};
        Stop=1;
        filename=strcat('.\Plot\ConfusionCMS-alpha',num2str(Alpha),'-N',num2str(NumberNeronHidden),'.jpg');
        if  exist(filename,'file')
            delete (filename);
        end
        saveas(f1,filename,'jpg')
    end
    Disply(end+1,:)={num2str(ErrorTrain),num2str(ErrorTest),num2str(Iteration)};
    save('Disply','Disply');
end



disp(Disply);
end
function [Error,ConfusionMatrix]=RateError(NumberNeronHidden,Target,Data,V,W,FunActive,sizedata)
cnt=1;
lendata=size(Data,1);
for i=1:lendata
    cnt=Data(i,sizedata+1);
    %-----------------------------------
    for j=1:NumberNeronHidden
        z_in(j)=sum((V(j,:).*(Data(i,1:sizedata))));
        Z(j)=FunActive(z_in(j));
    end
    Z(j+1)=1;%bias
    for j=1:size(Target,2)
        y_in(j)=sum((W(j,:).*(Z)));
        Y(i,j)=FunActive(y_in(j));
        
    end
    %------------------------------------------------
    Y(i,:)=(softmax(Y(i,:)'))';
end
trcorrect = 0;
cnt =1;
ConfusionMatrix=zeros(10,10);
for i=1:lendata
    cnt=Data(i,sizedata+1);
    [~,indx]=max(Y(i,:));
    Tmp=-ones(1,size(Target,2));
    Tmp(indx) =1;
    
    mask=bsxfun(@eq,Target,Y(i,:));
    result= find(sum(mask)==1);
    if (length(result)>0)
        ConfusionMatrix(cnt,result(1))=ConfusionMatrix(cnt,result(1))+1;
    end
    
    if isequal(Tmp,Target(cnt,:))
        trcorrect=trcorrect+1;
    end
end
Error=((lendata-trcorrect)/lendata)*100;

ConfusionMatrix=(ConfusionMatrix/30)*100;

end




