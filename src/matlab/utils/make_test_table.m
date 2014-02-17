function tbl = make_test_table( sz, varargin )
    narginchk(1, 2);
    [sz, expanded, nd] = argchk_(sz, varargin{:});
    if nd == 0
        if expanded
            tbl = mktbl_(true, {{}, {}});
        else
            tbl = mktbl_(false, {{}}, []);
        end
        return;
    end

    n = prod(sz);
    function lvls = levels(expanded, perm)
        lvls = make_test_ndarray(sz, expanded);
        lvls = reshape(permute(lvls, perm), n, []);
        lvls = cellmap(@(i) lvls(:, i), num2cell(1:size(lvls, 2)));
    end

    keyvars = varnames_(nd, 'Key_');
    keylevels = levels(true, circshift(nd+1:-1:1, [0 -1]));

    if expanded
        vals = keylevels;
        vns = {keyvars, varnames_(nd, 'value_')};
    else
        vals = levels(false, nd:-1:1);
        vns = {keyvars};
    end

    keylevels = cellmap(@(l) categorical(l), keylevels);
    data = [keylevels vals];
    tbl = mktbl_(expanded, vns, data{:});
end

function tbl = mktbl_(expanded, vns, varargin)
    data = varargin;
    kvs = vns{1};
    if expanded
        vvs = vns{2};
    else
        vvs = {'Value'};
    end
    varnames = [kvs vvs];
    userdata = make_hash({{'keyvars', kvs}, ...
                          {'valvars', vvs}});
    tbl = table(data{:}, 'VariableNames', varnames);
    tbl.Properties.UserData = userdata;
end

function [sz, expanded, nd] = argchk_(sz, varargin)
    if iscell(sz)
        sz = cell2mat(sz);
    end
    sz = reshape(sz, 1, []);
    if ~all(sz > 0)
        error('first argument contains zero dim(s)');
    end
    nd = numel(sz);
    if nd > 26
        error('number of key variables exceeds 26');
    end
    expanded = nargin == 2 && varargin{1};
end

function vnames = varnames_(n, prefix)
   vnames = cellmap(@(i) [prefix char(i+64)], num2cell(1:n));
end
