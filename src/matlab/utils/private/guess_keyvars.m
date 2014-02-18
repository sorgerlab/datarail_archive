function [vi vn] = guess_keyvars( tbl )
    vns = tbl.Properties.VariableNames;
    i = varfun(@iscategorical, tbl, 'OutputFormat', 'uniform');
    vi = find(i);
    if nargout > 1
        vn = vns(i);
    end
end

