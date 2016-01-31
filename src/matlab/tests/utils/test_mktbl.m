function tests = test_mktbl
    tests = functiontests(localfunctions);
end

%%
function setupOnce(testcase)
end

function teardownOnce(testcase)
end

function setup(testcase)
end

function teardown(testcase)
end

%%
function test_1(testcase)
    rows = {{'a', 1, 1==1}; ...
            {'b', 2, 1==0}; ...
            {'c', 3, 1==1}; ...
            {'d', 4, 1==0}};
    varnames = {'X', 'Y', 'Z'};

    actual = mktbl(rows, varnames);
    expected = table({'a'; 'b'; 'c'; 'd'}, ...
                     [1; 2; 3; 4], ...
                     [1==1; 1==0; 1==1; 1==0], ...
                     'VariableNames', varnames);

    verifyEqual(testcase, actual, expected);
end

%%
function test_2(testcase)
    rows = {{'a', 1, 1==1}; ...
            {'b', uint8(2), 1==0}; ...
            {'c', 3, 1==1}; ...
            {'d', uint8(4), 1==0}};
    varnames = {'X', 'Y', 'Z'};

    actual = mktbl(rows, varnames);
    expected = table({'a'; 'b'; 'c'; 'd'}, ...
                     {1; uint8(2); 3; uint8(4)}, ...
                     [1==1; 1==0; 1==1; 1==0], ...
                     'VariableNames', varnames);

    verifyEqual(testcase, actual, expected);
end


%%
function test_3(testcase)
    rows = {{'a'} {'b'} {'c'} {'d'}};
    varnames = {'X'};
    verifyError(testcase, ...
                @() mktbl(rows, varnames), ...
                'DR20:failed_assertion');
end


%%
function test_4(testcase)
    rows = {{'a', 1, 1==1}; ...
            {'b', uint8(2)}; ...
            {'c', 3, 1==1}; ...
            {'d', uint8(4), 1==0}};
    varnames = {'X', 'Y', 'Z'};
    verifyError(testcase, ...
                @() mktbl(rows, varnames), ...
                'DR20:failed_assertion');
end


%%
function test_5(testcase)
    rows = {{'a'; 1; 1==1}; ...
            {'b'; uint8(2); 1==0}; ...
            {'c'; 3; 1==1}; ...
            {'d'; uint8(4); 1==0}};
    varnames = {'X', 'Y', 'Z'};
    verifyError(testcase, ...
                @() mktbl(rows, varnames), ...
                'DR20:failed_assertion');
end


%%
function test_6(testcase)
    rows = {{'a', 1, 1==1}; ...
            {'b', uint8(2), 1==0}; ...
            {'c', 3, 1==1}; ...
            {'d', uint8(4), 1==0}};
    varnames = {'X', 'Y'};
    verifyError(testcase, ...
                @() mktbl(rows, varnames), ...
                'DR20:failed_assertion');
end

