new_DR2m

%%

DR2m2 = DR2(permute(m,[1 3 2]), keys([1 3 2]));
DR2m2.comment = 'permuted data';

%%
sDR2m = DR2m2.subcond(...
    'row_low', @(x) ismember(x, {'a' 'b' 'c'}), ...
    'and', 'column', '<5', ...
    'AND', 'plate', '==''P3''');

sDR2m.sort_dims

%%
sDR2m = DR2m2.subcond(...
    'row_low', @(x) ismember(x, {'a' 'b' 'c'}), ...
    'and', 'column', '<3', ...
    'AND', 'plate', '==''P3''');

%%

sDR2m.sort_dims(1)

%%

DR2m.sort_levels('column','descend')==DR2(fliplr(m), {keys{1} flipud(keys{2}) keys{3}})
DR2m.sort_levels(1,'descend')==DR2(flipud(m), {flipud(keys{1}) keys{2} keys{3}})
