function [vi, vn] = guess_valvars( tbl )
    i = guess_keyvars(tbl);
    vi = setdiff(1:size(tbl, 2), i, 'stable');
    assert(isrow(vi));
    if nargout > 1
        vns = tbl.Properties.VariableNames;
        vn = vns(vi);
        assert(isrow(vn));
    end
end

