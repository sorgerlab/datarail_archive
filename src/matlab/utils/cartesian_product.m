function P = cartesian_product(factors, varargin)
%CARTESIAN_PRODUCT compute the cartesian product of factor groups.
%    CARTESIAN_PRODUCT(FACTORS) computes the cartesian product of the
%    elements in the cell array FACTORS, in lexicographic order.
%
%    CARTESIAN_PRODUCT(FACTORS, COLEX) computes a cartesian product as
%    before, but orders it colexicographically if COLEX is true.

    narginchk(1, 2);
    colex = nargin > 1 && varargin{1};

    if ~iscell(factors)
        error('argument is not a cell array');
    end

    nd = numel(factors);
    if nd == 0
        P = cell(1, 0);
    else
        factors = cellmap(@(c) reshape(c, [numel(c) 1]), ...
                          reshape(factors, [1 nd]));
        if nd == 1
            content = factors;
        else
            tmp = cellmap(@(c) 1:numel(c), factors);
            if ~colex
                tmp = fliplr(tmp);
            end
            %tmp = fliplr(cellmap(@(c) 1:numel(c), factors));
            [idx{1:nd}] = ndgrid(tmp{:}); clear('tmp');
            if ~colex
                idx = fliplr(idx);
            end
            content = arraymap(@(i) factors{i}(idx{i}(:)), 1:nd);
        end
        P = content;
    end

end
