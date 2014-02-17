function P = fill_missing_keys(tbl, varargin)
    uo = {'UniformOutput', false};

    narginchk(1, 2);

    if nargin > 1
        groupingvars = varargin{1};
    else
        groupingvars = tbl.Properties.VariableNames;
    end

    if ~iscell(groupingvars)
        groupingvars = {groupingvars};
    end

    groupingvars = groupingvars(:);

    levels = cellfun(@(n) unique(tbl.(n), 'stable'), ...
                     groupingvars, uo{:});
                 
    max_unique = prod(cellfun(@numel, levels));
    if height(unique(tbl(:, groupingvars))) == max_unique
        P = tbl;
        return;
    end
    
    for c = setdiff(tbl.Properties.VariableNames, groupingvars)
        v = c{:};
        if islogical(tbl.(v))
            tbl.(v) = tbl.(v) + 0;
        end
    end
    %%% unstable ordering
    % s = cartesian_product_table(levels, groupingvars);
    % P = outerjoin(s, tbl, 'MergeKeys', true);

    % stable ordering
    s = cartesian_product_table(levels, groupingvars);

    [P, itbl, ~] = outerjoin(tbl, s, 'MergeKeys', true);
    h = height(P);
    imssng = itbl == 0;
    mssng = sum(imssng);
    if mssng > 0
        itbl(imssng) = ((h - mssng + 1):h)';
    end
    idx(itbl, 1) = (1:h)';
    P = P(idx, :);

end
  
% function P = fill_missing_keys(tbl, varargin)
%
% narginchk(1, 3);
%
% if length(varargin) == 1
% %{
% it would be nice to support the option of passing supplemental ...
%     elements, so that the level sets did not have to be limited to ...
%     those represented in TBL, but this introduces argument ...
%     consistency issues that are particularly thorny to deal when ...
%     there's the possibility of categorical (rather than string) ...
%     factors, so I'm punting on this feature for now.
% %}
%     extra = varargin{1};
%     if numel(extra) ~= m
%         error('inconsistent arguments');
%     end
%     extra = reshape(extra, [m 1]);
% else
%     extra = repmat({{}}, [m 1]);
% end
