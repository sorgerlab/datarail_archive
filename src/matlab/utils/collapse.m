function out = collapse(tbl, aggrs, varargin)
%COLLAPSE consolidate groups of rows into single rows.
%
%     T2 = COLLAPSE(T1, AGGRS)
%
%     T2 = COLLAPSE(T1, AGGRS, 'PARAM1',val1, 'PARAM2',val2, ...) allows
%     you to specify optional parameter name/value pairs to control
%     COLLAPSE's behavior.  These parameters are listed below, and their
%     documentation is identical to those of the same-named parameters for
%     the function TABLE_TO_NDARRAY.
%
%         'KeyVars'
%         'ValVars'

    narginchk(2, 6);
    args = [{tbl} varargin];
    [tbl, kns, vns, ~, ~] = ...
        process_args__({'KeyVars' 'ValVars'}, args);
    out = collapse_(tbl, aggrs, kns, vns);
end
