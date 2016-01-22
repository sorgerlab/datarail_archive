clear classes

m = (ones(8,1)*(0:9)) + (0:10:70)'*ones(1,10);
m = repmat(m,1,1,9) + permute(repmat(0:100:800, 8, 1, 10),[1 3 2]);

keys = {table(num2cell('A':'H')', num2cell('a':'h')', 'variablenames', {'row_up' 'row_low'}) ...
    table((0:9)', 'variablenames', {'column'}) ...
    table(strcat('P', num2cellstr(0:8)'),'variablename', {'plate'})
    };

%
DR2m = DR2(m, keys);
DR2m.comment = 'original data'

%%
sDR2m = DR2m.subcond(...
    'row_low', @(x) ismember(x, {'a' 'b' 'c'}), ...
    'and', 'column', '<5', ...
    'AND', 'plate', '==''P3''')

%%
% s2DR2m = DR2m('x.column<5 & ismember(x.row_low, {''a'' ''b'' ''c''}) & x.plate==''P3''')
disp('--')
s2DR2m = DR2m('column<5 & ismember(row_low, {''a'' ''b'' ''c''}) & plate==''P3''')


%%
%s2DR2m = DR2m(column<5 & ismember(row_low, {'a' 'b' 'c'}) & dval=='d3')
%s2DR2m = DR2m(DR2m.column<5, ismember(DR2m.row_low, {'a' 'b' 'c'}), DR2m.plate=='P3')

sDR2m == s2DR2m
