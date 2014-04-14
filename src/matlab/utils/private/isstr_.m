function [varargout] = isstr_(varargin)
%ISSTR_ return true iff argument is a "single string."
%
%    Examples:
%
%    >> isstr_('xyz')
%    ans =
%         1
%
%    >> isstr_(['x' 'y' 'z'])
%    ans =
%         1
%
%    >> isstr_(['x'; 'y'; 'z'])
%    ans =
%         0
%
%    >> ischar(['x'; 'y'; 'z'])
%    ans =
%         1
%
%    >> isstr_({'x' 'y' 'z'})
%    ans =
%         0
%
    % stub
    tmp = num2cell(zeros(1, nargout));
    [varargout{1:nargout}] = tmp{:};
end
