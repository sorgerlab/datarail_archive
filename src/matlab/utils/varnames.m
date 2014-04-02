function varargout = varnames(tbl)
    vns = tbl.Properties.VariableNames;
    if nargout == 0
        varargout = {};
        dispvns_(vns);
    elseif nargout == 1
        varargout = {vns};
    else
        varargout = vns;
    end
end

function dispvns_(vns)
    n = numel(vns);
    fmt = sprintf('%%%dd\t%%s', floor(log10(n)) + 1);
    lines = arraymap(@(i) sprintf(fmt, i, vns{i}), 1:n);
    disp(strjoin(lines, '\n'));
end