function tests = test_length_
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    testCase.TestData.origPath = pwd();
    cd(fullfile(mfiledir(), '..', 'private'));
end

function teardownOnce(testCase)
    cd(testCase.TestData.origPath);
end

function test_length__row_of_doubles(testCase)
    seq = 0:2;
    expected = [3, 2];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__col_of_doubles(testCase)
    seq = (0:2).';
    expected = [3, 1];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__empty_seq(testCase)
    seq = [];
    expected = [0, 1];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__empty_seq_1(testCase)
    seq = zeros(0, 1);
    expected = [0, 1];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__empty_seq_2(testCase)
    seq = zeros(1, 0);
    expected = [0, 2];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__ndarray_of_doubles(testCase)
    seq = reshape(1:120, 1:5);
    expected = [2, 2];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__ndarray_of_doubles_1(testCase)
    seq = reshape(1:120, 1:5);
    expected = [3, 3];
    [n, d] = length_(seq, 3);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__ndarray_of_doubles_2(testCase)
    seq = reshape(1:120, [1 1 5:-1:2]);
    expected = [5, 3];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__singleton(testCase)
    seq = 0;
    expected = [1, 1];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end


function test_length__table(testCase)
    seq = table((0:2).');
    expected = [3, 1];
    [n, d] = length_(seq);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
end

function test_length__table_explicit_dim(testCase)
    seq = table((0:2).');
    expected = [3, 1];
    [n, d] = length_(seq, 1);
    actual = [n, d];
    verifyEqual(testCase, actual, expected);
    verifyError(testCase, @() length_(seq, 2), ...
                'DR20:length_:InvalidLengthDimensionForTable');
end
