function tests = test_group_counts
    tests = functiontests(localfunctions);
end

function setup(testCase)
    sz = [2 3 4];
    testCase.TestData.sz = sz;

    n = numel(sz);
    testCase.TestData.n = n;

    T = make_test_table(sz);
    T = T(:, 1:n);
    testCase.TestData.T = T;

    vars = T.Properties.VariableNames;
    testCase.TestData.vars = vars;

    rng(0);
    permuted_idx = randperm(width(T));
    testCase.TestData.permuted_idx = permuted_idx;
end

function test_0100(testCase)
    run_test_(testCase, 1:testCase.TestData.n);
end

function test_0200(testCase)
    run_test_(testCase, testCase.TestData.permuted_idx);
end

function test_0300(testCase)
    run_test_(testCase, 1);
end

function test_0400(testCase)
    run_test_(testCase, 1:2);
end

function test_0500(testCase)
    n = testCase.TestData.n;
    run_test_(testCase, n-1:n);
end

function test_0600(testCase)
    run_test_(testCase, [1 testCase.TestData.n]);
end

function run_test_(testCase, idx)
    td = testCase.TestData;
    T = td.T;
    vars = td.vars;
    T0 = collapse(T, {}, 'KeyVars', idx);
    sz = td.sz;
    T0.counts = ones(height(T0), 1) * (height(T)/prod(sz(idx)));
    verifyEqual(testCase, T0, group_counts(T, vars(1, idx)))
end

