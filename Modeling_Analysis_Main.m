
%% Set up the conditions
clear;
clc;
close all;

load DataSet_All;
load ParamSet_All;

DataSet1=DataSet_All;
ParamSet1=ParamSet_All;

% DataSet=DataSet1(:,end-69:end);
DataSet=DataSet1(:,end-81:end);

n=1;
mData=struct();

for sub=1:length(DataSet)
    mData(n).subject = DataSet1(sub,1);
    mData(n).SVO = DataSet1(sub,2);
    mData(n).IA = DataSet1(sub,3);
    mData(n).C= 4;   % number of choice options
    mData(n).N= size(DataSet,2); % number of trials
    mData(n).my = ParamSet1(:,1);
    mData(n).other = ParamSet1(:,2);
    mData(n).r  = zscore(DataSet(sub,:))';   
    n=n+1;
end

%% set up the "option" structure
%  establishing Option structure - using factorial_models
fopts=struct();
fopts.my = [0,1];
fopts.other = [0,1];
fopts.abs = [0,1];
fopts.guilt = [0,1];
fopts.envy = [0,1];
% fopts.pself = [0,1];
fopts.socialratio =0;
fopts.selfish=0;
fopts.inequal = 0;
fopts.reference = 0;
fopts.socialscale = 0;

fopts.gain2self = [0];
fopts.gain2other = [0];
fopts.loss2self = [0];
fopts.loss2other = [0];
    
% fopts.guilt_context=[0,1];
% fopts.envy_context=[0,1];
% fopts.pself_context=[0,1];
% fopts.socialratio_context=0;   
% fopts.selfish_context=0;

Dopts1 = factorial_models(fopts); 
Dopts1=Dopts1([4,8,28]);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fopts=struct();
fopts.my = 0;
fopts.other = [0];
fopts.abs = [0];
fopts.guilt = [0];
fopts.envy = [0];
fopts.socialratio = [0,1];
fopts.selfish = [0,1];
fopts.inequal = [0,1];
fopts.reference = [0,1];
fopts.socialscale = [0,1];

fopts.gain2self = [0];
fopts.gain2other = [0];
fopts.loss2self = [0];
fopts.loss2other = [0];

% fopts.guilt_context=0;
% fopts.envy_context=0;
% fopts.pself_context=[0,1];
% fopts.socialratio_context=[0,1];   
% fopts.selfish_context=[0,1];

Dopts2 = factorial_models(fopts); 

Lossmodel1=Dopts2(:,9);
Lossmodel1.reference=0;
Lossmodel1.gain2self=1;
Lossmodel1.gain2other=1;
Lossmodel1.loss2self=1;

Lossmodel2=Dopts2(:,9);
Lossmodel2.reference=0;
Lossmodel2.gain2self=1;
Lossmodel2.gain2other=1;
Lossmodel2.loss2self=1;
Lossmodel2.loss2other=1;

Lossmodel=[Lossmodel1,Lossmodel2];

% Dopts2 =Dopts2 (1,[4,5,8,25,29]);
% Dopts2 =Dopts2 (1,[25,29]);

Dopts2 =Dopts2 (1,[4,5,8]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dopts=[Dopts1,Dopts2,Lossmodel];

%Dopts = Dopts(2:end); % get rid of null model 
          
%% modelling analysis
SVO=[mData.SVO]';
Proself=mData(SVO<22.5);
Prosocial=mData(SVO>22.5);

ModelResult=[];
[results, bms_results] = fit_models(Prosocial,Dopts);
ModelResult(1,1).results=results;
ModelResult(1,1).bms_results=bms_results;

[results, bms_results] = fit_models(Proself,Dopts);
ModelResult(1,2).results=results;
ModelResult(1,2).bms_results=bms_results;