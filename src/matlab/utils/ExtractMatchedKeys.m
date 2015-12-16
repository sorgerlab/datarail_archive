function [keySets, levels] = ExtractMatchedKeys(t_data, keys)
% [keySets, levels] = ExtractMatchedKeys(t_data, keys)

keySets = cell(1,0);
levels = keySets;
dataVars = varnames(t_data);
assert(all(ismember(keys, dataVars)), ['%s are not variables of input table' ...
    '; variables are: \n\t%s'], ...
    strjoin(keys(~ismember(keys, dataVars)),', '), ...
    strjoin(dataVars, '\n\t'))
for i=1:length(keys)
    % check that the key has not been already collapsed
    if ismember(keys{i}, [keySets{:}]), continue, end
    
    % find column index
    idx = find(strcmp(dataVars, keys{i}));
    nLevels = length(unique(t_data.(idx)));
    assert(nLevels<height(t_data), 'key %s span the whole table', keys{i})
    
    % find potential matched keys
    for j = setdiff(1:length(dataVars),idx)
        if height(unique(t_data(:,[idx j])))==nLevels && ...
                length(unique(t_data.(j)))==nLevels
            idx = [idx j];
        end
    end
    
    % assign the keys
    keySets{end+1} = dataVars(idx);
    levels{end+1} = unique(t_data(:,idx));
    
end

