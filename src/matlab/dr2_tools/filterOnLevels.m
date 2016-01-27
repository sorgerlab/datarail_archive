function idx = filterOnLevels(dr2, DimNames, Conditions, Operators)
% operate on the levels to select indices of the matrix
% starts from the last condition

idx = cellfun_(@(x) true(height(x),1), dr2.Properties.Dimensions);


for i=length(DimNames):-1:1
    % find the right dimension
    [dimVals, dimIdx] = dr2.get_dimLevels(DimNames{i});
    assert(length(dimIdx)==1) %%%% needs better error reporting MH 15/12/17
    
    % evaluate the conditions
    idx2 = [];
    if isa(Conditions{i}, 'function_handle')
        idx2 = Conditions{i}(dimVals);
    elseif islogical(Conditions{i})
        if length(Conditions{i})~=length(dimVals);
            ME = sprintf('Logical vector not matching dimension %s', DimNames{i});
            throw(ME);
        end
        idx2 = Conditions{i};
    else
        cmd = sprintf('idx2 = dimVals%s;', Conditions{i});
        try
            eval(cmd)
        catch ME
            error('Filtering with condition: "%s" failed:\n\t%s', cmd, ME.message)
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
