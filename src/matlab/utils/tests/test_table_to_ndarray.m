function tests = test_table_to_ndarray
    tests = functiontests(localfunctions);
end

% function setup(testCase)
%     testCase.TestData.HappyPath = [2 3 4];
% end
    
% function teardown(testCase)
%     testCase.TestData.Table = [];
% end

function test_happypath(testCase)
    sz = [2 3 4];
    i2s = make_ind2sub(sz);
    n = prod(sz);
    vs = reshape(arrayfun(@(i) collapse(i2s(i)), 1:n), [], 1);
    function vns = lnames(lbls)
        kvns = cellmap(@(t) t.Properties.VariableNames{1}, ...
                       lbls(1:end-1));
        vvns = lbls{end}{:, 1}.';
        vns = [kvns vvns];
    end

    % collapsed test table
    function do_collapsed_()
        % happy-path case: a factorial table with a single value
        % variable
        tt = make_test_table(sz, false);
        keyvars = tt.Properties.UserData('keyvars');

        [ta, tl] = table_to_ndarray(tt, keyvars);
        verifyEqual(testCase, ta(:), vs);

        valvars = tt.Properties.UserData('valvars');
        varnames = [keyvars valvars];
        verifyEqual(testCase, lnames(tl), varnames);
    end

    % expanded test table
    function do_expanded_()
        % happy-path case: a factorial table with value variables
        % that perfectly track the key variables.
        tt = make_test_table(sz, true);
        keyvars = tt.Properties.UserData('keyvars');

        [ta, tl] = table_to_ndarray(tt, keyvars);
        c = num2cell(reshape(ta, [], size(ta, ndims(ta))), 2);
        verifyEqual(testCase, cellfun(@(a) collapse(a), c), vs);

        valvars = tt.Properties.UserData('valvars');
        varnames = [keyvars valvars];
        verifyEqual(testCase, lnames(tl), varnames);
    end

    do_collapsed_();
    do_expanded_();
end

% function out = expand(n)
%     out = arrayfun(@str2double, int2str(n));
% end

function out = collapse(idx)
    out = str2double(arrayfun(@int2str, idx));
end
