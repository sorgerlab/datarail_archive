function tests = test_make_test_table
    tests = functiontests(localfunctions);
end

function setup(testCase)
    testCase.TestData.HappyPath = [2 3 4];
end
    
function teardown(testCase)
    testCase.TestData.HappyPath = [];
%     testCase.TestData.SingleDim = 4;
%     testCase.TestData.TrivialDims = [2 1 3 1 4];
%     testCase.TestData.TrivialLeadingDims = [1 1 2 3 4];
%     testCase.TestData.TrivialTrailingDims = [2 3 4 1 1];
%     testCase.TestData.SingleDim1 = [1 1 4];
%     testCase.TestData.SingleDim2 = [4 1 1];
%     testCase.TestData.Empty = [];
end

%%
function test_happypath_expanded(testCase)
    sz = testCase.TestData.HappyPath;
    expanded = true;
    verifyTrue(testCase, make_test_table_tester_(sz, expanded));
end

function test_happypath_collapsed(testCase)
    sz = testCase.TestData.HappyPath;
    expanded = false;
    verifyTrue(testCase, make_test_table_tester_(sz, expanded));
end

%%
% function test_single_dim_expanded(testCase)
%     sz = testCase.TestData.SingleDim;
%     expanded = true;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% function test_single_dim_collapsed(testCase)
%     sz = testCase.TestData.SingleDim;
%     expanded = false;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% %%
% function test_single_dim_1_expanded(testCase)
%     sz = testCase.TestData.SingleDim1;
%     expanded = true;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% function test_single_dim_1_collapsed(testCase)
%     sz = testCase.TestData.SingleDim1;
%     expanded = false;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% %%
% function test_single_dim_2_expanded(testCase)
%     sz = testCase.TestData.SingleDim2;
%     expanded = true;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% function test_single_dim_2_collapsed(testCase)
%     sz = testCase.TestData.SingleDim2;
%     expanded = false;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% %%
% function test_trivial_dims_expanded(testCase)
%     sz = testCase.TestData.TrivialDims;
%     expanded = true;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% function test_trivial_dims_collapsed(testCase)
%     sz = testCase.TestData.TrivialDims;
%     expanded = false;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% %%
% function test_trivial_leading_dims_expanded(testCase)
%     sz = testCase.TestData.TrivialLeadingDims;
%     expanded = true;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% function test_trivial_leading_dims_collapsed(testCase)
%     sz = testCase.TestData.TrivialLeadingDims;
%     expanded = false;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% %%
% function test_trivial_trailing_dims_expanded(testCase)
%     sz = testCase.TestData.TrivialTrailingDims;
%     expanded = true;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% function test_trivial_trailing_dims_collapsed(testCase)
%     sz = testCase.TestData.TrivialTrailingDims;
%     expanded = false;
%     verifyTrue(testCase, make_test_table_tester_(sz, expanded));
% end
% 
% %%
% function test_empty_expanded(testCase)
%     sz = testCase.TestData.Empty;
%     expanded = true;
%     verifyTrue(testCase, empty_tester_(sz, expanded));
% end
% 
% function test_empty_collapsed(testCase)
%     sz = testCase.TestData.Empty;
%     expanded = false;
%     verifyTrue(testCase, empty_tester_(sz, expanded));
% end
% 
% %%

function ok = make_test_table_tester_(sz, expanded)
    nd = numel(sz);
    assert(nd > 0);
    n = prod(sz);

    tt = make_test_table(sz, expanded);
    kvars = getkeyvars_(tt);
    vvars = getvalvars_(tt, expanded);
    kt = varfun(@double, tt(:, kvars));
    kt.Properties.VariableNames = kvars;
    vt = tt(:, vvars);
    if ~expanded
        vt = cell2mat(cellmap(@expand, table2cell(vt)));
        vt = arraymap(@(i) vt(:, i), 1:nd);
        vt = table(vt{:}, 'VariableNames', kvars);
        vvars = kvars;
    end
    jt = innerjoin(kt, vt, 'LeftKeys', kvars, 'RightKeys', vvars);
    ok = all(cell2mat(cellmap(@(t) height(t) == n, {kt, vt, jt})));
    return;
end

% function ok = empty_tester_(sz, expanded)
%     got = make_test_table(sz, expanded);
%     if expanded
%         exp = [];
%     else
%         exp = 0;
%     end
%     ok = isequal(got, exp);
% end

function kvs = getkeyvars_(tbl)
    vn = tbl.Properties.VariableNames;
    kvs = vn(:, cellfun(@(s) strncmp(s, 'Key_', 4), vn));
end

function vvs = getvalvars_(tbl, expanded)
    if expanded
        vn = tbl.Properties.VariableNames;
        vvs = vn(:, cellfun(@(s) strncmp(s, 'value_', 6), vn));
    else
        vvs = {'value'};
    end
end

function out = expand(n)
    out = arrayfun(@str2num, int2str(n));
end
