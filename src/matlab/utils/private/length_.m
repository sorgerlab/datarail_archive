function [n, d] = length_( seq )
%LENGTH_ return length along first non-trivial dimension.
%   If the length along some dimension is 1, this dimension is
%   said to be "trivial."
%   N = LENGTH_(SEQ) assigns to N the length of the first
%   non-trivial dimension of SEQ.  LENGTH_(SEQ) returns 0 if SEQ is
%   empty, and 1 if all the dimensions of SEQ are trivial.
%
%   [N, D] = LENGTH_(SEQ) in addition assigns to D the number of the
%   first non-trivial dimension of SEQ.  This number will be 1 if
%   SEQ is empty or all its dimensions are trivial.
    if numel(seq) > 0
        sz = size(seq);
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
