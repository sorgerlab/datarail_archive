function formated_array = cellstr2best(cells)
% formated_cells = cellstr2best(cells);
%
%   convert the cell array in either:
%       - numerical array if numerical values
%       - categorical array if repeated strings
%       - boolean array if values are true/false
%       - cell string array (no change) if otherwise
%

%% test 50 random cells to get a quick idea if this is a numeric array (faster)
test_num = cellfun(@str2double, cells(randperm(numel(cells),min(50,numel(cells)))));

if all(isnan(test_num))
    is_num = false;
else
    is_num = true;
end

%%
if is_num
    % conver the array for a numerical vector
    formated_array = cellfun(@str2double, cells);
    return
    
else
    
    if all(ismember(lower(unique(cells(:))), {'false' 'true'}))
        % test if this is a boolean array
        formated_array = strcmpi(cells, 'true');
        
    elseif length(unique(cells(:))) < .7*numel(cells)
        % test is this can be a categorical array (need repeated values)
        formated_array = categorical(cells);
    else
        % no change: cell array of strings
        formated_array = cells;
    end
end
