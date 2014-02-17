function factorial_table = table_to_factorial(tbl, varargin)
    narginchk(1, 3);
    factorial_table = fill_missing_keys(collapse(tbl, varargin{:}), ...
                                        varargin{1:min(1, numel(varargin))});
end