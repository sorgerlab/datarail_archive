function tests = test_permcols
    tests = functiontests(localfunctions);
end

%%
function setupOnce(testcase)
end

function teardownOnce(testcase)
end

function setup(testcase)
    testcase.TestData.table = mktbl({{1 2 3 4 5 6}; ...
                                     {1 2 3 4 5 6}; ...
                                     {1 2 3 4 5 6}; ...
                                     {1 2 3 4 5 6}}, ...
                                    {'A' 'B' 'C' 'D' 'E' 'F'});

    testcase.TestData.expected = mktbl({{3 4 5 6 1 2}; ...
                                        {3 4 5 6 1 2}; ...
                                        {3 4 5 6 1 2}; ...
                                        {3 4 5 6 1 2}}, ...
                                       {'C' 'D' 'E' 'F' 'A' 'B'});
end

function teardown(testcase)
end

%%
function test_1(testcase)
    actual = permcols(testcase.TestData.table, [2 6 4], [1 5 3]);
    verifyEqual(testcase, actual, testcase.TestData.expected);
end

%%
function test_2(testcase)
    actual = permcols(testcase.TestData.table);
    expected = testcase.TestData.table; % sic!
    verifyEqual(testcase, actual, expected);
end

%%
function test_3(testcase)
    actual = permcols(testcase.TestData.table, [], [2 6 4], [], [1 5 3]);
    verifyEqual(testcase, actual, testcase.TestData.expected);
end
