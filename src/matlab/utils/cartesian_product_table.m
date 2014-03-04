function P = cartesian_product_table(factors, factornames)
%CARTESIAN_PRODUCT_TABLE(FACTORS, FACTORNAMES) computes the cartesian
%product of the elements in the cell array FACTORS and expresses the result
%as a table with variable names as specified by FACTORNAMES.

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
        content = cartesian_product(factors);
        P = table(content{:, :}, 'VariableNames', factornames);
    end

end
