function varargout = varnames(tbl, varargin)
    narginchk(1, 2);
    if nargin > 1
        tbl.Properties.VariableNames = varargin{1};
        varargout = {tbl};
    else
        vns = tbl.Properties.VariableNames;
        if nargout == 0
            varargout = {};
            nr(vns);
        elseif nargout == 1
            varargout = {vns};
        else
            varargout = vns;
        end
    end
end
