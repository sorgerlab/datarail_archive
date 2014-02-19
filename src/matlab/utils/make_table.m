function tbl = make_table(data, keyvars, valvars)
    varnames = [keyvars valvars];
    tbl = table(data{:}, 'VariableNames', varnames);
    userdata = make_hash({{'keyvars', keyvars}, ...
                          {'valvars', valvars}});
    tbl.Properties.UserData = userdata;
end

