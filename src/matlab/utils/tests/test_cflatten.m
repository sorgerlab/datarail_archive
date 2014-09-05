function tests = test_cflatten
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
    actual = cflatten({{'a' {1; true}}; {{{'b'}; 2}}});
    expected = {'a' 1 true 'b' 2};
    verifyEqual(testcase, actual, expected);
end
