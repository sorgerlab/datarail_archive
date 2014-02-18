function P = collapse_(tbl, gv, iv, ag, m)
    if m == 0
        P = unique(tbl);
    else
        if iscell(ag)
            P = collapse__(tbl, gv, iv, ag);
        else
            P = varfun_(ag, tbl, gv, iv);
        end
    end

    P.Properties.RowNames = {};
end

function out = varfun_(fn, tbl, gv, iv)
    out = varfun(fn, tbl, 'GroupingVariables', gv, 'InputVariables', iv);
    out.GroupCount = [];
    out.Properties.VariableNames = [gv iv];
end

function out = collapse__(tbl, gv, iv, aggns)
    t0 = varfun_(aggns{1}, tbl, gv, iv(1, 1));
    if numel(iv) > 1
        t1 = collapse__(tbl, gv, iv(1, 2:end), aggns(1, 2:end));
        out = join(t0, t1, 'Keys', gv);
    else
        out = t0;
    end
end