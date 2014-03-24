function tbl = make_table(data, keyvars, valvars)
    varnames = [keyvars valvars];
    tbl = table(data{:}, 'VariableNames', varnames);
    for i = 1:numel(keyvars)
        c = tbl.(keyvars{i});
        if ~iscategorical(c)
            tbl.(keyvars{i}) = categorical(c);
        end
    end
    userdata = make_hash({{'keyvars', keyvars}, ...
                          {'valvars', valvars}});
    tbl.Properties.UserData = userdata;
end

% function TBL = make_table( vars, data, vspec, varargin )
% %MAKE_TABLE make a new table object.
% %   ...
%     narginchk(3, 4);
% end


