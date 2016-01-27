function sub_obj = filterDR2(obj, DimNames, Conditions, Operators)



if obj.Properties.isTable
    % operate on the table
    idx = obj.filterOnTable(obj.data, DimNames, Conditions, Operators);
    sub_obj = constructTwoArgument_(obj, obj.data(idx,:), [obj.DimNames{:}]);
    
elseif obj.Properties.isMDarray
    % operate on the matrix
    idx = obj.filterOnLevels(DimNames, Conditions, Operators);
    sub_obj = obj.filterDR2matrix(idx);
end
