function P = cartproduct_ds(factors, factornames)
%CARTPRODUCT_DS Computes the Cartesian products between cell arrays and
%makes a dataset to express the results
%
% [ Description ]
%   - P = cartproduct_DS(FACTORS, FACTORNAMES)
%
% [ Arguments ]
%   - Ci:       the i-th set of elements
%   - P:        the cartesian product in form of cell array of tuples
%
% [ Description ]
%   - P = cartproduct_ds({C1, C2, ... }, FACTORNAMES) computes the dataset
%     corresponding to th cartesian product of C1, C2, ... .  If C1,
%     C2, ... are cell arrays (for example) having n1, n2, ...
%     elements, respectively, then P will be a dataset with
%     n1 x n2 x ... rows, such that
%
%        $ P{i1, i2, ...} = {C1{i1}, C2{i2}, ...} $
%
%     ...and having variables named by FACTORNAMES.
% [ Examples ]
%   - Cartesian product dataset from sequence of numeric arrays
%
%     >> cartproduct_ds({[1 2] [3 4] [5 6]}, {'A' 'B' 'C'})
%     ans = 
%         A    B    C
%         1    3    5
%         1    3    6
%         1    4    5
%         1    4    6
%         2    3    5
%         2    3    6
%         2    4    5
%         2    4    6
%
%   - Cartesian product dataset from type-heterogeneous sequence
%
%     >> cartproduct_ds({[1 2] {3 4} {'5' '6'}}, {'A' 'B' 'C'})
%     ans = 
%         A    B          C      
%         1    [3]        '5'    
%         1    [3]        '6'    
%         1    [4]        '5'    
%         1    [4]        '6'    
%         2    [3]        '5'    
%         2    [3]        '6'    
%         2    [4]        '5'    
%         2    [4]        '6'    
%

%%
narginchk(2, 2);

if ~iscell(factors) || ~iscell(factornames)
    error('first and/or second argument is not a cell array');
end

nd = numel(factors);

if numel(factornames) ~= nd
    error('numbers of factors and of factornames do not match');
end

if nd == 1
    args = {[{reshape(factors{1}, [], 1)} factornames]};
else
    tmp = fliplr(cellmap(@(c) 1:numel(c), factors));
    [idx{1:nd}] = ndgrid(tmp{:}); clear('tmp');
    idx = fliplr(idx);
    args = arraymap(@(i) {(factors{i}(idx{i}(:)).') ...
                          factornames{i}}, 1:nd);
end
P = dataset(args{:});

