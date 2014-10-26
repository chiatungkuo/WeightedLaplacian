% load Laplacians
load('NDlaps.mat');
Nn = 19; 
Nd = 21; 
n = Nn + Nd;

cuts = zeros(N, n);
costs = zeros(1, n);

% compute Fiedler vectors for Laplacian
for i = 1:n
    L = NDlap{i};        
    [V ~] = eigs(Lw, 3, 'SM');
    cut = V(:, 2);
    cuts(:, i) = cut;
    costs(i) = cut'*L*cut;
end

% plot grouped box plot and print t-test results
groups = [repmat({'h'}, Nn, 1); repmat({'d'}, Nd, 1)];
figure;
boxplot(costs, groups, 'labels', {'Elderly', 'Demented'});

elderlyCosts = costs(1:Nn);
dementedCosts = costs(Nn+1:end);
[h p ci stat] = ttest2(elderlyCosts, dementedCosts);


