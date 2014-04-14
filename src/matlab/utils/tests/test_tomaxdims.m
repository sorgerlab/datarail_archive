function tests = test_select
    tests = functiontests(localfunctions);
end

function setupOnce(testCase)
    testCase.TestData.origPath = pwd();
    cd(fullfile(mfiledir(), '..', 'private'));
end

function teardownOnce(testCase)
    cd(testCase.TestData.origPath);
end


%%
function test_1(testCase)
    iis = {1:1, 2:3, 4:6};
    jjs = {1:2, 3:5, 6:9};
    kks = {1:2, 3:5, 6:6};

    sh = cellfun(@(c) max(cell2mat(c(end))), {iis, jjs, kks});
    expected = num2cell(reshape(1:prod(sh), sh));
    cellarray = cell(numel(iis), numel(jjs), numel(kks));
    for i = 1:numel(iis)
        Si = hslice(expected, 1, iis{i});
        for j = 1:numel(jjs)
            Sj = hslice(Si, 2, jjs{j});
            for k = 1:numel(kks)
                cellarray{i, j, k} = hslice(Sj, 3, kks{k});
            end
        end
    end

    verifyEqual(testCase, tomaxdims(cellarray), expected);
end

function test_2(testCase)
    iis = {1:1, 2:3, 4:6};
    jjs = {1:2, 3:5, 6:9};
    kks = {1:2, 3:5, 6:6};

    sh = cellfun(@(c) max(cell2mat(c(end))), {iis, jjs, kks});
    expected = num2cell(reshape(1:prod(sh), sh));
    cellarray = cell(numel(iis), 1);
    for i = 1:numel(iis)
        Ci = cell(numel(jjs), 1);
        Si = hslice(expected, 1, iis{i});
        for j = 1:numel(jjs)
            Cij = cell(numel(kks), 1);
            Sj = hslice(Si, 2, jjs{j});
            for k = 1:numel(kks)
                Cij{k} = hslice(Sj, 3, kks{k});
            end
            Ci{j} = Cij;
        end
        cellarray{i} = Ci;
    end

    verifyEqual(testCase, tomaxdims(cellarray), expected);
end

%%
function SKIP__test_single_ndcell(testCase)
    sz = [3 4];
    ca = num2cell(zeros(sz), 1:numel(sz));
    expected = num2cell(zeros(sz));
    actual = tomaxdims(ca);
    verifyEqual(testCase, actual, expected);
end
