function P = cartesian_product(factors)
%CARTESIAN_PRODUCT(FACTORS) computes the cartesian product of the elements
%in the cell array FACTORS.

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
            tmp = fliplr(cellmap(@(c) 1:numel(c), factors));
            [idx{1:nd}] = ndgrid(tmp{:}); clear('tmp');
            idx = fliplr(idx);
            content = arraymap(@(i) factors{i}(idx{i}(:)), 1:nd);
        end
        P = content;
    end

end