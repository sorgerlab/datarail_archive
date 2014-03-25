function out = group_counts(tbl, varargin)
%GROUP_COUNTS count numbers of rows in groupings.
%
%     T2 = GROUP_COUNTS(T1, KEYVARS)
% 
%     T2 = GROUP_COUNTS(T1)
%
    narginchk(1, 2);
    if nargin > 1
        params = {'KeyVars', varargin{1}};
    else
        params = {};
    end
      
    args = [{tbl} params];

    [tbl, kns, ~, ~, ~] = ...
        process_args__({'KeyVars'}, args);

    kis = dr.vidxs(tbl, kns);

    vv = 'counts';
    try
        kvs = tbl.Properties.VariableNames(1, kis);
        vns = matlab.lang.makeUniqueStrings([kvs {vv}]);
        vv = vns{end};
    catch e
        if ~strcmp(e.identifier, 'MATLAB:undefinedVarOrClass')
            rethrow(e);
        end
        vv = genvarname(vv, kvs);
    end
        
    t = tbl(:, kis);
    t.(vv) = ones(height(t), 1);

    out = collapse_(t, @numel, kns, {vv});
end
