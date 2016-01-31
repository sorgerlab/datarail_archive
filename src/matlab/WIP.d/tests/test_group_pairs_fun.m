function tests = test_group_pairs_fun()
    tests = functiontests(localfunctions);
end

%%
function setupOnce(testCase)
end

function teardownOnce(testCase)
end

% %%
% function setupOnce(testCase)
%     testCase.TestData.origPath = pwd();
%     cd(fullfile(mfiledir(), '..', 'private'));
% end

% function teardownOnce(testCase)
%     cd(testCase.TestData.origPath);
% end

%%
function test_1(testcase)
    key = 'key';
    tbl = table(cellstr('abbcccdddd'.'), 'VariableNames', {key});
    function out = process_group_pair(a, b)
        out = strjoin(cellstr(cat(1, unique(a.(key)), ...
                                     unique(b.(key)))).', '');
    end
    expected = cellstr(['aaaabbbbccccdddd'; 'abcdabcdabcdabcd'].');
    actual = group_pairs_fun(@process_group_pair, tbl, key);
    verifyEqual(testcase, actual, expected);
end


