function tests = test_ith_scalar
    tests = functiontests(localfunctions);
end

%%
function setupOnce(testcase)
end

function teardownOnce(testcase)
end

function setup(testcase)
end

function teardown(testcase)
end

%%
function test_1(testcase)
    actual = ith_scalar({{'a' {1; true}}; {{{'b'}; 2}}}, 1);
    expected = 'a';
    verifyEqual(testcase, actual, expected);
end

%%
function test_2(testcase)
    actual = ith_scalar({{'a' {1; true}}; {{{'b'}; 2}}}, 3);
    expected = true;
    verifyEqual(testcase, actual, expected);
end

%%
function test_3(testcase)
    actual = ith_scalar({{'a' {1; true}}; {{{'b'}; 2}}}, 5);
    expected = 2;
    verifyEqual(testcase, actual, expected);
end

%%
function test_4(testcase)
    verifyError(testcase, ...
                @() ith_scalar({{'a' {1; true}}; {{{'b'}; 2}}}, 6), ...
                'DR20:badindex')
end
