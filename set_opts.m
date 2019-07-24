function [opts, param] = set_opts(opts)
    
    % default options
    def_opts.go_bias = false;
    def_opts.sticky = false;
    
    def_opts.my = false;
    def_opts.other = false;
    def_opts.abs = false;
    def_opts.guilt = false;
    def_opts.envy = false;
    def_opts.socialratio =false;
    def_opts.selfish=false;
    def_opts.inequal=false;
    def_opts.reference=false;
    def_opts.socialscale=false;
    
    def_opts.gain2self=false;
    def_opts.gain2other=false;
    def_opts.loss2self=false;
    def_opts.loss2other=false;
    
    def_opts.latents = false;
    
    % fill in missing or empty fields
    if nargin < 1 || isempty(opts)
        opts = def_opts;
    else
        F = fieldnames(def_opts);
        for f = 1:length(F)
            if ~isfield(opts,F{f}) || isempty(opts.(F{f}))
                opts.(F{f}) = def_opts.(F{f});
            end
        end
    end
    
    opts.ix = ones(1,14);
    
    if ~opts.my; opts.ix(1)=0; end
    if ~opts.other; opts.ix(2)=0; end 
    if ~opts.abs; opts.ix(3)=0; end     
    if ~opts.guilt; opts.ix(4)=0; end
    if ~opts.envy; opts.ix(5)=0; end 
    if ~opts.socialratio; opts.ix(6)=0; end     
    if ~opts.selfish; opts.ix(7)=0; end  
    if ~opts.inequal; opts.ix(8)=0; end 
    if ~opts.reference; opts.ix(9)=0; end 
    if ~opts.socialscale; opts.ix(10)=0; end 
    
    if ~opts.gain2self; opts.ix(11)=0; end 
    if ~opts.gain2other; opts.ix(12)=0; end
    if ~opts.loss2self; opts.ix(13)=0; end 
    if ~opts.loss2other; opts.ix(14)=0; end    
    
    
    %---------- create parameter structure ---------------%
       
    param(1).name = 'betamy';
    param(1).hp = [0 10]; % hyperparameters of the normal prior
    param(1).logpdf = @(x) sum(log(normpdf(x,param(1).hp(1),param(1).hp(2))));  % log density function for prior
    param(1).lb = -5;    % lower bound
    param(1).ub = 5;     % upper bound
    param(1).fit = @(x) [mean(x) std(x)];
    
    param(2) = param(1);
    param(2).name = 'betaother';
    
    param(3) = param(1);
    param(3).name = 'betaabs';  

    param(4) = param(1);
    param(4).name = 'betaguilt'; 
    
    param(5) = param(1);
    param(5).name = 'betaenvy'; 
    
    param(6) = param(1);
    param(6).name = 'socialratio';
    
    param(7) = param(1);
    param(7).name = 'selfish'; 
    
    param(8) = param(1);
    param(8).name = 'inequal'; 
        
    param(9) = param(1);
    param(9).name = 'reference';      
    param(9).hp = [0 50]; % hyperparameters of the normal prior
    param(9).logpdf = @(x) sum(log(normpdf(x,param(9).hp(1),param(9).hp(2))));  % log density function for prior
    param(9).lb = -90;    % lower bound
    param(9).ub = 180;     % upper bound 
    
    param(10) = param(1);
    param(10).name = 'socialscale';  
    
    
    param(11) = param(1);
    param(11).name = 'gain2self'; 
    
    param(12) = param(1);
    param(12).name = 'gain2other'; 
       
    param(13) = param(1);
    param(13).name = 'loss2self'; 
    
    param(14) = param(1);
    param(14).name = 'loss2other';     
    
    param = param(opts.ix==1);
end