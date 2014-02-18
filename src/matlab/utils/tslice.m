function [slices, labels] = tslice(tbl, var)
    col = unique(tbl.(var), 'stable');
    col = col(:).';
    rest = setdiff(tbl.Properties.VariableNames, {var}, 'stable');
    
    labels = col;
    if iscell(col)
        cb = @(s) tbl(strcmp(tbl.(var), s), rest);
    else
        cb = @(v) tbl(tbl.(var) == v, rest);
        if iscategorical(col)
            col = cellstr(col);
        elseif isnumeric(col)
            col = num2cell(col);
        end
    end
    slices = cellmap(cb, col);
end