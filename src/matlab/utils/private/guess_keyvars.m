function [vi, vn] = guess_keyvars( tbl )
    i = varfun(@iscategorical, tbl, 'OutputFormat', 'uniform');
    vi = find(i);
    assert(isrow(vi));
    if nargout > 1
        vns = tbl.Properties.VariableNames;
        vn = vns(vi);
        assert(isrow(vn));
    end
end

