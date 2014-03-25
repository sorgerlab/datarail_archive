function tests = test_table_to_ndarray
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    testCase.TestData.origPath = pwd();
    cd(fullfile(mfiledir(), '..', 'private'));
end

function teardownOnce(testCase)
    cd(testCase.TestData.origPath);
end

function test_happypath(testCase)
    sz = [2 3 4];
    i2s = make_ind2sub(sz);
    n = prod(sz);
    vs = reshape(arrayfun(@(i) contract_(i2s(i)), 1:n), [], 1);
    split = @dr.first;
    join = @(a, b) [b a];
    function vns = lnames(lbls)
        [vlbls, klbls] = split(lbls);
        kvns = cellmap(@(t) t.Properties.VariableNames{1}, klbls);
        vvns = cellstr(vlbls{:, 1}.');
        vns = join(kvns, vvns);
    end

    % collapsed test table
    function do_collapsed_()
        % happy-path case: a factorial table with a single value
        % variable
        tt = make_test_table(sz, false);
        keyvars = tt.Properties.UserData('keyvars');

        [ta, tl] = table_to_ndarray(tt, 'KeyVars', keyvars);
        actual = ta(:);
        verifyEqual(testCase, ta(:), cast(vs, class(actual)));

        valvars = tt.Properties.UserData('valvars');
        varnames = join(keyvars, valvars);
        verifyEqual(testCase, lnames(tl), varnames);
    end

    % expanded test table
    function do_expanded_()
        % happy-path case: a factorial table with value variables
        % that perfectly track the key variables.
        tt = make_test_table(sz, true);
        keyvars = tt.Properties.UserData('keyvars');

        [ta, tl] = table_to_ndarray(tt, 'KeyVars', keyvars);
%         c = num2cell(reshape(ta, [], size(ta, ndims(ta))), 2);
        c = num2cell(dr.unroll(ta, false), 2);
        actual = cellfun(@(a) contract_(a), c);
        verifyEqual(testCase, actual, cast(vs, class(actual)));

        valvars = tt.Properties.UserData('valvars');
        varnames = join(keyvars, valvars);
        verifyEqual(testCase, lnames(tl), varnames);
    end

    do_collapsed_();
    do_expanded_();
end

function test_collapse_1(testCase)
    sz = [2 3 4]; expanded = true;
    T1 = make_test_table(sz, expanded);
    [A1, L1] = table_to_ndarray(T1);
    T2 = vertcat(T1, T1, T1);
    [A2, L2] = table_to_ndarray(T2, 'Aggrs', @(x) sum(x, 'native'));
    verifyEqual(testCase, A2, 3 * A1);
end

function test_collapse_2(testCase)
    for outer = [false true]
        sz = [2 3 4]; expanded = true;
        T1 = make_test_table(sz, expanded);
        [A1, L1] = table_to_ndarray(T1, 'Outer', outer);
        T2 = vertcat(T1, T1, T1);
        [A2, L2] = table_to_ndarray(T2, 'Aggrs', @(x) sum(x, 'native'), ...
                                        'Outer', outer);
        verifyEqual(testCase, A2, 3 * A1);
    end
end
