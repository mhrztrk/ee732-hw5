function [bnet] = generate_hw5_bnet()
    % o specify this directed acyclic graph (dag), we create an adjacency matrix:
    
    N = 5; 
    dag = zeros(N,N);
    D = 1; I = 2; G = 3; S = 4; L = 5;

    % edge map
    dag(D,G) = 1;
    dag(I,G) = 1;
    dag(I,S) = 1;
    dag(G,L) = 1;

    % # of possible values each node can have
    node_sizes = [2 2 3 2 2];

    onodes = []; % no observed variable yet 

    % Create bayes network
    bnet = mk_bnet(dag, node_sizes, 'names', {'D','I','G','S','L'}, 'observed', onodes);   

    bnet.CPD{D} = tabular_CPD(bnet, D, 'CPT', [0.6 0.4]);
    bnet.CPD{I} = tabular_CPD(bnet, I, 'CPT', [0.7 0.3]);
    bnet.CPD{G} = tabular_CPD(bnet, G, 'CPT', [0.3 0.05 0.9 0.5 0.4 0.25 0.08 0.3 0.3 0.7 0.02 0.2]);
    bnet.CPD{S} = tabular_CPD(bnet, S, 'CPT', [0.95 0.2 0.05 0.8]);
    bnet.CPD{L} = tabular_CPD(bnet, L, 'CPT', [0.1 0.4 0.99 0.9 0.6 0.01]);

    draw_graph(bnet.dag, {'D','I','G','S','L'});
    
    fprintf('Nodes:\n');
    fprintf('D (Possible values: {1,2})\n');
    fprintf('I (Possible values: {1,2})\n');
    fprintf('G (Possible values: {1,2,3})\n');
    fprintf('S (Possible values: {1,2})\n');
    fprintf('L (Possible values: {1,2})\n');
    
end

