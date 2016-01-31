function varargout = placebo(x, varargin)
    narginchk(1, 2);
    if nargin > 1
        d = varargin{1};
        assert(size(x, d) == nargout);
    else
        d = find(size(x) == nargout, 1);
    end
    varargout = arraymap(@(i) hslice(x, d, i), 1:nargout);
end
