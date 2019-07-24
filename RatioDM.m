function [lik, latents] = RatioDM(x,data,opts)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% set parameters
    y=ones(1,14);
    y(opts.ix==1) = x;
       
    if ~opts.my; y(1)=0; end
    if ~opts.other; y(2)=0; end 
    if ~opts.abs; y(3)=0; end     
    if ~opts.guilt; y(4)=0; end
    if ~opts.envy; y(5)=0; end  
    if ~opts.socialratio; y(6)=0; end     
    if ~opts.selfish; y(7)=0; end 
    if ~opts.inequal; y(8)=0; end
    if ~opts.reference; y(9)=0; end
    if ~opts.socialscale; y(10)=0; end
    
    
    if ~opts.gain2self; y(11)=0; end 
    if ~opts.gain2other; y(12)=0; end
    if ~opts.loss2self; y(13)=0; end 
    if ~opts.loss2other; y(14)=0; end        
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    %% parameters
    betamy = y(1);        
    betaother = y(2);      
    betaabs = y(3);
    betaguilt = y(4);          
    betaenvy = y(5);               
    a = y(6); 
    b = y(7);
    c = y(8);
    d = y(9);
    e = y(10);

    x1=y(11);
    x2=y(12);
    x3=y(13);
    x4=y(14);    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

    %% Modelling
    lik = 0; C = data.C;
    
    for n = 1:data.N
        
        % reset values and stickiness for new block or first trial
%         if n == 1 || data.block(n)~=data.block(n-1)
%             Q = ones(1,C)/C;    % initial action values
%         end
        
        % data for current trial        
        myoption = data.my(n);
        otheroption = data.other(n);
        prference = data.r(n);
        
    %% core part %%%%%%%%%%%%%%%%%%        
%         if c==0 % skip no repsonse trials
%             continue
%         end
        
%         if data.block(n)==1 || data.block(n)==2 %- fMRI
            
%         if data.block(n)==3 %- Postscan behavior 

            
        if x1==1 && x2==1 && x3==1 && x4==0
            preferpred = x1*max(0,myoption)+x2*max(0,otheroption)+x3*min(0, myoption)+x3* min(0, otheroption);
            
        elseif x1==1 && x2==1 && x3==1 && x4==1
            preferpred = x1*max(0,myoption)+x2*max(0,otheroption)+x3*min(0, myoption)+x4* min(0, otheroption);
            
        else
            preferpred = betamy*myoption + betaother*otheroption + betaabs*abs(myoption-otheroption) ...
                + betaguilt*(max([0,myoption-otheroption])) + betaenvy*(max([0,otheroption-myoption]))... 
            + a*cosd(atand(otheroption/myoption)+180*(myoption<0)) + b*sind(atand(otheroption/myoption)+180*(myoption<0))...
            + c*cosd(atand(otheroption/myoption)+180*(myoption<0)-45) + e*cosd(atand(otheroption/myoption)+180*(myoption<0)-d);
        end
                 
%         elseif data.block(n)==3 %-Postscan behavior
%             
%             preferpred = betamy*myoption + betaother*otheroption + betaabs*abs(myoption-otheroption) ...
%                 + Cbetaguilt*(max([0,myoption-otheroption])) + Cbetaenvy*(max([0,otheroption-myoption]))... 
%             + (1-Cpself)*(double(otheroption>=0)) + Cpself*(double(myoption>0))...
%             + Ca*cos(atan(otheroption/myoption)) + Cb*sin(atan(otheroption/myoption));           
            
%         end
        
        sse = (prference-preferpred).^2.*-1;
        lik=lik+sse;

%           sse = abs(prference-preferpred)*-1;
%           lik=lik+sse;

        %re=sum((prference-mean(prference)).^2); r2 = 1-(sse/re);
        
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    %% store latent variables
        if nargout > 1
            
            latents.Q(n,:) = prference;
            latents.W(n,:) = preferpred;
%             latents.P(n,:) = P;
%             latents.predict = [prference,preferpred];       
%             latents.R2=r2; 
            
        end    
        
    end
end