function tests = test_maxdim
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
    actual = maxdim(zeros(2, 4, 4));
    expected = 2;
    verifyEqual(testcase, actual, expected);
end
