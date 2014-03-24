function out = hslice(ndarray, dim, ix)
%HSLICE(A, DIM, IX) extract A(:, ..., :, IX, :, ..., :), where the IX
%    subscript occurs at the DIM-th position.

    nd = ndims(ndarray);
    if dim > nd && numel(ix) == 1 && ix == 1
        warning('hslice:alreadySlice', ...
                ['first argument is already a slice ' ...
                 'along dimension %d'], dim);
        out = ndarray;
    else
        ixs = repmat({':'}, [1 max(nd, dim)]);
        ixs{dim} = ix;
        out = ndarray(ixs{:});
    end
end
