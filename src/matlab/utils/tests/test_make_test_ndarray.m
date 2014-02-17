function tests = test_make_test_ndarray
    tests = functiontests(localfunctions);
end

function setup(testCase)
    testCase.TestData.HappyPath = [2 3 4];
    testCase.TestData.SingleDim = 4;
    testCase.TestData.TrivialDims = [2 1 3 1 4];
    testCase.TestData.TrivialLeadingDims = [1 1 2 3 4];
    testCase.TestData.TrivialTrailingDims = [2 3 4 1 1];
    testCase.TestData.SingleDim1 = [1 1 4];
    testCase.TestData.SingleDim2 = [4 1 1];
    testCase.TestData.Empty = [];
end
    
function teardown(testCase)
    testCase.TestData.HappyPath = [];
end

%%
function test_happypath_expanded(testCase)
    sz = testCase.TestData.HappyPath;
    expanded = true;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

function test_happypath_collapsed(testCase)
    sz = testCase.TestData.HappyPath;
    expanded = false;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

%%
function test_single_dim_expanded(testCase)
    sz = testCase.TestData.SingleDim;
    expanded = true;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

function test_single_dim_collapsed(testCase)
    sz = testCase.TestData.SingleDim;
    expanded = false;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

%%
function test_single_dim_1_expanded(testCase)
    sz = testCase.TestData.SingleDim1;
    expanded = true;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

function test_single_dim_1_collapsed(testCase)
    sz = testCase.TestData.SingleDim1;
    expanded = false;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

%%
function test_single_dim_2_expanded(testCase)
    sz = testCase.TestData.SingleDim2;
    expanded = true;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

function test_single_dim_2_collapsed(testCase)
    sz = testCase.TestData.SingleDim2;
    expanded = false;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

%%
function test_trivial_dims_expanded(testCase)
    sz = testCase.TestData.TrivialDims;
    expanded = true;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

function test_trivial_dims_collapsed(testCase)
    sz = testCase.TestData.TrivialDims;
    expanded = false;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

%%
function test_trivial_leading_dims_expanded(testCase)
    sz = testCase.TestData.TrivialLeadingDims;
    expanded = true;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

function test_trivial_leading_dims_collapsed(testCase)
    sz = testCase.TestData.TrivialLeadingDims;
    expanded = false;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

%%
function test_trivial_trailing_dims_expanded(testCase)
    sz = testCase.TestData.TrivialTrailingDims;
    expanded = true;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

function test_trivial_trailing_dims_collapsed(testCase)
    sz = testCase.TestData.TrivialTrailingDims;
    expanded = false;
    verifyTrue(testCase, make_test_ndarray_tester_(sz, expanded));
end

%%
function test_empty_expanded(testCase)
    sz = testCase.TestData.Empty;
    expanded = true;
    verifyTrue(testCase, empty_tester_(sz, expanded));
end

function test_empty_collapsed(testCase)
    sz = testCase.TestData.Empty;
    expanded = false;
    verifyTrue(testCase, empty_tester_(sz, expanded));
end

%%

function ok = make_test_ndarray_tester_(sz, expanded)
    nd = numel(sz);
    assert(nd > 0);
    n = prod(sz);

    ta = reshape(make_test_ndarray(sz, expanded), n, []);
    chk = logical(n);
    if expanded
        get = @(i) ta(i, :);
    else
        get = @(i) expand(ta(i));
    end
    
    function out = i2s_(i)
        [idx{1:nd}] = ind2sub(sz, i);
        out = cell2mat(idx);
    end

    ok = all(arrayfun(@(i) isequal(i2s_(i), get(i)), 1:n));    
end

function ok = empty_tester_(sz, expanded)
    got = make_test_ndarray(sz, expanded);
    if expanded
        exp = [];
    else
        exp = 0;
    end
    ok = isequal(got, exp);
end

function out = expand(n)
    out = arrayfun(@str2double, int2str(n));
end
