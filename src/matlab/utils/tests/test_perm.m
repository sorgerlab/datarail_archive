function tests = test_perm
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
    actual = perm(1:6, [2 6 4], [1 5 3]);
    expected = [3     4     5     6     1     2];
    verifyEqual(testcase, actual, expected);
end
