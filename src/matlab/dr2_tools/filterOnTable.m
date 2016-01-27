
function idx = filterOnTable(t_data, Variables, Conditions, Operators)
% operate on the table type of data
% starts from the last condition
idx = true(height(t_data),1);

for i=length(Variables):-1:1
    % evaluate the conditions
    if strcmp(class(Conditions{i}), 'function_handle')
        idx2 = Conditions{i}(t_data.(Variables{i}));
    else
        eval(Conditions{i}(3:end))
        eval(['idx2 = t_data.(Variables{i})' Conditions{i} ';'])
    end
    % applying the conditions
    nIdx = strfind(Operators{i}, 'not');
    if isempty(nIdx)
        eval(['idx = ' Operators{i} '(idx, idx2);'])
    else
        eval(['idx = ' Operators{i}(1:nIdx-1) '(idx, not(idx2));'])
    end
    
end
