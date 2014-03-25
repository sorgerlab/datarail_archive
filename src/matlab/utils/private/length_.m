function [n, d] = length_( x )
%LENGTH_ return length along first non-trivial dimension.
%
%   If the length along some dimension is 1, this dimension is
%   said to be "trivial."
%
%   N = LENGTH_(X) assigns to N the length of the first non-trivial
%   dimension of X.  LENGTH_(X) returns 0 if X is empty, and 1 if all the
%   dimensions of X are trivial.
%
%   If X is a table, assigns HEIGHT(X) to N.
%
%   [N, D] = LENGTH_(X) in addition assigns to D the number of the first
%   non-trivial dimension of X.  This number will be 1 if X is empty or all
%   its dimensions are trivial.
%
%   If X is a table, assigns 1 to D.
%

    if istable(x)
        n = height(x);
        d = 1;
    elseif numel(x) > 0
        sz = size(x);
        d = find(sz > 1, 1);
        if isempty(d)
            d = 1;
        end
        n = sz(d);
    else
        n = 0;
        d = 1;
    end
end
