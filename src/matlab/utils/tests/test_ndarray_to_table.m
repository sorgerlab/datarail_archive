function tests = test_ndarray_to_table
    tests = functiontests(localfunctions);
end

function test_0100(testCase)
    sz = [3 4]; expanded = false;
    T = make_test_table(sz, expanded);
    [A, L] = table_to_ndarray(T);
    verifyEqual(testCase, ndarray_to_table(A, L), T);
end

function test_0200(testCase)
    sz = [3 4]; expanded = true;
    T = make_test_table(sz, expanded);
    [A, L] = table_to_ndarray(T);
    verifyEqual(testCase, ndarray_to_table(A, L), T);
end

function test_0300(testCase)
    sz = [2 3 4]; expanded = false;
    T = make_test_table(sz, expanded);
    [A, L] = table_to_ndarray(T);
    verifyEqual(testCase, ndarray_to_table(A, L), T);
end

function test_0400(testCase)
    sz = [2 3 4]; expanded = true;
    T = make_test_table(sz, expanded);
    [A, L] = table_to_ndarray(T);
    verifyEqual(testCase, ndarray_to_table(A, L), T);
end

function test_0500(testCase)
    for outer = [false true]
        sz = [3 4]; expanded = false;
        T = make_test_table(sz, expanded);
        [A, L] = table_to_ndarray(T, 'Outer', outer);
        verifyEqual(testCase, ndarray_to_table(A, L, outer), T);
    end
end

function test_0600(testCase)
    for outer = [false true]
        sz = [3 4]; expanded = true;
        T = make_test_table(sz, expanded);
        [A, L] = table_to_ndarray(T, 'Outer', outer);
        verifyEqual(testCase, ndarray_to_table(A, L, outer), T);
    end
end

function test_0700(testCase)
    for outer = [false true]
        sz = [2 3 4]; expanded = false;
        T = make_test_table(sz, expanded);
        [A, L] = table_to_ndarray(T, 'Outer', outer);
        verifyEqual(testCase, ndarray_to_table(A, L, outer), T);
    end
end

function test_0800(testCase)
    for outer = [false true]
        sz = [2 3 4]; expanded = true;
        T = make_test_table(sz, expanded);
        [A, L] = table_to_ndarray(T, 'Outer', outer);
        verifyEqual(testCase, ndarray_to_table(A, L, outer), T);
    end
end

function test_0900(testcase)
    function L = update_(L)
        ith = @(i) L{i}.Properties.VariableNames{1};
        idx = select(@(i) isequal(ith(i), 'B'), 1:numel(L));
        L{idx}.D = categorical(1 + double(L{idx}.B));
    end

    for outer = [true false]
        for expanded = [true false]
            T = make_test_table([2 3 4], expanded);
            [A, L] = table_to_ndarray(T, 'Outer', outer);

            L = update_(L);

            ud = T.Properties.UserData;
            kvs = ud('keyvars');
            vvs = ud('valvars');

            expected = T;
            kvs = [kvs(1, 1:2) 'D' kvs(3:end)];
            expected.D = categorical(1 + double(expected.B));
            expected = expected(:, [kvs vvs]);
            expected.Properties.UserData('keyvars') = kvs;
            actual = ndarray_to_table(A, L, outer);

            verifyEqual(testcase, actual, expected);
        end
    end
end
