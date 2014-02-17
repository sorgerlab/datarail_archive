function P = cartesian_product_table(factors, factornames)
%CARTESIAN_PRODUCT_TABLE Computes the Cartesian products between cell arrays and
%makes a table to express the results

    narginchk(2, 2);

    if ~iscell(factornames)
        factornames = {factornames};
    end

    n = numel(factors);
    if numel(factornames) ~= n
        error('number of factors and number of factornames do not match');
    end

    if n == 0
        P = table({}, {});
    else
        u = {'UniformOutput', false};
        factors = cellfun(@(c) reshape(c, [numel(c) 1]), ...
                          reshape(factors, [1 n]), u{:});
        if n == 1
            content = factors;
        else
            tmp = fliplr(cellfun(@(c) 1:numel(c), factors, u{:}));
            [idx{1:n}] = ndgrid(tmp{:}); clear('tmp');
            idx = fliplr(idx);
            content = arrayfun(@(i) factors{i}(idx{i}(:)), 1:n, u{:});
        end
        P = table(content{:, :}, 'VariableNames', factornames);
    end

end