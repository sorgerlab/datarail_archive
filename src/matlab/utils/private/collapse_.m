function out = collapse_(tbl, ag, gv, iv)
    nargoutchk(0, 3);
    m = numel(iv);
    if m == 0
        out = unique(tbl(:, gv));
    else
        if iscell(ag)
            out = collapse__(tbl, ag, gv, iv);
        else
            out = varfun_(ag, tbl, gv, iv);
        end
    end
    out.Properties.RowNames = {};
end

function out = varfun_(fn, tbl, gv, iv)
    fn = @(x) reshape(fn(x), 1, []);
    args = {tbl 'GroupingVariables' gv 'InputVariables' iv};
    try
        out = varfun(fn, args{:});
    catch e
        if ~isequal(e.identifier, 'MATLAB:table:varfun:VertcatFailed')
            rethrow(e); end
        out = varfun(@(~) 0, args{:});
        out.(width(out)) = varfun(fn, args{:}, 'OutputFormat', 'cell');
    end
    out.GroupCount = [];
    out.Properties.VariableNames = [gv iv];
end

function out = collapse__(tbl, aggns, gv, iv)
    t0 = varfun_(aggns{1}, tbl, gv, iv(1, 1));
    if numel(iv) > 1
        t1 = collapse__(tbl, aggns(1, 2:end), gv, iv(1, 2:end));
        out = join(t0, t1, 'Keys', gv);
    else
        out = t0;
    end
end
