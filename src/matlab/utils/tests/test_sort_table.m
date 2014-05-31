function tests = test_sort_table
    tests = functiontests(localfunctions);
end

function setupOnce(testcase)
end

function teardownOnce(testcase)
end

%%
function test_1(testcase)
    tbl = table(arraymap(@(c) {c}, 'aab'.'), [3 1 2].');
    expected = table(num2cell('aab'.'), [1 3 2].');
    actual = sort_table(tbl);
    verifyEqual(testcase, actual, expected);
end

%%
function test_2(testcase)
    tbl = table(arraymap(@(c) {c}, 'aab'.'), [3 1 2].');
    expected = table(num2cell('aba'.'), [1 2 3].');
    actual = sort_table(tbl, 2);
    verifyEqual(testcase, actual, expected);
end

%%
function test_3(testcase)
    tbl = table(arraymap(@(c) {c}, 'aab'.'), [3 1 2].');
    expected = {table(arraymap(@(c) {c}, 'aab'.'), [1 3 2].'), [2 1 3].'};
    actual = cell(1, 2);
    [actual{:}] = sort_table(tbl);
    verifyEqual(testcase, actual, expected);
end

%%
function test_4(testcase)
    tbl = table(arraymap(@(c) {c}, 'aab'.'), [3 1 2].');
    expected = {table(arraymap(@(c) {c}, 'aba'.'), [1 2 3].'), [2 3 1].'};
    actual = cell(1, 2);
    [actual{:}] = sort_table(tbl, 2);
    verifyEqual(testcase, actual, expected);
end

%%
function test_5(testcase)
    tbl = table(arraymap(@(c) {c}, 'aab'.'), [3 1 2].');
    expected = {table(num2cell('aab'.'), [1 3 2].'), [2 1 3].'};
    actual = cell(1, 2);
    [actual{:}] = sort_table(tbl, [], 'convert');
    verifyEqual(testcase, actual, expected);
    [actual{:}] = sort_table(tbl, {}, 'convert');
    verifyEqual(testcase, actual, expected);
    [actual{:}] = sort_table(tbl, '', 'convert');
    verifyEqual(testcase, actual, expected);
end

%%
function test_6(testcase)
    tbl = table(arraymap(@(c) {c}, 'aab'.'), [3 1 2].');
    expected = {table(num2cell('aba'.'), [1 2 3].'), [2 3 1].'};
    actual = cell(1, 2);
    [actual{:}] = sort_table(tbl, 2, 'convert');
    verifyEqual(testcase, actual, expected);
end

%%
function test_7(testcase)
    tbl = table();
    expected_id = 'DR20:sort_table:badargs';

    verifyError(testcase, @() sort_table(tbl, []), expected_id);
    verifyError(testcase, @() sort_table(tbl, {}), expected_id);
    verifyError(testcase, @() sort_table(tbl, ''), expected_id);

    verifyError(testcase, @() sort_table(tbl, [], 'notconvert'), expected_id);
    verifyError(testcase, @() sort_table(tbl, [], 'CONVERT'   ), expected_id);
    verifyError(testcase, @() sort_table(tbl, [], 'conv'      ), expected_id);
end

%%
function test_8(testcase)
    tbl = table(arraymap(@(c) {c}, 'aab'.'), [3 1 2].');
    expected = table(num2cell('aab'.'), [1 3 2].');
    expected_wid = 'DR20:sort_table:redundant_args';
    actual = verifyWarning(testcase, ...
                           @() sort_table(tbl, [], 'convert'), ...
                           expected_wid);
    verifyEqual(testcase, actual, expected);
end

%%
function test_9(testcase)
    tbl = table(arraymap(@(c) {c}, 'aab'.'), [3 1 2].');
    expected = table(num2cell('aba'.'), [1 2 3].');
    expected_wid = 'DR20:sort_table:redundant_args';
    actual = verifyWarning(testcase, ...
                           @() sort_table(tbl, 2, 'convert'), ...
                           expected_wid);
    verifyEqual(testcase, actual, expected);
end

%%
function test_10(testcase)
    verifyError(testcase, @() sort_table(), ...
                'MATLAB:narginchk:notEnoughInputs');
    verifyError(testcase, @() sort_table(table(), [], 'convert', []), ...
                'MATLAB:narginchk:tooManyInputs');
    function [] = too_many_outputs()
        [~, ~, ~] = sort_table(table());
    end
    verifyError(testcase, @too_many_outputs, ...
                'MATLAB:nargoutchk:tooManyOutputs');
end
