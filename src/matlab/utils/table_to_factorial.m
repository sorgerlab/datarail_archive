function factorial_table = table_to_factorial(varargin)
%TABLE_TO_FACTORIAL(TBL, KEYVARS, AGGNS) is shorthand for
%    FILL_MISSING_KEYS(COLLAPSE(TBL, KEYVARS, AGGNS), KEYVARS).
%
%TABLE_TO_FACTORIAL(TBL, KEYVARS) is shorthand for
%    FILL_MISSING_KEYS(COLLAPSE(TBL, KEYVARS), KEYVARS).
%
%TABLE_TO_FACTORIAL(TBL) is shorthand for FILL_MISSING_KEYS(COLLAPSE(TBL)).

    % [tbl, kis, vis, aggrs, ~] = ...
    %     process_args__({'KeyVars' 'ValVars' 'Aggrs'}, varargin);
    % kns = dr.vns(tbl, kis);
    % vns = dr.vns(tbl, vis);
    [tbl, kns, vns, aggrs, ~] = ...
        process_args__({'KeyVars' 'ValVars' 'Aggrs'}, varargin);
    factorial_table = table_to_factorial_(tbl, kns, vns, aggrs);
end
