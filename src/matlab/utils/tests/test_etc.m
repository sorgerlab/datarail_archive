function tests = test_etc
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    testCase.TestData.origPath = pwd();
    cd([fileparts(which('collapse')) filesep 'private']);
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
    t1 = collapse(t2);
    h1 = height(t1);
    h2 = height(t2);
    verifyEqual(testCase, h2/2, h1);
    values = @(t) table2mat(t(:, tc.valvars));
    verifyEqual(testCase, 2 * values(t0), values(t1));
end
