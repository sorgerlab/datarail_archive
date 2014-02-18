function P = cartesian_product_table(factors, factornames)
%CARTESIAN_PRODUCT_TABLE Computes the Cartesian products between cell arrays and
%makes a table to express the results

    narginchk(2, 2);

    if ~(iscell(factors) && iscell(factornames))
        error('first and/or second argument is not a cell array');
    end

    nd = numel(factors);
    if numel(factornames) ~= nd
        error('numbers of factors and of factornames do not match');
    end

    if nd == 0
        P = table(0);
        P(:, 1) = []; % "empty 1-by-0 table"
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
        P = table(content{:, :}, 'VariableNames', factornames);
    end

end