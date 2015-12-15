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

% -----------------------------------------------------------------------------

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

    box_0 = reshape(uint8([1 2 3    1 2 3    1 2 3    1 2 3   ...
                           1 2 3    1 2 3    1 2 3    1 2 3   ...
                           1 2 3    1 2 3    1 2 3    1 2 3   ...
                           1 2 3    1 2 3    1 2 3    1 2 3   ...
                           1 2 3    1 2 3    1 2 3    1 2 3]), ...
                    1, 1, h, w, d);

    % the criterion function below should be true iff s is an array uint8s
    % with shape [1 1 1 w d], with uniform content some odd integer u
    function yn = criterion(s)
        xcalled = xcalled + 1;
        u = unique(s);
        yn = isa(s, 'uint8') && numel(u) == 1 && ...
             mod(u, 2) == 1 && isequal(size(s), [1 1 1 w d]);
    end

    box_1 = reshape(uint8([1   3    1   3    1   3    1   3   ...
                           1   3    1   3    1   3    1   3   ...
                           1   3    1   3    1   3    1   3   ...
                           1   3    1   3    1   3    1   3   ...
                           1   3    1   3    1   3    1   3]), ...
                    1, 1, h - 1, w, d);

    expected = box_1;

    xcalled  = 0;
    actual   = select(@criterion, box_0);

    verifyEqual(testCase, xcalled, h);
    verifyEqual(testCase, actual, expected);
end

function test_select_from_1dcell(testCase)
    function yn = criterion(s)
        xcalled = xcalled + 1;
        yn = iscell(s) && numel(s) == 1 && mod(s{1}, 2) == 1;
    end

    arg = {1 2 3};
    xcalled  = 0;
    actual   = select(@criterion, arg);
    expected = {1 3};

    verifyEqual(testCase, xcalled, numel(arg));
    verifyEqual(testCase, actual, expected);
end

function test_select_from_1dcell_1(testCase)
    function yn = criterion(s)
        xcalled = xcalled + 1;
        yn = isnumeric(s) && numel(s) == 1 && mod(s, 2) == 1;
    end

    arg = {1 2 3};
    xcalled  = 0;
    actual   = selectc(@criterion, arg);
    expected = {1 3};

    verifyEqual(testCase, xcalled, numel(arg));
    verifyEqual(testCase, actual, expected);
end

function test_select_from_ndcell(testCase)
    h = 3; w = 4; d = 5;

    box_0 = reshape({1 2 3    1 2 3    1 2 3    1 2 3   ...
                     1 2 3    1 2 3    1 2 3    1 2 3   ...
                     1 2 3    1 2 3    1 2 3    1 2 3   ...
                     1 2 3    1 2 3    1 2 3    1 2 3   ...
                     1 2 3    1 2 3    1 2 3    1 2 3}, ...
                    1, 1, h, w, d);

    % the criterion function below should be true iff s is a cellarray of
    % numbers with shape [1 1 1 w d], with uniform content some odd
    % integer u
    function yn = criterion(s)
        xcalled = xcalled + 1;
        yn = false;
        if ~isequal(size(s), [1 1 1 w d]); return; end
        if ~iscell(s); return; end
        u = unique(cell2mat(s));
        yn = numel(u) == 1 && mod(u, 2) == 1;
    end

    box_1 = reshape({1   3    1   3    1   3    1   3   ...
                     1   3    1   3    1   3    1   3   ...
                     1   3    1   3    1   3    1   3   ...
                     1   3    1   3    1   3    1   3   ...
                     1   3    1   3    1   3    1   3}, ...
                    1, 1, h - 1, w, d);

    expected = box_1;

    xcalled  = 0;
    actual   = select(@criterion, box_0);

    verifyEqual(testCase, xcalled, h);
    verifyEqual(testCase, actual, expected);
end
