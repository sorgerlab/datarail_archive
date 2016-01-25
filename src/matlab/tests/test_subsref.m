new_DR2m


%%
sDR2m = DR2m.subcond(...
    'row_low', @(x) ismember(x, {'a' 'b' 'c'}), ...
    'and', 'column', '<5', ...
    'AND', 'plate', '==''P3''')

%%
% s2DR2m = DR2m('x.column<5 & ismember(x.row_low, {''a'' ''b'' ''c''}) & x.plate==''P3''')
disp('--')
s2DR2m = DR2m('column<6 & ismember(row_low, {''a'' ''b'' ''c''}) & plate==''P3''')


%%
%s2DR2m = DR2m(column<5 & ismember(row_low, {'a' 'b' 'c'}) & dval=='d3')
%s2DR2m = DR2m(DR2m.column<5, ismember(DR2m.row_low, {'a' 'b' 'c'}), DR2m.plate=='P3')

sDR2m == s2DR2m
