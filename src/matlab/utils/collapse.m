function P = collapse(tbl, varargin)

    narginchk(1, 3);

    if nargin > 1
        groupingvars = varargin{1};
        if ~iscell(groupingvars)
            groupingvars = {groupingvars};
        % else
            % assert(numel(groupingvars) > 0);
        end
    else
        groupingvars = tbl.Properties.VariableNames;
    end

    inputvars = setdiff(tbl.Properties.VariableNames, groupingvars, 'stable');
    inputvars = inputvars(:).';
    groupingvars = groupingvars(:).';

    m = numel(inputvars);
    if nargin > 2
        aggns = varargin{2};
        if iscell(aggns)
            aggns = aggns(:).';
            if (numel(aggns) ~= m)
                % mismatch between number of aggregation functions specified
                % and available input variables
                error('inconsistent arguments');
            end
        end
    else
        aggns = @sum;
    end

    % --------------------------------------------------------------------------

    if m == 0
        P = unique(tbl);
    else
        if iscell(aggns)
            P = collapse_(tbl, groupingvars, inputvars, aggns);
        else
            P = varfun_(aggns, tbl, groupingvars, inputvars);
        end
    end

    P.Properties.RowNames = {};
end


function out = varfun_(fn, tbl, gv, iv)
    out = varfun(fn, tbl, 'GroupingVariables', gv, 'InputVariables', iv);
    out.GroupCount = [];
    out.Properties.VariableNames = [gv iv];
end

  
function out = collapse_(tbl, gv, iv, aggns)
    t0 = varfun_(aggns{1}, tbl, gv, iv(1, 1));
    if numel(iv) > 1
        t1 = collapse_(tbl, gv, iv(1, 2:end), aggns(1, 2:end));
        out = join(t0, t1, 'Keys', gv);
    else
        out = t0;
    end
end
