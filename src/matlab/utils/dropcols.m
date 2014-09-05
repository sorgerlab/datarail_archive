function tbl = dropcols(tbl, dropset)
    w = size(tbl, 2);
    tbl = tbl(:, setdiff(1:w, dr.vidxs(tbl, dropset)));
end
