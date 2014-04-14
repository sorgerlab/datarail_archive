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
    if ~isempty(aggrs), args = [args {'Aggrs' aggrs}]; end
    [tbl, kns, vns, aggrs, irreg, ~] = ...
        process_args__({'KeyVars' 'ValVars' 'Aggrs' 'Irregular'}, args);
    try 
        out = collapse_(tbl, aggrs, kns, vns, irreg);
    catch e
        ds = dbstack('-completenames');
        if isequal(ds(end).name, 'runtests') && ...
           ~any(cellfun(@(s) ...
               ~isempty(strfind(s, 'throwsExpectedException')), {ds.name}.'))
            dbstack;
            rethrow(e);
        end
        exc_id = regexprep(e.identifier, 'MATLAB:.*:', 'DR20:collapse:');
        throw(MException(exc_id, e.message));
    end
end
