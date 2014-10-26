%% apply constrained spectral clsutering 

% construct constraints based on indices to be kept
index = logical(result.x); % use 'result' from 'learn_weights'
q = ones(N, 1);
q(~index) = -1;
Q = q*q';
Q(Q == -1) = 0;

% load correlation graphs and their Laplacians
load('NDcorrs.mat');
load('NDlaps.mat');
Nn = 19;
Nd = 21;
n = Nn + Nd;

costs = zeros(1, n);
cspCuts = zeros(N, n);
% K = 20
for i = 1:n
    L = NDlap{i};
    A = abs(NDcorr{i});
    D = diag(sum(A));

    % there's another version of csp with additional parameter K to only
    % look for the optimal in the top K feasible candidates
    u = csp(L, Q, D^(-1/2), sum(diag(D)), N);
    cspCuts(:, i) = u;
    costs(i) = u'*L*u;
end

% plot grouped box plot and print t-test results
groups = [repmat({'h'}, Nn, 1); repmat({'d'}, Nd, 1)];
figure;
boxplot(costs, groups, 'labels', {'Elderly', 'Demented'});

elderlyCosts = costs(1:Nn);
dementedCosts = costs(Nn+1:end);
[h p ci stat] = ttest2(elderlyCosts, dementedCosts);
