function tests = test_etc
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
    t234e = make_test_table_([2 3 4], true);
    testCase.TestData.t234e = t234e;
    t234e2 = t234e;
    t234e2.table = vertcat(t234e2.table, t234e2.table);
    testCase.TestData.t234e2 = t234e2;
end

function tt = make_test_table_(sz, expanded)
    tbl = make_test_table(sz, expanded);
    tt = struct('table', tbl, ...
                'size', sz, ...
                'ndims', numel(sz), ...
                'numel', prod(sz), ...
                'expanded', expanded, ...
                'keyvars', guess_keyvars(tbl), ...
                'valvars', guess_valvars(tbl));
end

function teardown(testCase)
end

%%
function test_cartproduct_ds(testCase)
    sz = [2 3 4];
    nd = numel(sz);
    n = prod(sz);

    exp = [1 1 1; 1 1 2; 1 1 3; 1 1 4; 1 2 1; 1 2 2; 1 2 3; 1 2 4; 1 3 1; ...
           1 3 2; 1 3 3; 1 3 4; 2 1 1; 2 1 2; 2 1 3; 2 1 4; 2 2 1; 2 2 2; ...
           2 2 3; 2 2 4; 2 3 1; 2 3 2; 2 3 3; 2 3 4];

    % the expected value above was generated with
    % exp = fliplr(cell2mat(arraymap(make_ind2sub(fliplr(sz)), (1:n)')));

    lvls = arraymap(@(m) 1:m, sz);
    vns = {'Key_A' 'Key_B' 'Key_C'};
    % TODO: make tests more direct (the test below tests only an nd-array
    % derived from the output of the cartproduct_ds function).

    ds = cartproduct_ds(lvls, vns);
    verifyEqual(testCase, ds.Properties.VarNames, vns);
    c = dataset2cell(ds);
    got = cell2mat(sortrows(c(2:end, :)));
    verifyEqual(testCase, got, exp);
end

function test_cartesian_product_table_0(testCase)
    t00 = cartesian_product_table({}, {});
    verifyEqual(testCase, size(t00), [1 0]);
    verifyEqual(testCase, t00.Properties.VariableNames, cell(1, 0));
end

function test_cartesian_product_table_1(testCase)
    vn = {'A' 'B' 'C'};
    t = cartesian_product_table(repmat({{}}, size(vn)), vn);
    verifyEqual(testCase, size(t), [0 3]);
    verifyEqual(testCase, t.Properties.VariableNames, vn);
end

function test_collapse_1(testCase)
    t0 = testCase.TestData.t234e.table;
    tc = testCase.TestData.t234e2;
    t2 = tc.table;
    t1 = collapse(t2, @(x) sum(x, 'native'));
    h1 = height(t1);
    h2 = height(t2);
    verifyEqual(testCase, h2/2, h1);
    values = @(t) table2mat(t(:, tc.valvars));
    verifyEqual(testCase, 2 * values(t0), values(t1));
end

function test_sqz1(testCase)
    a0 = zeros([1 1 2 1 3 1 4]);
    sz0 = size(a0);
    verifyEqual(testCase, size(sqz1(a0)), sz0(2:end));
    verifyEqual(testCase, size(sqz1(sqz1(a0))), sz0(3:end));
    verifyEqual(testCase, size(sqz1(sqz1(sqz1(a0)))), sz0(3:end));
end

function test_make_test_values(testCase)
    sz = [2 3 4];

    i = false; j = false;
    E00 = [111; 112; 113; 114; 121; 122; 123; 124; 131; 132; 133; 134;
           211; 212; 213; 214; 221; 222; 223; 224; 231; 232; 233; 234];

    verifyEqual(testCase, make_test_values(sz      ), E00);
    verifyEqual(testCase, make_test_values(sz, i   ), E00);
    verifyEqual(testCase, make_test_values(sz, i, j), E00);

    %%
    i = false; j = true;
    E01 = [111; 211; 121; 221; 131; 231; 112; 212; 122; 222; 132; 232;
           113; 213; 123; 223; 133; 233; 114; 214; 124; 224; 134; 234];

    verifyEqual(testCase, make_test_values(sz, i, j), E01);

    %%
    i = true; j = false;
    E10 = [1 1 1; 1 1 2; 1 1 3; 1 1 4; 1 2 1; 1 2 2; 1 2 3; 1 2 4;
           1 3 1; 1 3 2; 1 3 3; 1 3 4; 2 1 1; 2 1 2; 2 1 3; 2 1 4;
           2 2 1; 2 2 2; 2 2 3; 2 2 4; 2 3 1; 2 3 2; 2 3 3; 2 3 4];

    verifyEqual(testCase, make_test_values(sz, i   ), E10);
    verifyEqual(testCase, make_test_values(sz, i, j), E10);

    %%
    i = true; j = true;
    E11 = [1 1 1; 2 1 1; 1 2 1; 2 2 1; 1 3 1; 2 3 1; 1 1 2; 2 1 2;
           1 2 2; 2 2 2; 1 3 2; 2 3 2; 1 1 3; 2 1 3; 1 2 3; 2 2 3;
           1 3 3; 2 3 3; 1 1 4; 2 1 4; 1 2 4; 2 2 4; 1 3 4; 2 3 4];

    verifyEqual(testCase, make_test_values(sz, i, j), E11);

end


function test_make_test_nd(testCase)
    sz = [2 3 4];
    RM1 = [111; 112; 113; 114; 121; 122; 123; 124; 131; 132; 133; 134;
           211; 212; 213; 214; 221; 222; 223; 224; 231; 232; 233; 234];
    CM1 = [111; 211; 121; 221; 131; 231; 112; 212; 122; 222; 132; 232;
           113; 213; 123; 223; 133; 233; 114; 214; 124; 224; 134; 234];
    RM3 = [1 1 1; 1 1 2; 1 1 3; 1 1 4; 1 2 1; 1 2 2; 1 2 3; 1 2 4;
           1 3 1; 1 3 2; 1 3 3; 1 3 4; 2 1 1; 2 1 2; 2 1 3; 2 1 4;
           2 2 1; 2 2 2; 2 2 3; 2 2 4; 2 3 1; 2 3 2; 2 3 3; 2 3 4];
    CM3 = [1 1 1; 2 1 1; 1 2 1; 2 2 1; 1 3 1; 2 3 1; 1 1 2; 2 1 2;
           1 2 2; 2 2 2; 1 3 2; 2 3 2; 1 1 3; 2 1 3; 1 2 3; 2 2 3;
           1 3 3; 2 3 3; 1 1 4; 2 1 4; 1 2 4; 2 2 4; 1 3 4; 2 3 4];


    i = false; j = false;
    E00 = [111; 112; 113; 114; 121; 122; 123; 124; 131; 132; 133; 134;
           211; 212; 213; 214; 221; 222; 223; 224; 231; 232; 233; 234];

    verifyEqual(testCase, make_test_values(sz      ), E00);
    verifyEqual(testCase, make_test_values(sz, i   ), E00);
    verifyEqual(testCase, make_test_values(sz, i, j), E00);

    %%
    i = false; j = true;
    E01 = [111; 211; 121; 221; 131; 231; 112; 212; 122; 222; 132; 232;
           113; 213; 123; 223; 133; 233; 114; 214; 124; 224; 134; 234];

    verifyEqual(testCase, make_test_values(sz, i, j), E01);

    %%
    i = true; j = false;
    E10 = [1 1 1; 1 1 2; 1 1 3; 1 1 4; 1 2 1; 1 2 2; 1 2 3; 1 2 4;
           1 3 1; 1 3 2; 1 3 3; 1 3 4; 2 1 1; 2 1 2; 2 1 3; 2 1 4;
           2 2 1; 2 2 2; 2 2 3; 2 2 4; 2 3 1; 2 3 2; 2 3 3; 2 3 4];

    verifyEqual(testCase, make_test_values(sz, i   ), E10);
    verifyEqual(testCase, make_test_values(sz, i, j), E10);

    %%
    i = true; j = true;
    E11 = [1 1 1; 2 1 1; 1 2 1; 2 2 1; 1 3 1; 2 3 1; 1 1 2; 2 1 2;
           1 2 2; 2 2 2; 1 3 2; 2 3 2; 1 1 3; 2 1 3; 1 2 3; 2 2 3;
           1 3 3; 2 3 3; 1 1 4; 2 1 4; 1 2 4; 2 2 4; 1 3 4; 2 3 4];

    verifyEqual(testCase, make_test_values(sz, i, j), E11);

end

%%
function test_fill_missing_keys_(testCase)
    t = make_test_table([2 3 4], true);
    ud = t.Properties.UserData;
    t.Properties.UserData = [];
    kns = ud('keyvars');

    ii = any(...
             cell2mat(...
                      arrayfun(@(i) t.(kns{i}) == t.(kns{i+1}), ...
                               1:numel(kns)-1, 'un', false) ...
                     ), ...
             2);
    % t0 and t1 are complementary subtables of the factorial table t
    t0 = t( ii, :); assert(~isempty(t0));
    t1 = t(~ii, :); assert(~isempty(t1));

    % the next QC check ensures that t is factorial (in the variables in
    % kns), and that t0 and t1 are complementary subtables of t.
    assert(isfactorial_(t, kns) && ...
           isequal(setdiff(t, t0), t1) && ...
           isequal(setdiff(t, t1), t0));
    clear('ii');

    f0 = fill_missing_keys_(t0, kns);
    f1 = fill_missing_keys_(t1, kns);
    h = height(t);

    verifyTrue(testCase, height(f0) == h && height(f1) == h);

    % the next tests verify that the rows added to one table have the same
    % key values as those in the rows of complementary table; the
    % comparison is done on sorted tables, since the specification for the
    % says nothing about the ordering of the added rows.
    verifyEqual(testCase, sortrows(f0(~ismember(f0, t0), kns)), ...
                          sortrows(t1(:, kns)));
    verifyEqual(testCase, sortrows(f1(~ismember(f1, t1), kns)), ...
                          sortrows(t0(:, kns)));
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
                      arrayfun(@(i) t.(kns{i}) == t.(kns{i+1}), ...
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

    c2 = collapse(t1, @(x) sum(x, 'native'), 'KeyVars', kns, ...
                                             'ValVars', vns);
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
function test_table_to_factorial_(testCase)
    t = make_test_table([2 3 4], true);
    ud = t.Properties.UserData;
    t.Properties.UserData = [];
    kns = ud('keyvars');
    vns = ud('valvars');

    ii = any(...
             cell2mat(...
                      arrayfun(@(i) t.(kns{i}) == t.(kns{i+1}), ...
                               1:numel(kns)-1, 'un', false) ...
                     ), ...
             2);
    % t0 and t1 are complementary subtables of the factorial table t
    t0 = t( ii, :); assert(~isempty(t0));
    t1 = t(~ii, :); assert(~isempty(t1));

    % the next QC check ensures that t is factorial (in the variables in
    % kns), and that t0 and t1 are complementary subtables of t.
    assert(isfactorial_(t, kns) && ...
           isequal(setdiff(t, t0), t1) && ...
           isequal(setdiff(t, t1), t0));
    clear('ii');

    function [] = dotests(t_)
        s = vertcat(t_, t_, t_);
        %u0 = table_to_factorial_(s, kns, {}, {});
        u0 = table_to_factorial(s, 'KeyVars', kns, 'ValVars', {});
        verifyTrue(testCase, isfactorial_(u0));
        verifyEqual(testCase, sortrows(u0), t(:, kns));

        %u1 = table_to_factorial_(s, kns, vns(end), @sum);
        u1 = table_to_factorial(s, 'KeyVars', kns, ...
                                   'ValVars', vns(end), ...
                                   'Aggrs', @sum);
        verifyTrue(testCase, isfactorial_(u1, kns));
        verifyEqual(testCase, sortrows(u1(:, kns)), t(:, kns));
        verifyEqual(testCase, ...
                    u1{ismember(t_(:, kns), u1(:, kns)), vns{end}}, ...
                    cast(3 * t_{:, vns{end}}, ...
                         class(u1{:, vns{end}})));

        %u2 = table_to_factorial_(s, kns, vns, @sum);
        u2 = table_to_factorial(s, 'KeyVars', kns, ...
                                   'ValVars', vns, ...
                                   'Aggrs', @sum);
        verifyTrue(testCase, isfactorial_(u2, kns));
        verifyEqual(testCase, sortrows(u2(:, kns)), t(:, kns));
        verifyEqual(testCase, ...
                    u2{ismember(t_(:, kns), u2(:, kns)), vns}, ...
                    cast(3 * t_{:, vns}, ...
                         class(u2{:, vns})));

        %u3 = table_to_factorial_(s, kns, vns(1, [2 3]), {@mean, @median});
        u3 = table_to_factorial(s, 'KeyVars', kns, ...
                                   'ValVars', vns(1, [2 3]), ...
                                   'Aggrs', {@mean, @median});
        verifyTrue(testCase, isfactorial_(u3, kns));
        verifyEqual(testCase, sortrows(u3(:, kns)), t(:, kns));
        verifyEqual(testCase, ...
                    u3{ismember(t_(:, kns), u3(:, kns)), vns(1, [2 3])}, ...
                    cast(t_{:, vns(1, [2 3])}, ...
                         class(u3{:, vns(1, [2 3])})));
    end

    dotests(t0);
    dotests(t1);
end

function tf = isfactorial_(u, varargin)
    narginchk(1, 2);
    if nargin == 2
        t = u(:, varargin{1});
    else
        t = u;
    end
    tf = isequal(height(unique(t)), ...
                 prod(varfun(@(c) numel(unique(c)), t, ...
                             'ou', 'uniform')));
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

    % nc = size(tbl, 2);
    ci = 1:size(tbl, 2);
    vi = setdiff(find(arrayfun(@(i) ~iscategorical(tbl.(i)), ci)), ...
                 ki, 'stable');

    %vi = setdiff(1:size(tbl, 2), ki, 'stable')
    %vi = vi(arrayfun(@(i) ~iscategorical(tbl.(i)), vi));

    assert(isrow(vi));
    if nargout > 1
        vns = tbl.Properties.VariableNames;
        vn = vns(vi);
        assert(isrow(vn));
    end
end

%{
%%

function test_hslice(testCase)
    sh = [3 2 3 2 3];
    nda = reshape(1:prod(sh), sh);
    clear('sh');

    for c1 = {nda num2cell(nda)}
        tnd = c1{1};
        for c2 = {2, 2:2, [3 1]}
            ix = c2{1};
            verifyEqual(testCase, hslice(tnd, 1, ix), tnd(ix, :, :, :, :));
            verifyEqual(testCase, hslice(tnd, 3, ix), tnd(:, :, ix, :, :));
            verifyEqual(testCase, hslice(tnd, 5, ix), tnd(:, :, :, :, ix));
        end
        warning('off', 'hslice:alreadySlice');
        verifyEqual(testCase, hslice(tnd, 7, 1), tnd(:, :, :, :, :, :, 1));
        verifyEqual(testCase, hslice(tnd, 7, [1 1]), ...
                              tnd(:, :, :, :, :, :, [1 1]));
        warning('off', 'hslice:alreadySlice');
    end
end


%%
function test_tomaxdims(testCase)

    iis = {1:1, 2:3, 4:6};
    jjs = {1:2, 3:5, 6:9};
    kks = {1:2, 3:5, 6:6};

    sh = cellfun(@(c) max(cell2mat(c(end))), {iis, jjs, kks});

    A = num2cell(reshape(1:prod(sh), sh));
    %A = num2cell(dr.mkslab(sh, true, true));

    B = cell(numel(iis), numel(jjs), numel(kks));

    for i = 1:3
        Si = hslice(A, 1, iis{i});
        for j = 1:3
            Sj = hslice(Si, 2, jjs{j});
            for k = 1:3
                B{i, j, k} = hslice(Sj, 3, kks{k});
            end
        end
    end

    verifyEqual(testCase, tomaxdims(B), A);

    C = cell(numel(iis), 1);
    for i = 1:3
        Ci = cell(numel(jjs), 1);
        Si = hslice(A, 1, iis{i});
        for j = 1:3
            Cij = cell(numel(kks), 1);
            Sj = hslice(Si, 2, jjs{j});
            for k = 1:3
                Cij{k} = hslice(Sj, 3, kks{k});
            end
            Ci{j} = Cij;
        end
        C{i} = Ci;
    end

    verifyEqual(testCase, tomaxdims(C), A);

end

%%
function test_slice1_(testCase)

    iis = {1:1, 2:3, 4:6};
    jjs = {1:2, 3:5, 6:9};
    kks = {1:2, 3:5, 6:6};

    sh = cellfun(@(c) max(cell2mat(c(end))), {iis, jjs, kks});
    idxs = cellmap(@(c) cellfun(@numel, c), {iis jjs kks});

    A = num2cell(reshape(1:prod(sh), sh));
    %A = num2cell(dr.mkslab(sh, true, true));

    B = cell(numel(iis), numel(jjs), numel(kks));

    for i = 1:3
        Si = hslice(A, 1, iis{i});
        for j = 1:3
            Sj = hslice(Si, 2, jjs{j});
            for k = 1:3
                B{i, j, k} = hslice(Sj, 3, kks{k});
            end
        end
    end
    verifyEqual(testCase, B, slice1_(A, idxs));

    C = cell(numel(iis), 1);
    for i = 1:3
        Ci = cell(numel(jjs), 1);
        Si = hslice(A, 1, iis{i});
        for j = 1:3
            Cij = cell(numel(kks), 1);
            Sj = hslice(Si, 2, jjs{j});
            for k = 1:3
                Cij{k} = hslice(Sj, 3, kks{k});
            end
            Ci{j} = Cij;
        end
        C{i} = Ci;
    end

    verifyEqual(testCase, C, slice1_(A, idxs, true))
end
%}
