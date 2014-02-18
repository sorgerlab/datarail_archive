function arr = make_test_ndarray( sz, varargin )
    narginchk(1, 2);
    sz = reshape(sz, 1, []);
    if ~all(sz > 0)
        error('first argument contains zero dim(s)');
    end
    n = numel(sz);
    if nargin == 2 && varargin{1}
        arr = expanded_(sz, n);
    else
        arr = collapsed_(sz, n);
    end
end

function arr = collapsed_( sz, n )
    sz1 = [sz ones(1, 2 - n)];
    arr = reshape(mtnda_(sz, n), sz1);
end

function out = mtnda_( sz, n )
    if n == 0
        out = 0;
        return;
    end
    
    assert(n > 0);
    nd0 = mtnda_(sz(1:end-1), n - 1) * 10;
    out = ndcat(arraymap(@(i) nd0 + i, 1:sz(end)));
end

function out = expanded_( sz, n )
    if n == 0
        out = [];
        return;
    end
    
    assert(n > 0);

    this = sz(1);
    rest = sz(2:end);

    nd0 = expanded_(rest, n - 1);

    slab = ones([rest 1]);
    m = max(ndims(nd0), 2);
    out = ndcat(arraymap(@(i) cat(m, i * slab, nd0), 1:this), true);

    % the following block has no effect on the output; it should 
    % be deleted once the code is fully tested
    if n > 1 && false
        z = size(nd0);
        z(end) = 1;
        assert(isequal(z, [rest 1]));
    end
end
