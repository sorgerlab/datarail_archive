function idx = filterOnLevels(Dimensions, Variables, Conditions, Operators)
% operate on the levels to select indices of the matrix
% starts from the last condition

for i=1:length(Dimensions)
    idx{i} = true(height(Dimensions{i}),1);
end

for i=length(Variables):-1:1
    % find the right dimension
    dimIdx = [];
    for j = 1:length(Dimensions)
        if ismember(Variables{i}, varnames(Dimensions{j}))
            dimIdx = [dimIdx j];
        end
    end
    assert(length(dimIdx)==1) %%%% needs better error reporting MH 15/12/17
    
    % evaluate the conditions
    idx2 = [];
    if isa(Conditions{i}, 'function_handle')
        idx2 = Conditions{i}(Dimensions{dimIdx}.(Variables{i}));
    else
        cmd = sprintf('idx2 = Dimensions{%i}.%s%s;', ...
            dimIdx, Variables{i}, Conditions{i});
        try
            eval(cmd)
        catch
            error('Filtering with condition: "%s" failed', cmd)
        end
    end
    % applying the conditions
    nIdx = strfind(Operators{i}, 'not');
    if isempty(nIdx)
        eval(['idx{dimIdx} = ' Operators{i} '(idx{dimIdx}, idx2);'])
    else
        eval(['idx{dimIdx} = ' Operators{i}(1:nIdx-1) '(idx{dimIdx}, not(idx2));'])
    end
    
end
