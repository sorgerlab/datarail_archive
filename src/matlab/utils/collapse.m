function out = collapse(varargin)
%COLLAPSE(TBL, KEYVARS, AGGNS) produces a new table from the table TBL by
%    collapsing all the rows whose values in the variables KEYVARS (the "key
%    variables") agree; the remaining variables (the "value variables") are computed
%    by applying the functions specified in AGGNS to the original groups of values.
%    AGGNS should be either a cell array of function handles, containing as many
%    elements as there are value variables in TBL, or a single function handle (in
%    which case the same function will be applied to all the value variables).
%
%COLLAPSE(TBL, KEYVARS) is equivalent to COLLAPSE(TBL, KEYVARS, @SUM).
%
%COLLAPSE(TBL) is equivalent to a call to COLLAPSE(TBL, KEYVARS) with KEYVARS
%    set to hold the variables K of TBL for which ISCATEGORICAL(TBL.K) is true.

%    [tbl, kis, vis, aggrs, ~] = ...
%        process_args__({'KeyVars' 'ValVars' 'Aggrs'}, varargin);
%    kns = dr.vns(tbl, kis);
%    vns = dr.vns(tbl, vis);
    [tbl, kns, vns, aggrs, ~] = ...
        process_args__({'KeyVars' 'ValVars' 'Aggrs'}, varargin);
    out = collapse_(tbl, kns, vns, aggrs);
end
