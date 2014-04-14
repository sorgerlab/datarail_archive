function tests = test_select
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    testCase.TestData.origPath = pwd();
    cd(fullfile(mfiledir(), '..', 'private'));
end

function teardownOnce(testCase)
    cd(testCase.TestData.origPath);
end

function test_select_from_row_of_doubles(testCase)
    seq = 0:2;
    expected = 1:2;
    actual = select(@(x) x > 0, seq);
    verifyEqual(testCase, actual, expected);
end

function test_select_empty_row_of_doubles(testCase)
    seq = 0:2;
    expected = 1:0;
    actual = select(@(x) x > 2, seq);
    verifyEqual(testCase, actual, expected);
    verifyTrue(testCase, isrow(actual));
end

function test_select_from_col_of_doubles(testCase)
    seq = (0:2).';
    expected = (1:2).';
    actual = select(@(x) x > 0, seq);
    verifyEqual(testCase, actual, expected);
end

function test_select_empty_col_of_doubles(testCase)
    seq = (0:2).';
    expected = (1:0).';
    actual = select(@(x) x > 2, seq);
    verifyEqual(testCase, actual, expected);
    verifyTrue(testCase, iscolumn(actual));
end

function test_select_from_ambiguous_row_of_doubles(testCase)
    seq = 0:0;
    expected = (1:0);
    actual = select(@(x) x > 0, seq, 2);
    verifyEqual(testCase, actual, expected);
    verifyTrue(testCase, isrow(actual));
end

function test_select_from_ambiguous_matrix_of_doubles(testCase)
    seq = reshape(1:9, 3, 3).';
    expected = reshape([1:3 7:9], 3, 2).';
    actual = select(@(x) mod(sum(x), 2) == 0, seq, 1);
    verifyEqual(testCase, actual, expected);
end

function test_select_from_row_of_logicals(testCase)
    seq = [true false true];
    expected = [true true];
    actual = select(@(x) x, seq);
    verifyEqual(testCase, actual, expected);
end

function test_select_empty_row_of_logicals(testCase)
    seq = [false false false];
    expected = logical(zeros(1, 0));
    actual = select(@(x) x, seq);
    verifyEqual(testCase, actual, expected);
    verifyTrue(testCase, isrow(actual));
end

function test_select_from_col_of_logicals(testCase)
    seq = [true; false; true];
    expected = [true; true];
    actual = select(@(x) x, seq);
    verifyEqual(testCase, actual, expected);
end

function test_select_empty_col_of_logicals(testCase)
    seq = [false; false; false];
    expected = logical(zeros(0, 1));
    actual = select(@(x) x, seq);
    verifyEqual(testCase, actual, expected);
    verifyTrue(testCase, iscolumn(actual));
end

function test_select_from_ndarray(testCase)
    h = 3; w = 4; d = 5;

    function box = mkbox_(ix)
        mkslab_ = @(i) i * ones(1, w, d, 'uint8');
        h_ = numel(ix);
        box = reshape(catc(1, arraymap(mkslab_, ix)), 1, 1, h_, w, d);
    end
    criterion = @(s) 1 == mod(max(s(:)), 2);
    seq0 = 1:h;

    expected = mkbox_(select(criterion, seq0));
    actual =   select(criterion, mkbox_(seq0));
    verifyEqual(testCase, actual, expected)
end

function test_select_from_ndcell(testCase)
    h = 3; w = 4; d = 5;

    function box = mkbox_(ix)
        mkslab_ = @(i) i * ones(1, w, d, 'uint8');
        h_ = numel(ix);
        tmp = reshape(catc(1, cellmap(mkslab_, ix)), 1, 1, h_, w, d);
        box = num2cell(tmp);
    end
    criterion = @(s) 1 == mod(max(catc(1, s(:))), 2);
    seq0 = num2cell(1:h);

    expected = mkbox_(select(criterion, seq0));
    actual =   select(criterion, mkbox_(seq0));
    verifyEqual(testCase, actual, expected)
end
