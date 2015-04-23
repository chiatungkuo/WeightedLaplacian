% load Laplacians
load('NDlaps.mat');
Nn = 19; 
Nd = 21; 
n = Nn + Nd;
index = logical(result.x);

wcuts = zeros(N, n);
wcosts = zeros(1, n);

% set weights
weights = ones(N, 1);
weights(index) = 5;     % scale selected nodes by 5 times
W = diag(weights);

% compute Fiedler vectors for each reweighted Laplacian
for i = 1:n
    L = NDlap{i};
    Lw = W^(0.5)*L*W^(0.5);
    
    [V ~] = eigs(Lw, 3, 'SM');
    cut = V(:, 2);
    wcuts(:, i) = cut;
    wcosts(i) = (weights.*cut)'*Lw*(weights.*cut);
end

% plot grouped box plot and print t-test results
groups = [repmat({'h'}, Nn, 1); repmat({'d'}, Nd, 1)];
figure;
boxplot(wcosts, groups, 'labels', {'Elderly', 'Demented'});

elderlyCosts = wcosts(1:Nn);
dementedCosts = wcosts(Nn+1:end);
[h p ci stat] = ttest2(elderlyCosts, dementedCosts);


