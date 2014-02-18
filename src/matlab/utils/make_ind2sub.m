function fn = make_ind2sub( sz )
    n = numel(sz);
    function out = i2s(i)
        [idx{1:n}] = ind2sub(sz, i);
        out = cell2mat(idx);
    end
    fn = @i2s;
end

