function out = group_pairs_fun(fn, tbl, key, varargin)
    narginchk(3, 4);
    if nargin < 4
        skipij = @(i, j) false;
    else
        skipij = varargin{1};
    end

    [grouped_tbl, starts, ends] = group_rows(tbl, key);
    ngroups = numel(starts);
    for i = 1:ngroups
        for j = 1:ngroups
            if skipij(i, j); continue; end
            
        end
    end
end


    pairs = selfjoin(grpd, 2);
    [jspairs, jfrom, jto, jfp, jrp] = group_rows(pairs, 'FacilityID_RIGHT');
    jspairs.group_id = [];
    [ispairs, ifrom, ito, ifp, irp] = group_rows(jspairs, 'FacilityID_LEFT');
    ispairs.group_id = [];
    for j = 1:numel(from)
        idx0 = jfrom(j):jto(j);
        idx1 = irp(idx0);
        r0 = jspairs(idx0, :);
        r1 = ispairs(idx1, :);

        r0 = jspairs(jfrom(j):jto(j), :);
        r1 = ispairs(irp(jfrom(j):jto(j)), :);
        assert(isequal(r0, r1));
    end

    [ispairs, ifrom, ito, ifp, irp] = group_rows(pairs, 'FacilityID_LEFT');
    ispairs.group_id = [];
    [jspairs, jfrom, jto, jfp, jrp] = group_rows(ispairs, 'FacilityID_RIGHT');
    jspairs.group_id = [];
    for j = 1:numel(from)
        idx0 = jfrom(j):jto(j);
        %idx1 = irp(idx0);
        idx1 = jfp(idx0);
        r0 = jspairs(idx0, :);
        r1 = ispairs(idx1, :);

        r0 = jspairs(jfrom(j):jto(j), :);
        r1 = ispairs(jfp(jfrom(j):jto(j)), :);
        assert(isequal(r0, r1));
    end
