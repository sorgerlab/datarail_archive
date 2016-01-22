function sub_obj = filterDR2(obj, DimNames, Conditions, Operators)



if obj.Properties.isTable
    % operate on the table
    idx = filterOnTable(obj.data, DimNames, Conditions, Operators);
    sub_obj = constructTwoArgument_(obj, obj.data(idx,:), [obj.DimNames{:}]);
    
elseif obj.Properties.isMDarray
    % operate on the matrix
    idx = filterOnLevels(obj, DimNames, Conditions, Operators);
    newMD = obj.data(idx{:});
    newDimensions = cellfun_(@(x,y) x(y,:), obj.Properties.Dimensions, idx);
    sub_obj = constructTwoArgument_(obj, newMD, newDimensions);
end
