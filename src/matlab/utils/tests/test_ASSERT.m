function tests = test_ASSERT
    tests = functiontests(localfunctions);
end

% ------------------------------------------------------------------------------

function setup(testcase)
    path_to_dev = fileparts(which('ASSERT'));
    testcase.TestData.path_to_prod = fullfile(path_to_dev, '..', 'prod');
end

function teardown(testcase)
    warning('off','MATLAB:rmpath:DirNotFound')
    rmpath(testcase.TestData.path_to_prod);
    warning('on','MATLAB:rmpath:DirNotFound')
end

% ------------------------------------------------------------------------------

function test_00(testcase)
    verifyTrue(testcase, identity_(true));
    verifyError(testcase, @() identity_(false), 'MATLAB:assertion:failed');
end

function test_01(testcase)
    addpath(testcase.TestData.path_to_prod);
    verifyTrue(testcase, identity_(true));
    verifyFalse(testcase, identity_(false));
end

% ------------------------------------------------------------------------------

function out = identity_(in)
    ASSERT(@() in);
    out = in;
end
