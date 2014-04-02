function varargout = varnames(tbl)
    vns = tbl.Properties.VariableNames;
    if nargout == 0
        varargout = {};
        nr_(vns);
    elseif nargout == 1
        varargout = {vns};
    else
        varargout = vns;
    end
end
