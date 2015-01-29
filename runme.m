% EE732 Probabilistic Graphical Model - Homework #6
% Author: Mahir Ozturk
%
% NOTES:
%   * In this work, Bayes Net Toolbox by Kevin Murphy is used to perform 
%   inference tasks.
%       gcode: https://code.google.com/p/bnt/
%       github: https://github.com/bayesnet/bnt
%
%   * There is no sanity check performed when parsing query string. 
%   get_query function assumes the query string is in the correct form.
%   
%   * Due to BNT's convention, variable can have values starting from 1. So
%   instead of P(G=0), you should write P(G=1).
%
%   * Tested on Matlab 8.1.0.604 (R2013a) @ Ubuntu 14.04.1 LTS
%
%   * Before running this file, navigate to directory where this file is
%   located.
%
%   * ./bnt/BNT/installC_BNT.m file modified as follows: 
%   line  1: -- BNT_HOME = '/home/ai2/murphyk/matlab/FullBNT'; % edit this
%   line  1: ++ BNT_HOME = pwd; % edit this
%   line 31: ++ cd(BNT_HOME);
%

% Install BNT 
cd bnt
addpath(genpathKPM(pwd));
% Compile C libraries (Although in wiki page of bnt, 
%   it says that no need to compile C library anymore, but without 
%   compiling it, gibbs inference is giving error. )
installC_BNT;    % Comment if mex is not configured.           
cd ..
clear all

% load Bayesian network defined in homework
bnet = generate_hw5_bnet();


%% Run through examples (use default values)

% Optional arguments [default in brackets] for LIKELIHOOD_WEIGHTING_INF_ENGINE
% nsamples - [500]
%
%   E.g. p = get_query(bnet, 'P(G=1,S=2,L=2)', 'likelihood', 'nsamples', 500);
%

% Optional parameters [default in brackets] for GIBBS_SAMPLING_INF_ENGINE
%
% 'burnin' - How long before you start using the samples [100].
% 'gap' - how often you use the samples in the estimate [1].
% 'T' - number of samples [1000]
%   i.e, number of node flips (so, for
%   example if there are 10 nodes in the bnet, and T is 1000, each
%   node will get flipped 100 times (assuming a deterministic schedule)) 
%   The total running time is proportional to burnin + T*gap.
%
% 'order' - if the sampling schedule is deterministic, use this
% parameter to specify the order in which nodes are sampled.
% Order is allowed to include multiple copies of nodes, which is
% useful if you want to, say, focus sampling on particular nodes.
% Default is to use a deterministic schedule that goes through the
% nodes in order.
%
% 'sampling_dist' - when using a stochastic sampling method, at
% each step the node to sample is chosen according to this
% distribution (may be unnormalized)
% 
% The sampling_dist and order parameters shouldn't both be used,
% and this will cause an assert.
%
%   E.g. p = get_query(bnet, 'P(G=1,S=2,L=2)', 'gibbs', 'burnin', 100, 'gap', 1);
%


% Example Inference P(G=0,S=1,L=1) by Variable Elimination
p = get_query(bnet, 'P(G=1,S=2,L=2)', 'exact');
fprintf('Example 1 Exact Inference by Variable Elimination: P(G=0,S=1,L=1)=%.4f\n', p);

% Example Inference P(G=0,S=1,L=1) by likelihood weighting
p = get_query(bnet, 'P(G=1,S=2,L=2)', 'likelihood');
fprintf('Example 1 Approximate Inference by Likelihood Weighting: P(G=0,S=1,L=1)=%.4f\n', p);

% Example Inference P(G=0,S=1,L=1) by Gibbs Sampling
p = get_query(bnet, 'P(G=1,S=2,L=2)', 'gibbs');
fprintf('Example 1 Approximate Inference by Gibbs Sampling: P(G=0,S=1,L=1)=%.4f\n', p);

% Example Inference P(G=0|S=1,L=1) with Exact Inference
p = get_query(bnet, 'P(G=1|S=2,L=2)', 'exact');
fprintf('Example 1 Exact Inference by Variable Elimination: P(G=0|S=1,L=1)=%.4f\n', p);

% Example Inference P(G=0|S=1,L=1) with likelihood weighting
p = get_query(bnet, 'P(G=1|S=2,L=2)', 'likelihood');
fprintf('Example 1 Approximate Inference by Likelihood Weighting: P(G=0|S=1,L=1)=%.4f\n', p);

% Example Inference P(G=0|S=1,L=1) with Gibbs Sampling
p = get_query(bnet, 'P(G=1|S=2,L=2)', 'gibbs');
fprintf('Example 1 Approximate Inference by Gibbs Sampling: P(G=0|S=1,L=1)=%.4f\n', p);

%% Statistical Analysis
%
% Collect some data for histogram plots
% 
% p_exact_1 = get_query(bnet, 'P(G=1,S=2,L=2)', 'exact');
% p_exact_2 = get_query(bnet, 'P(G=1|S=2,L=2)', 'exact');
% 
% for i=1:100
%     p_lw_1(i) = get_query(bnet, 'P(G=1,S=2,L=2)', 'likelihood', 'nsamples', 500);
%     p_gibbs_1(i) = get_query(bnet, 'P(G=1,S=2,L=2)', 'gibbs', 'T', 1000);
%     p_lw_2(i) = get_query(bnet, 'P(G=1|S=2,L=2)', 'likelihood', 'nsamples', 500);
%     p_gibbs_2(i) = get_query(bnet, 'P(G=1|S=2,L=2)', 'gibbs', 'T', 1000); 
% end
% 
% for i=1:100
%     p_lw_3(i) = get_query(bnet, 'P(G=1,S=2,L=2)', 'likelihood', 'nsamples', 1000);
%     p_gibbs_3(i) = get_query(bnet, 'P(G=1,S=2,L=2)', 'gibbs', 'T', 2000);
%     p_lw_4(i) = get_query(bnet, 'P(G=1|S=2,L=2)', 'likelihood', 'nsamples', 1000);
%     p_gibbs_4(i) = get_query(bnet, 'P(G=1|S=2,L=2)', 'gibbs', 'T', 2000); 
% end



