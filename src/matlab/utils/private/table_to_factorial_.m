function out = table_to_factorial_(tbl, kns, vns, aggrs)
    out = fill_missing_keys_(collapse_(tbl, kns, vns, aggrs), kns);
end
