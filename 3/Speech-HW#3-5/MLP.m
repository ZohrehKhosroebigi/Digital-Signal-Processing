
function MLP( )
clc;
clear All
Speech_MFCC;
load '.\Data\DataTrain';
load '.\Data\DataTest';
Target=(2*eye(10)-ones(10));
sizedata=size(DataTrain,2)-1;
%-----------------------------------------------------------------
Alpha=0.2;
disp('-----------------------------------------------------------------------------------');
Disply={' Error Terain',' Error Test','Iteration'};
Disply(end+1,:)={'--------','--------','------------'};
NumberNeronHidden=500;
ErrorTest=[];
ErrorTrain=[];
ArrayErr=[];
Stop=0;
Iteration=0;
MaxInteration=500;
DeltaV=zeros(NumberNeronHidden,sizedata);
a=-0.2;b=0.2;A=a+(b-a)*rand(NumberNeronHidden,sizedata);V=A;
% V=-ones(NumberNeronHidden,sizedata)+(0.2);
DeltaW=zeros(size(Target,2),NumberNeronHidden+1);
a=-0.2;b=0.2;A=a+(b-a)*rand(size(Target,2),NumberNeronHidden+1);W=A;
% W=-ones(size(Target,2),NumberNeronHidden+1)+(0.2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    shuffle=randperm(size(DataTrain,1));
    for i=1:length(shuffle)
        cnt=DataTrain(shuffle(i),sizedata+1);
        %-----------------------------------
        z_in=[];
        Z=[];
        y_in=[];
        Y=[];
        delta_2=[];
        delta_in=[];
        delta_1=[];
        for j=1:NumberNeronHidden
            z_in(j)=sum((V(j,:).*(DataTrain(shuffle(i),1:sizedata))));
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
            DeltaV(k,:)=Alpha*delta_1(:,k)*DataTrain(shuffle(i),1:sizedata);
        end
        %--------------------------------update weights
        W=DeltaW+W;
        V=DeltaV+V;
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    save  ('.\Data\W','W');
    save  ('.\Data\V','V');
    save('.\Data\ArrayErr','ArrayErr');
    save('.\Data\Iteration','Iteration');
    [ErrorTrain,ConfusionMatrix]=RateError(NumberNeronHidden,Target,DataTrain,V,W,FunActive,sizedata);
    [ErrorTest,ConfusionMatrix]=RateError(NumberNeronHidden,Target,DataTest,V,W,FunActive,sizedata);
    ArrayErr=[ArrayErr;Iteration ErrorTrain ErrorTest];
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if (Iteration>=MaxInteration || ErrorTrain==0 || ErrorTest<=10 )
        f1 = figure('name','Train set Confusion Matrix');
        t = uitable(f1,'Data',ConfusionMatrix);
        t = uitable(f1,'Data',ConfusionMatrix,'BackgroundColor',[1 0 1;1 1 1]);
        t.Position = [10 10 1000  430];
        t.ColumnName = {0:9};
        t.RowName = {0:9};
        Stop=1;
        filename=strcat('.\Plot\Confusion-alpha',num2str(Alpha),'-N',num2str(NumberNeronHidden),'.jpg');
        if  exist(filename,'file')
            delete (filename);
        end
        saveas(f1,filename,'jpg')
    end
    Disply(end+1,:)={num2str(ErrorTrain),num2str(ErrorTest),num2str(Iteration)};
    save('.\Data\Disply','Disply');
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




