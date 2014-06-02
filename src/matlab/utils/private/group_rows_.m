function [grouped_tbl, starts, ends, sort_perm, sort_iperm] = group_rows_(tbl, gv)

    % The preprocessing of key columns performed by the hashable_ helper
    % function produces a table (KTBL) whose column types are among the few
    % that MATLAB's UNIQUE function can handle; KTBL is used only for
    % indexing and grouping; its contents are not included in the returned
    % value.

    ktbl = hashable_(tbl(:, dr.vidxs(tbl, gv)));
    [~, ~, group_id_col] = unique(ktbl, 'stable');
%     if
%     [C, IA, group_id_col] = unique(ktbl, 'stable');
%     C(group_id_col, :) should be equal to ktbl
%     A(IA, :) should be equal to C

    [sorted_group_id_col, sort_perm] = sort(group_id_col);
    % sorted_group_id_col is equal to group_id_col(sort_perm)

    grouped_tbl = tbl(sort_perm, :);
    [~, sort_iperm] = sort(sort_perm);

    n = numel(sort_perm);
    assert(n == height(tbl));
    assert(isequal(sort_perm(sort_iperm).', 1:n));
    assert(isequal(sort_iperm(sort_perm).', 1:n));

    grouped_tbl.group_id = sorted_group_id_col;

    [~, starts, ~] = unique(sorted_group_id_col, 'stable');
%     if
%     [D, starts, ID] = unique(sorted_group_id_col, 'stable');
%     D(ID) should be equal to sorted_group_id_col
%     sorted_grouped_id_col(starts) should be equal to D

%     want: vectors IE, IF such that
%     tbl(IE, :) be equal to grouped_tbl, and
%     grouped_tbl(IF, :) be equal to tbl

    assert(issorted(starts));
    ends = [starts(2:end); height(tbl) + 1] - 1;
end


function [grouped_tbl, starts, ends] = group_rows_DISABLE(tbl, gv)

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
