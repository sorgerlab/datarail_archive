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
%   - P = cartproduct(C1, C2, ...) computes the cartesian product of 
%     C1, C2, ..., which are expressed as cell arrays.
%
%     Suppose C1, C2, ... respectively has n1, n2, ... elements. Then
%     P is an n1 x n2 x ... cell array of tuples, such that
%        $ P{i1, i2, ...} = {C1{i1}, C2{i2}, ...} $
%
% [ Examples ]
%   - Compute Cartesian product of cell arrays
%     \{
%        cartproduct({1, 2}, {'a', 'b', 'c'})
%        => { {[1], 'a'}, {[1], 'b'}, {[1], 'c'}; 
%             {[2], 'a'}, {[2], 'b'}, {[2], 'c'} }
%     \}
%
%   - Compute Cartesian product of multiple sets
%     \{
%         cartproduct({100, 200}, {10, 20, 30}, {1, 2})            
%     \}
%
% [ History ]
%   - Created by Dahua Lin, on Jun 27, 2007
%

%% parse and verify input arguments

narginchk(2, 2);

%% cellfun(@(c) typecheck(c, 'the set must be a cell array', 'cell'), factors);

%% main

if ~iscell(factornames)
    factornames = {factornames};
end

if numel(factors) ~= numel(factornames)
    error('number of factors and number of factornames must match');
end

u = {'UniformOutput', false};  % pardon my french...
n = length(factors);

if n == 1
    content = factors;
else
    tmp = fliplr(cellfun(@(c) 1:numel(c), factors, u{:}));
    [idx{1:n}] = ndgrid(tmp{:}); clear('tmp');
    idx = fliplr(idx);
    content = arrayfun(@(i) factors{i}(idx{i}(:)), 1:n, u{:})
end
P = dataset([{cat(1, content{:}).'}, factornames]);
