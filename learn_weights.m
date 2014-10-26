%% load correlation graph Laplacian for the scans
Nn = 19;    % number of healthy elderly
Nd = 21;    % number of demented
n = Nn + Nd;
load('NDlaps.mat');

%% compute 2nd principal eigenvector for each Laplacian
evec = zeros(N, n);
for i = 1:n
    [eigvec, ~] = eigs(NDlap{i}, 3, 'SM');
    vi = eigvec(:, 2);
    vi = sign(vi(1))*vi;    % fix sign of eigenvector by setting first entry to positive
    evec(:, i) = vi;
end

%% solve mixed integer program to select nodes with different tolerances
EPS = [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50];

for r = 1:length(EPS)
    epsilon = EPS(r);   
    e = ones(N, 1);

    clear model;

    model.obj = e;
    model.modelsense = 'max';

    model.vtype = 'B';  % all variables are binary 0/1
    
    % no linear constraint
    model.A = sparse(zeros(1, N));
    model.sense = '=';
    model.rhs = 0;

    % add quadratic constraints
    constrCount = 0;
    for i = 1:Nn
        for j = i+1:Nn
            constrCount = constrCount + 1;  % increment counter of constraints
            
            % define difference based on absolute diff in eigenvectors
            vi = evec(:, i);
            vj = evec(:, j);
            dGnn = abs(vi - vj);
            Gdiff = dGnn;
            
            % add constraints to enforce similarity within a group
            model.quadcon(constrCount).Qc = sparse(zeros(N, N));
            model.quadcon(constrCount).q = Gdiff;
            model.quadcon(constrCount).rhs = epsilon;
        end
    end

    % set optimization parameters
    params.mipfocus = 1;        % focus more on finding feasible solution
    params.heuristics = 0.1;    % slightly higher proportion in using heuristics
    params.timelimit = 7200;    % set max time to 2 hour(s)

	% solve the model and store result
    result = gurobi(model);
    % can optionally store result to file with 'gurobi_write'
end
