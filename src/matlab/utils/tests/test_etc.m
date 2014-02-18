function tests = test_etc
    tests = functiontests(localfunctions);
end

function setup(testCase)
end
    
function teardown(testCase)
end

%%
function test_cartproduct_ds(testCase)
    sz = [2 3 4];
    nd = numel(sz);
    n = prod(sz);

    exp = [1 1 1; 1 1 2; 1 1 3; 1 1 4; 1 2 1; 1 2 2; 1 2 3; 1 2 4; 1 3 1; ...
           1 3 2; 1 3 3; 1 3 4; 2 1 1; 2 1 2; 2 1 3; 2 1 4; 2 2 1; 2 2 2; ...
           2 2 3; 2 2 4; 2 3 1; 2 3 2; 2 3 3; 2 3 4];
       
    % the expected value above was generated with
    % exp = fliplr(cell2mat(arraymap(make_ind2sub(fliplr(sz)), (1:n)')));

    lvls = arraymap(@(m) 1:m, sz);
    vns = {'Key_A' 'Key_B' 'Key_C'};
    % TODO: make tests more direct (the test below tests only an nd-array
    % derived from the output of the cartproduct_ds function).

    ds = cartproduct_ds(lvls, {'Key_A' 'Key_B' 'Key_C'});
    verifyEqual(testCase, ds.Properties.VarNames, vns);
    c = dataset2cell(ds);
    got = cell2mat(sortrows(c(2:end, :)));
    verifyEqual(testCase, got, exp);
end
