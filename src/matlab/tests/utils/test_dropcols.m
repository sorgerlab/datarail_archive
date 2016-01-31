function tests = test_dropcols
    tests = functiontests(localfunctions);
end

function setup(testcase)
    tbl = table({}, {}, {}, {}, 'VariableNames', {'a' 'b' 'c' 'd'});

    testcase.TestData.table = tbl;
end

function test_00(testcase)
    tbl = testcase.TestData.table;
    actual = dropcols(tbl, {'b' 'd'});
    expected = tbl(:, {'a' 'c'});
    verifyEqual(testcase, actual, expected);
end

function test_01(testcase)
    tbl = testcase.TestData.table;
    actual = dropcols(tbl, [2 4]);
    expected = tbl(:, {'a' 'c'});
    verifyEqual(testcase, actual, expected);
end

function test_02(testcase)
    tbl = testcase.TestData.table;
    verifyError(testcase, @() dropcols(tbl, {'b' 'z'}), ...
                'DR20:UnrecognizedTableVariable');
end

function test_03(testcase)
    tbl = testcase.TestData.table;
    verifyError(testcase, @() dropcols(tbl, [2 26]), ...
                'DR20:badsubscript');
end


