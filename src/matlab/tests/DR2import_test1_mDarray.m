

m = (ones(10,1)*(0:9)) + (0:10:90)'*ones(1,10);
m = repmat(m,1,1,10) + permute(repmat(0:100:900, 10, 1, 10),[1 3 2]);

keys = {table(num2cell('A':'J')', num2cell('a':'j')', 'variablenames', {'up' 'low'}) ...
    table(strcat('d', num2cellstr(0:9)'),'variablename', {'dval'}) ...
     table((0:9)'/10, 'variablenames', {'val'})};

%%
DR2m = DR2(m, keys);
DR2m.comment = 'original data'

%
sDR2m = DR2m.sub(...
    'low', @(x) ismember(x, {'a' 'b' 'c'}), ...
    'and', 'val', '<.5', ...
    'AND', 'dval', '==''d3''')

