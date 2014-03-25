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
