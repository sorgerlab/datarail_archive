function tests = test_dropcols
    tests = functiontests(localfunctions);
end

function setup(testcase)
    tbl = table({}, {}, {}, {}, 'VariableNames', {'a' 'b' 'c' 'd'});

    testcase.TestData.table = tbl;
    testcase.TestData.dataset = table2dataset(tbl);
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

% ----------------------------------------------------------------------

function test_10(testcase)
    dst = testcase.TestData.dataset;
    actual = dropcols(dst, {'b' 'd'});
    expected = dst(:, {'a' 'c'});
    verifyEqual(testcase, actual, expected);
end

function test_11(testcase)
    dst = testcase.TestData.dataset;
    actual = dropcols(dst, [2 4]);
    expected = dst(:, {'a' 'c'});
    verifyEqual(testcase, actual, expected);
end

function test_12(testcase)
    dst = testcase.TestData.dataset;
    verifyError(testcase, @() dropcols(dst, {'b' 'z'}), ...
                'DR20:UnrecognizedTableVariable');
end

function test_13(testcase)
    dst = testcase.TestData.dataset;
    verifyError(testcase, @() dropcols(dst, [2 26]), ...
                'DR20:badsubscript');
end
