function out = GETC( x, varargin )
%GETC functional replacement for curly-brace index expressions.

    out = x{varargin{:}};
end

