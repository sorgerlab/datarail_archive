function tbl = ndarray_to_table(ndarray, labels, varargin)
%NDARRAY_TO_TABLE convert table to nd-array.
%     T = NDARRAY_TO_TABLE(A, L) converts nd-array A to table T,
%     having columns as specified by L.
%
%     T = NDARRAY_TO_TABLE(A, L, OUTER) like the previous form, but if
%     OUTER is true, assume that the dimensions of A are ordered as
%     described in the documentation for the OUTER parameter of the
%     function TABLE_TO_NDARRAY.

    narginchk(2, 3);
    outer = nargin > 2 && varargin{1};

    if outer
        labels = circshift(labels, [0 1]);
    end
    vvs = labels{1};
    labels = labels(2:end);

    if ischar(vvs)
        vvs = {vvs};
    else
        if istable(vvs)
            vvs = cellstr(vvs.(1));
        end
        vvs = reshape(vvs, 1, []);
    end

    kvs = cellmap(@(t) t.Properties.VariableNames{1}, labels);
    levels = cellmap(@(t) t{:, 1}, labels);
    keys = cartesian_product(levels);

    m = numel(ndarray);
    n = ndims(ndarray);
    p = n:-1:1;
    if numel(vvs) > 1
        m = m/numel(vvs);
        if outer
            p = circshift(p, [0 -1]);
        end
    end
    assert(n - (numel(vvs) > 1 || ~outer) == numel(keys));

    values = num2cell(reshape(permute(ndarray, p), m, []), 1);
    data = [keys values];
    tbl = make_table(data, kvs, vvs);
end
