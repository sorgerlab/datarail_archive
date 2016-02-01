addpath(genpath('../../SRC/MATLAB/'))

%%
t_ = tsv2table('../../DR2_fixture_files/GRvalue_example.tsv');
[nd, lbls] = table2ndarray(t_, 'keyvars', [1:3 5 6], 'valvars', 7:9, ...
    'aggrs', @mean, 'outer', 1);

%%

fprintf('\n\n\n\n-----------------------------------------------\nExample:\n\n');

dr2 = DR2(nd, lbls, 'GRvalue example')
pause(3)

% select only the data where concentration=1 and time=72
fprintf('\n-----------------------------------------------');
fprintf('\n-- select only the data where concentration=1 and time=72 --\n');
dr2_1 = dr2.subcond('concentration', '==1', 'and', 'time', '==72');

% print out the data only for 'cell_count'
fprintf('\n-- print out the data only for cell_count --\n');
dr2_1.data(:,:,:,dr2_1.Value=='cell_count')
pause(3)

% select only the cell_count data for concentration<1, time=72 and DrugA
fprintf('\n-----------------------------------------------');
fprintf('\n-- select a small subset of the DR2 object --\n');
dr2_2 = dr2('concentration<1 & time==72 & agent==''drugA'' & Value==''cell_count''')
% reorder the dimensions and normalizing by perturbation==1
dr2_2 = dr2_2.sort_dims;
fprintf('\n-- normalization of the data --\n');
dr2_3 = dr2_2 ./ dr2_2.data(:,:,dr2_2.perturbation==1)

% note that the comments have been updated
fprintf('\n-- comment of the new DR2 object --\n');
disp(dr2_3.comment)
pause(3)

% test equality (should be false, but flag=111 (same dimensions and levels)
fprintf('\n-----------------------------------------------');
fprintf('\n-- test equality (should be false, but flag=111 (same dimensions and levels) --\n');
[equal, flag] = dr2_2.eq(dr2_3)
pause(3)

% perform a manual normalization of data
temp_data = dr2_2.data;
data = temp_data./repmat(temp_data(:,:,2),1, 1, 2);
fprintf('\n-----------------------------------------------');
fprintf('\n-- new object with normalized data (manual step - not recorded) --\n');
dr2_2norm = DR2(data, dr2_2.Properties.Dimensions(1:3), ...
    'normalized version of previous data')

% test equality (should be true)
fprintf('\n-- test equality (should be true) --\n');
disp(dr2_2norm==dr2_3)
