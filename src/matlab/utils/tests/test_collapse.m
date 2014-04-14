function tests = test_collapse
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    testCase.TestData.origPath = pwd();
    cd(fullfile(mfiledir(), '..', 'private'));
end

function teardownOnce(testCase)
    cd(testCase.TestData.origPath);
end

function setup(testCase)
    base = make_test_case_([2 3 4], true);

    %--------------------------------------------------------------------------
    t234e = base;
    testCase.TestData.t234e = t234e;

    %--------------------------------------------------------------------------
    t234e2 = base;
    t234e2.table = vertcat(t234e2.table, t234e2.table);
    testCase.TestData.t234e2 = t234e2;

    %--------------------------------------------------------------------------
    t234ef = base;
    t0 = t234ef.table;
    d0 = double(t0.(2));
    ts = {};
    for i = torow(unique(d0))
        ts = [ts repmat({t0(d0 == i, :)}, 1, i)];
    end
    t234ef.table = vertcat(ts{:});
    testCase.TestData.t234ef = t234ef;
end

function tt = make_test_case_(sz, expanded)
    tbl = make_test_table(sz, expanded);
    tt = struct('table', tbl, ...
                'size', sz, ...
                'ndims', numel(sz), ...
                'numel', prod(sz), ...
                'expanded', expanded, ...
                'keyvars', guess_keyvars(tbl), ...
                'valvars', guess_valvars(tbl));
end

function [vi, vn] = guess_keyvars( tbl )
    i = varfun(@iscategorical, tbl, 'OutputFormat', 'uniform');
    vi = find(i);
    assert(isrow(vi));
    if nargout > 1
        vns = tbl.Properties.VariableNames;
        vn = vns(vi);
        assert(isrow(vn));
    end
end

function [vi, vn] = guess_valvars( tbl, varargin )
    narginchk(1, 2);
    if nargin == 1
        ki = guess_keyvars(tbl);
    else
        ki = varargin{1};
    end

    ci = 1:size(tbl, 2);
    vi = setdiff(find(arrayfun(@(i) ~iscategorical(tbl.(i)), ci)), ...
                 ki, 'stable');

    assert(isrow(vi));
    if nargout > 1
        vns = tbl.Properties.VariableNames;
        vn = vns(vi);
        assert(isrow(vn));
    end
end

%%
function test_collapse_1(testCase)
    t0 = testCase.TestData.t234e.table;
    tc = testCase.TestData.t234e2;
    t2 = tc.table;
    t1 = collapse(t2, @(x) sum(x, 'native'));
    h1 = height(t1);
    h2 = height(t2);
    verifyEqual(testCase, h1, h2/2);
    values = @(t) table2mat(t(:, tc.valvars));
    verifyEqual(testCase, values(t1), 2 * values(t0));
end

%%
function SKIP__test_collapse_2(testCase)
    tc = testCase.TestData.t234e;
    t0 = tc.table;
    t1 = t0(:, tc.keyvars);
    for v = tc.valvars, t1.(v) = [t0.(v) t0.(v)]; end
    t1.Properties.VariableNames = varnames(t0);
    t2 = testCase.TestData.t234e2.table;

    verifyEqual(testCase, collapse(t2, @horzcat), t1);
    verifyEqual(testCase, collapse(t2, @vertcat), t1);
end

%%
function test_collapse_(testCase)
    t = make_test_table([2 3 4], true);
    ud = t.Properties.UserData;
    t.Properties.UserData = [];
    kns = ud('keyvars');
    vns = ud('valvars');

    ii = any(...
             cell2mat(...
                      arrayfun(@(i) ...
                               double(t.(kns{i})) == double(t.(kns{i+1})), ...
                               1:numel(kns)-1, 'un', false) ...
                     ), ...
             2);
    t0 = t( ii, :); assert(~isempty(t0));
    t1 = vertcat(t0, t0, t0);

    c0 = collapse(t1, @(x) sum(x, 'native'), 'KeyVars', kns);
    verifyEqual(testCase, c0(:, kns), t0(:, kns));

    c1 = collapse(t1, @(x) sum(x, 'native'), 'KeyVars', kns, ...
                                             'ValVars', vns(end));
    verifyEqual(testCase, c1(:, kns), t0(:, kns));
    verifyEqual(testCase, c1.(vns{end}), ...
                          cast(3 * t0.(vns{end}), ...
                               class(c1.(vns{end}))));

    c2 = collapse(t1, @(x) sum(x, 'native'), 'KeyVars', kns, 'ValVars', vns);
    verifyEqual(testCase, c2(:, kns), t0(:, kns));
    verifyEqual(testCase, ...
                c2{:, vns}, ...
                cast(3 * t0{:, vns}, class(c2{:, vns})));

    c3 = collapse(t1, {@mean, @median}, 'KeyVars', kns, ...
                                        'ValVars', vns(1, [2 3]));
    verifyEqual(testCase, c3(:, kns), t0(:, kns));
    verifyEqual(testCase, ...
                c3{:, vns(1, [2 3])}, ...
                cast(t0{:, vns(1, [2 3])}, class(c3{:, vns(1, [2 3])})));
end

%%
function test_collapse_empty_keyvars(testCase)
    tc = testCase.TestData.t234e;
    t = sortrows(tc.table);

    % explicit empty KeyVars
    expected = t(1, tc.valvars);
    actual = collapse(t, @min, 'KeyVars', {});
    verifyEqual(testCase, actual, expected);

    expected = t(1, tc.valvars(1));
    actual = collapse(t, @min, 'KeyVars', {}, 'ValVars', tc.valvars(1));
    verifyEqual(testCase, actual, expected);

    % implicit empty KeyVars
    expected = t(1, :);
    actual = collapse(t, @min, 'ValVars', 1:width(t));
    verifyEqual(testCase, actual, expected);

    expected = t(1, tc.keyvars);
    actual = collapse(t, @min, 'ValVars', tc.keyvars);
    verifyEqual(testCase, actual, expected);

    expected = t(1, [tc.keyvars tc.valvars(1:end)]);
    actual = collapse(t, @min, 'ValVars', [tc.keyvars tc.valvars(1:end)]);
    verifyEqual(testCase, actual, expected);
end

%%
function SKIP_____test_collapse_2d_cols(testCase)
    function t = cast_(t, cls)
        if strcmp(cls, 'none'), return; end

        if strcmp(cls, 'cellstr')
            convert_ = @(c) arraymap(@num2str, c);
        elseif strcmp(cls, 'cell')
            convert_ = @num2cell;
        elseif strcmp(cls, 'cell2')
            convert_ = @(c) arraymap(@num2cell, c);
        else
            assert(false);
        end

        ud = t.Properties.UserData;
        for v = ud('valvars'), t.(v{:}) = convert_(t.(v{:})); end
    end

    function [arg, expected] = make_tables_(cls, base, cf)
        arg = cast_(base, cls);
        t = cast_(unique(base, 'rows', 'stable'), cls);
        ud = t.Properties.UserData;
        expected = t(:, ud('keyvars'));
        for v = ud('valvars'), expected.(v{:}) = cf(t, v{:}); end
        expected.Properties.VariableNames = varnames(t);
    end

    td = testCase.TestData;

    t234ef = td.t234ef.table;
    function [arg, expected] = make_tables_f(cls)
        function c = cf(t, v)
            c = rowfun(@(i, u) repmat(u, 1, double(i)), t, ...
                       'OutputFormat', 'cell', ...
                       'InputVariables', {'B' v});
        end
        [arg, expected] = make_tables_(cls, t234ef, @cf);
    end

    t234e2 = td.t234e2.table;
    function [arg, expected] = make_tables_2(cls)
        function c = cf(t, v), c = [t.(v) t.(v)]; end
        [arg, expected] = make_tables_(cls, t234e2, @cf);
    end

    w = numel(td.t234e.table.Properties.UserData('valvars'));
    for cls = {'none' 'cellstr' 'cell' 'cell2'}
        for mt_ = {@make_tables_f, @make_tables_2}
            [arg, expected] = mt_{1}(cls);
            %for aggr = {@horzcat, @vertcat}
            for aggr = {@(x) reshape(x, 1, [])}
                for ag = {aggr{1} repmat(aggr, 1, w)}
                    actual = collapse(arg, ag{1});
                    verifyEqual(testCase, actual, expected);
                end
            end
        end
 ...
end
end


%--------------------------------------------------------------------------------
%--------------------------------------------function test_

function out = maybe_vertcat_(c)
    try
        out = vertcat(c{:});
    catch e
        if ~strcmp(e.identifier, ...
                   'MATLAB:catenate:dimensionMismatch')
            rethrow(e);
        end
        out = c;
    end
end

function out = table_(data, varargin)
    d = cellmap(@maybe_vertcat_, num2cell(data, 1));
    out = table(d{:}, varargin{:});
end

%%
function test_collapse_basic(testCase)
    t        = table_({10 0;
                       20 0;
                       20 0;
                       30 0;
                       30 0;
                       30 0});
    expected = table_({10 1;
                       20 2;
                       30 3});
    actual = collapse(t, @numel, 'KeyVars', {1});
    verifyEqual(testCase, actual, expected);
end

%%
function test_collapse_empty_valvars(testCase)
    t        = table_({2 3;
                       1 1;
                       1 3;
                       1 1;
                       2 1;
                       1 1;
                       1 2;
                       2 1;
                       1 1;
                       1 1;
                       2 1;
                       2 1;
                       2 1;
                       1 1;
                       2 2});
    expected = table_({2 3;
                       1 1;
                       1 3;
                       2 1;
                       1 2;
                       2 2});
    actual = collapse(t, {}, 'KeyVars', {1, 2});
    verifyEqual(testCase, actual, expected);
end

%%
function test_collapse_irregular(testCase)
    t        = table_({0 1;
                       1 2});
    expected = table_({0 0;
                       1 [0 0]});
    actual = collapse(t, @(x) zeros(1, x), ...
                      'KeyVars', {1}, 'Irregular', true);
    verifyEqual(testCase, actual, expected);
end

%%
function test_collapse_preserve_order(testCase)
    t        = table_({6 0;
                       6 0;
                       4 0;
                       5 0;
                       6 0;
                       5 0});
    expected = table_({6 3;
                       4 1;
                       5 2});
    actual = collapse(t, @numel, 'KeyVars', {1});
    verifyEqual(testCase, actual, expected);
end

%%
function test_collapse_args_getter(testCase)
    t        = table_({6;
                       6;
                       4;
                       5;
                       6;
                       5});
    to_12345 = @(a) catc(1, arraymap(@(i) i * ones(1:5), a));
    t.(2) = to_12345(t.(1));

    expected = table_({6 360;
                       4 120;
                       5 240});

    actual = collapse(t, @numel, 'KeyVars', {1});
    verifyEqual(testCase, actual, expected);
end

%%
function test_collapse_nonmatrix_key(testCase)
    t        = table_({6 0;
                       6 0;
                       4 0;
                       5 0;
                       6 0;
                       5 0});

    expected = table_({6 3;
                       4 1;
                       5 2});

    to_12345 = @(a) catc(1, arraymap(@(i) i * ones(1:5), a));
    t.(1)        = to_12345(t.(1));
    expected.(1) = to_12345(expected.(1));

    actual = collapse(t, @numel, 'KeyVars', {1});
    verifyEqual(testCase, actual, expected);
end

%%
function test_collapse_basic_2(testCase)
    t        = table_({10 0 0;
                       20 0 0;
                       20 0 0;
                       30 0 0;
                       30 0 0;
                       30 0 0});
    expected = table_({10 1 0;
                       20 2 [0 0];
                       30 3 [0 0 0]});

    actual = collapse(t, {@numel @(x) zeros(1, numel(x))}, ...
                      'KeyVars', {1}, 'Irregular', {false true});
    verifyEqual(testCase, actual, expected);
end

%%
function test_collapse_error_in_aggr(testCase)
    t = table(1);
    function [varargout] = fails(~), error('test failure'); end
    verifyError(testCase, @() collapse(t, @fails), ...
                'DR20:collapse:FunFailedGrouped');
end

%%
function test_collapse_nonrow_output(testCase)
    t        = table_({0 1;
                       0 2});
    verifyError(testCase, @() collapse(t, @(x) x, 'KeyVars', {1}), ...
                'DR20:collapse:ReturnedValueIsNotRowVector');
end

%%
function SKIP__test_collapse_(testCase)
    t = make_test_table([2 3 4], true);
    ud = t.Properties.UserData;
    t.Properties.UserData = [];
    kns = ud('keyvars');
    vns = ud('valvars');

    ii = any(...
             cell2mat(...
                      arrayfun(@(i) ...
                               double(t.(kns{i})) == double(t.(kns{i+1})), ...
                               1:numel(kns)-1, 'un', false) ...
                     ), ...
             2);
    t0 = t( ii, :); assert(~isempty(t0));
    t1 = vertcat(t0, t0, t0);

    c3 = collapse(t1, {@mean, @median}, 'KeyVars', kns, ...
                                        'ValVars', vns(1, [2 3]));
    verifyEqual(testCase, c3(:, kns), t0(:, kns));
    verifyEqual(testCase, ...
                c3{:, vns(1, [2 3])}, ...
                cast(t0{:, vns(1, [2 3])}, class(c3{:, vns(1, [2 3])})));
end

%%
function SKIP__test_collapse_2d_cols(testCase)
    function t = cast_(t, cls)
        if strcmp(cls, 'none'), return; end

        if strcmp(cls, 'cellstr')
            convert_ = @(c) arraymap(@num2str, c);
        elseif strcmp(cls, 'cell')
            convert_ = @num2cell;
        elseif strcmp(cls, 'cell2')
            convert_ = @(c) arraymap(@num2cell, c);
        else
            assert(false);
        end

        ud = t.Properties.UserData;
        for v = ud('valvars'), t.(v{:}) = convert_(t.(v{:})); end
    end

    function [arg, expected] = make_tables_(cls, base, cf)
        arg = cast_(base, cls);
        t = cast_(unique(base, 'rows', 'stable'), cls);
        ud = t.Properties.UserData;
        expected = t(:, ud('keyvars'));
        for v = ud('valvars'), expected.(v{:}) = cf(t, v{:}); end
        expected.Properties.VariableNames = varnames(t);
    end

    td = testCase.TestData;

    t234ef = td.t234ef.table;
    function [arg, expected] = make_tables_f(cls)
        function c = cf(t, v)
            c = rowfun(@(i, u) repmat(u, 1, double(i)), t, ...
                       'OutputFormat', 'cell', ...
                       'InputVariables', {'B' v});
        end
        [arg, expected] = make_tables_(cls, t234ef, @cf);
    end

    t234e2 = td.t234e2.table;
    function [arg, expected] = make_tables_2(cls)
        function c = cf(t, v), c = [t.(v) t.(v)]; end
        [arg, expected] = make_tables_(cls, t234e2, @cf);
    end

    w = numel(td.t234e.table.Properties.UserData('valvars'));

% $$$     cls = {'none'};
% $$$     mt_ = {@make_tables_f};
% $$$     [arg, expected] = mt_{1}(cls{1});
% $$$     function out = kluge(x)
% $$$         %y = repmat({x}, numel(x));
% $$$         y = repmat({x}, x(1, 1));
% $$$         out = vertcat(y{:});
% $$$         %error('frobozz');
% $$$         1;
% $$$     end
% $$$     %aggr = {@numel, @(x) x, @(x) vertcat(x, x)};
% $$$     %aggr = {@numel};
% $$$     %aggr = {@horzcat};
% $$$     %aggr = {@vertcat};
% $$$     aggr = {@kluge};
% $$$     ag = aggr;
% $$$     actual = collapse(arg, ag{1});
% $$$     1;
% $$$     verifyEqual(testCase, actual, expected);

% $$$     function out = hcat(x)
% $$$         out = reshape(x, 1, []);
% $$$     end

% $$$     for cls = {'none'}
% $$$         for mt_ = {@make_tables_f}
% $$$             [arg, expected] = mt_{1}(cls{1});
% $$$             for aggr = {@hcat}
% $$$                 for ag = aggr
% $$$                     actual = collapse(arg, ag{1});
% $$$                     verifyEqual(testCase, actual, expected);
% $$$                 end
% $$$             end
% $$$         end
% $$$     end

    hcat = @(x) reshape(x, 1, []);

    for cls = {'none' 'cellstr' 'cell' 'cell2'}
        for mt_ = {@make_tables_f, @make_tables_2}
            [arg, expected] = mt_{1}(cls{1});
            for ag = [{hcat} repmat({hcat}, 1, w)]
                actual = collapse(arg, ag{1});
                verifyEqual(testCase, actual, expected);
            end
        end
    end

end





% need tests for:
% * order-preservation
%     + empty keyvar
% * failure of an *anonymous* aggr: too many output arguments error?
%
% need test of collapse's order-preservation, especially for the case of empty valvars
%%
