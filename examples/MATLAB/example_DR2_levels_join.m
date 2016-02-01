addpath(genpath('../../SRC/MATLAB/'))

%%
t_ = tsv2table('../../DR2_fixture_files/GRvalue_example.tsv');
[nd, lbls] = table2ndarray(t_, 'keyvars', [1:3 5 6], 'valvars', 7:9, ...
    'aggrs', @mean, 'outer', 1);

%%

fprintf('\n\n\n\n-----------------------------------------------\nExample:\n\n');

dr2 = DR2(nd, lbls, 'GRvalue example')
fprintf('\n-- the first dimensions of the DR2 object --\n');
disp(dr2.Properties.Dimensions{1})
fprintf('\n-- all dimensions of the DR2 object --\n');
disp(dr2.lvls)
pause(3)

%%
% joining two dimension
fprintf('\n-----------------------------------------------');
fprintf('\n-- joining the DR2 object with the following table --\n');
t_subtype = table({'BT20';'MCF10A';'MCF7'},{'TNBC';'NM';'HR+'}, 'VariableNames', ...
    {'cell_line', 'subtype'})
dr2_1 = dr2.leftjoin(t_subtype)
%
% print out the first dimension
fprintf('\n-- the first dimensions of the DR2 object --\n');
disp(dr2_1.Properties.Dimensions{1})
pause(3)

%%
% select only the subtype data 
fprintf('\n-----------------------------------------------');
fprintf('\n-- select by subtype --\n');
dr2_2 = dr2_1('subtype==''TNBC'' & Value==''cell_count''')
pause(3)

%%

% select based on joined dimension
fprintf('\n-----------------------------------------------');
fprintf('\n-- select from the DR2 object with the following table (inner join) --\n');
t_potency = table({'drugA';'drugB';'drugC';'drugD'},[1;1;0;0], 'VariableNames', ...
    {'agent', 'potency'})
fprintf('-- pick only when potency=1 --\n');
dr2_3 = dr2_1.innerjoin(t_potency(t_potency.potency==1,:))
%
% print out the first dimension
fprintf('\n-- the second dimensions of the DR2 object --\n');
disp(dr2_3.Properties.Dimensions{2})


