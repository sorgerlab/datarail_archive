clear all
clear classes

m = (ones(8,1)*(0:9)) + (0:10:70)'*ones(1,10);
m = repmat(m,1,1,9) + permute(repmat(0:100:800, 8, 1, 10),[1 3 2]);

keys = {table(num2cell('A':'H')', num2cell('a':'h')', 'variablenames', {'row_up' 'row_low'}) ...
    table((0:9)', 'variablenames', {'column'}) ...
    table(strcat('P', num2cellstr(0:8)'),'variablename', {'plate'})
    };


DR2m = DR2(m, keys);
DR2m.comment = 'original data'

disp(' - - - - - - - - - ')
