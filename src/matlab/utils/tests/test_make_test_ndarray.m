function tests = test_make_test_ndarray
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
    make_test_ndarray_tester_(testCase, sz, expanded);
end

function test_happypath_collapsed(testCase)
    sz = testCase.TestData.HappyPath;
    expanded = false;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

%%
function test_single_dim_expanded(testCase)
    sz = testCase.TestData.SingleDim;
    expanded = true;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

function test_single_dim_collapsed(testCase)
    sz = testCase.TestData.SingleDim;
    expanded = false;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

%%
function test_single_dim_1_expanded(testCase)
    sz = testCase.TestData.SingleDim1;
    expanded = true;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

function test_single_dim_1_collapsed(testCase)
    sz = testCase.TestData.SingleDim1;
    expanded = false;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

%%
function test_single_dim_2_expanded(testCase)
    sz = testCase.TestData.SingleDim2;
    expanded = true;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

function test_single_dim_2_collapsed(testCase)
    sz = testCase.TestData.SingleDim2;
    expanded = false;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

%%
function test_trivial_dims_expanded(testCase)
    sz = testCase.TestData.TrivialDims;
    expanded = true;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

function test_trivial_dims_collapsed(testCase)
    sz = testCase.TestData.TrivialDims;
    expanded = false;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

%%
function test_trivial_leading_dims_expanded(testCase)
    sz = testCase.TestData.TrivialLeadingDims;
    expanded = true;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

function test_trivial_leading_dims_collapsed(testCase)
    sz = testCase.TestData.TrivialLeadingDims;
    expanded = false;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

%%
function test_trivial_trailing_dims_expanded(testCase)
    sz = testCase.TestData.TrivialTrailingDims;
    expanded = true;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

function test_trivial_trailing_dims_collapsed(testCase)
    sz = testCase.TestData.TrivialTrailingDims;
    expanded = false;
    make_test_ndarray_tester_(testCase, sz, expanded);
end

%%
function test_empty_expanded(testCase)
    sz = testCase.TestData.Empty;
    expanded = true;
    empty_tester_(testCase, sz, expanded);
end

function test_empty_collapsed(testCase)
    sz = testCase.TestData.Empty;
    expanded = false;
    empty_tester_(testCase, sz, expanded);
end

%%

function make_test_ndarray_tester_(testCase, sz, expanded)
    nd = numel(sz);
    assert(nd > 0);
    n = prod(sz);
    ta = dr.unroll(make_test_ndarray(sz, expanded), false);
    chk = logical(n);
    if expanded
        get = @(i) ta(i, :);
    else
        get = @(i) expand_(ta(i));
    end

    zs = fliplr(sz);
    cls = class(ta);
    function out = i2s_(i)
        [idx{nd:-1:1}] = ind2sub(zs, i);
        out = cast(cell2mat(idx), cls);
    end

    arrayfun(@(i) verifyEqual(testCase, get(i), i2s_(i)), 1:n);
end

function empty_tester_(testCase, sz, expanded)
    act = make_test_ndarray(sz, expanded);
    if expanded
        exp = reshape([], [1, 0]);
    else
        exp = 0;
    end
    verifyEqual(testCase, act, cast(exp, class(act)));
end
