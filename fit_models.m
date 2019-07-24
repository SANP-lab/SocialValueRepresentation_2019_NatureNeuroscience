function [results, bms_results] = fit_models(data,opts)

    for s = 1:length(data)
        if ~isfield(data(s),'block') || isempty(data(s).block); data(s).block = ones(data(s).N,1); end
        if ~isfield(data(s),'go') || isempty(data(s).go); data(s).go = zeros(data(s).N,1); end
    end
    
    parfor m = 1:length(opts)
        
        disp(['... fitting model ',num2str(m),' out of ',num2str(length(opts))])
        
        % get parameter structure
        [opts1, param] = set_opts(opts(m));
        
        % fit model
        tic
        fun = @(x,data) RatioDM(x,data,opts1);
        R = mfit_optimize(fun,param,data);% mfit_optimize_hierarchical(fun,param,data); 
        %R = mfit_optimize_hierarchical(fun,param,data);% ; 
        toc
        R.opts = opts1;
        
        % collect latent variables
        if opts1.latents
            for s = 1:length(data)
                [~,R.latents(s)] = fun(R.x(s,:),data(s));
            end
        end
        
        % fit empirical prior
        R.param_empirical = mfit_priorfit(R.x,param);
        
        results(m) = R;
        
    end
    
    % Bayesian model selection
    if nargout > 1
        bms_results = mfit_bms(results);
    end
end