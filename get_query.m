function [p] = get_query(bnet, query_string, inf_type, varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    
    % # of nodes
    N = size(bnet.dag,1);

    if (strcmp(inf_type, 'exact'))
        % create variable elimimination inference engine 
        engine = var_elim_inf_engine(bnet);
    elseif (strcmp(inf_type, 'likelihood'))
        % create variable elimimination inference engine 
        engine = likelihood_weighting_inf_engine(bnet, varargin{:});
    elseif (strcmp(inf_type, 'gibbs'))
        % create variable elimimination inference engine 
        engine = gibbs_sampling_inf_engine(bnet, varargin{:});
    else
        error('Invalid inference type');
    end
    
    query = parseline(query_string);
        
    % Create evidence matrix
    evidence = cell(1,N);
    if(~isempty(query.cond_variables))
        for i=1:size(query.cond_variables,2)
            evidence{bnet.names(query.cond_variables{i}.label)} = query.cond_variables{i}.value;
        end
    end

    % enter evidence to the engine
    [engine, loglik] = enter_evidence(engine, evidence);

    % Compute probability
    joint_variables = [];
    joint_values = [];
    for i=1:size(query.variables,2)
        joint_variables = [joint_variables bnet.names(query.variables{i}.label)];
        joint_values = [joint_values query.variables{i}.value];
    end
    marg = marginal_nodes(engine, joint_variables);
    subcell = num2cell(joint_values);
    p = marg.T(subcell{:});

end

