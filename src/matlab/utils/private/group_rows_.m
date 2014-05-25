function [grouped_tbl, starts, ends] = group_rows_(tbl, gv)

    % The preprocessing of key columns performed by the hashable_ helper
    % function produces a table (KTBL) whose column types are among the few
    % that MATLAB's UNIQUE function can handle; KTBL is used only for
    % indexing and grouping; its contents are not included in the returned
    % value.

    ktbl = hashable_(tbl(:, dr.vidxs(tbl, gv)));
    [~, ~, group_id_col] = unique(ktbl, 'stable');
    [sorted_group_id_col, sort_perm] = sort(group_id_col);
    grouped_tbl = tbl(sort_perm, :);

    grouped_tbl.group_id = sorted_group_id_col;

    [~, starts, ~] = unique(sorted_group_id_col, 'stable');
    assert(issorted(starts));
    ends = [starts(2:end); height(tbl) + 1] - 1;
end
