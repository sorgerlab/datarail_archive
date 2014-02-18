function [ndarray, labels] = table_to_ndarray(tbl, varargin)

    narginchk(1, 3);

    vns = tbl.Properties.VariableNames;
    if numel(varargin) > 0
        [~, keyvars] = parse_keyvars_arg(tbl, varargin{1});
        varargin = varargin(2:end);
    else
        [~, keyvars] = guess_keyvars(tbl);
        if numel(keyvars) == numel(vns)
            error('Unable to identify key variables');
        end
    end

    ft = table_to_factorial(tbl, keyvars, varargin{:});
    ft = sortrows_(ft, keyvars);

    nkv = numel(keyvars);
    vvs = setdiff(ft.Properties.VariableNames, keyvars, 'stable');
    if nkv < 2
        labels = {tolabels_(vvs)};
        if nkv == 1
            labels = [{ft.(keyvars{1})} labels];
            ft.(keyvars{1}) = [];
        end
        ndarray = cell2mat(table2cell(ft));
        return;
    end    
    [ndarray, labels] = t2nd_(ft, keyvars);
end

function [ndarray, labels] = t2nd_(tbl, keyvars)
    nkv = numel(keyvars);
    if nkv == 2
        cv = keyvars{2};
        vvs = setdiff(tbl.Properties.VariableNames, keyvars, 'stable');
        v1 = vvs{1};
        [nda1, labels] = unstack_(tbl(:, [keyvars {v1}]), v1, cv);
        if length(vvs) > 1
            cb = @(vv) unstack_(tbl(:, [keyvars {vv}]), vv, cv);
            ndas = [{nda1} cellmap(cb, vvs(2:end))];
            ndarray = ndcat(ndas);
        else
            ndarray = nda1;
        end
        if nargout > 1
            labels = [labels {tolabels_(vvs)}];
        end
    else
        assert(nkv > 2);
        kv1 = keyvars{1};
        [sts, label1] = tslice(tbl, kv1);
        st1 = sts{1};
        [nda1, labels] = t2nd_(st1, keyvars(2:end));
        if length(sts) > 1
            cb = @(st) t2nd_(st, keyvars(2:end));
            ndas = [{nda1} cellmap(cb, sts(2:end))];
            ndarray = ndcat(ndas, true);
        else
            ndarray = nda1;
        end
        if nargout > 1
            label1 = tolabels_(label1, kv1);
            labels = [{label1} labels];
        end
    end
end

function [matrix, labels] = unstack_(tbl, valvar, colvar)
    collabels = unique(tbl(:, colvar), 'stable');
    
    warning('off','stats:dataset:genvalidnames:ModifiedVarnames')
    warning('off', 'MATLAB:codetools:ModifiedVarnames');
    t = unstack(tbl, valvar, colvar);
    warning('on', 'MATLAB:codetools:ModifiedVarnames');
    warning('on','stats:dataset:genvalidnames:ModifiedVarnames')

    rowvars = setdiff(tbl.Properties.VariableNames, ...
                      {valvar, colvar});
    assert(numel(rowvars) == 1);
    rowvar = rowvars{1};
    rowlabels = t(:, rowvar);
    t.(rowvar) = [];
    if nargout > 1
        labels = {rowlabels collabels};
    end

    % t.Properties.RowNames = rowlabels;
    % t.Properties.DimensionNames = {rowvar colvar};

    matrix = cell2mat(table2cell(t));
end

function ndarray = arrstack_(subarrs)
    tmp = cellfun(@(c) c(:)', subarrs, 'un', 0);
    ndarray = reshape(cat(1, tmp{:}), [length(subarrs) size(subarrs{1})]);
end

function out = tolabels_(lbls, varargin)
    narginchk(1, 2);
    if nargin > 1
        name = varargin{1};
    else
        name = 'Value';
    end

    out = table(lbls(:), 'VariableNames', {name});
end

function out = sortrows_(tbl, keyvars)
    svs = cellfun(@(v) sortvar_(tbl, v), keyvars, ...
                  'UniformOutput', false);
    [~, i] = sortrows(cell2mat(svs));
    out = tbl(i, :);
end

function out = sortvar_(tbl, varname)
    col = tbl.(varname);
    [~, out] = ismember(col, unique(col, 'stable'));
end

% function ndarray = t2nd_(tbl, keyvars)
%     uo = {'UniformOutput', false};
%     nkv = numel(keyvars);
%     if nkv == 2
%         vvs = setdiff(tbl.Properties.VariableNames, keyvars, 'stable');
%         cv = keyvars{2};
%         cb = @(vv) unstack_(tbl(:, [keyvars {vv}]), vv, cv);
% 
%         %%% NOTE: THE STACKING BELOW IS WRONG
%         %%% ndarray = arrstack_(cellfun(cb, vvs, uo{:}));
% 
%         ndarray = ndcat(cellfun(cb, vvs, uo{:}), true);
%         %length(subtbls)
%         %size(subtbls{1})
%         %tmp = cellfun(@(c) c(:)', subtbls, 'un', 0);
%         %ndarray = reshape(cat(1, tmp{:}), [numel(y) size(subtbls{1})]);
%     else
%         assert(nkv > 2);
%         % kv0 = keyvars{1};
%         % l0 = unique(ft.(kv0), 'stable');
%         % rest = setdiff(ft.Properties.VariableNames, keyvars(1), 'stable');
%     
%         %cb = @(v) table_to_ndarray(ft(strcmp(ft.(kv0), v), rest), kvs1, varargin{2:end});
%         %foo = cellfun(cb, l0, uo{:});
%         %[length(l0) length(foo)];
%         %ndarray = arrstack_(foo);
%         %tmp = cellfun(@(c) c(:)', foo, 'un', 0);
%         %ndarray = reshape(cat(1, tmp{:}), [numel(l0) size(foo{1, 1})]);
%         
%         sts = tslice(tbl, keyvars{1});
%         cb = @(st) t2nd_(st, keyvars(2:end));
%         % ndarray = arrstack_(cellfun(cb, sts, uo{:}));
%         ndarray = ndcat(cellfun(cb, sts, uo{:}));
%     end
% end
