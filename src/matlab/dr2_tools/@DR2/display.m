function display(obj)

fprintf('\nDR2 object with %i x %i entries\n\n', height(obj.t_data), width(obj.t_data));

fprintf('\tDimensions:')
for i=1:length(obj.DimNames)
    fprintf('\n\t %2i: (%s)', i, strjoin(obj.DimNames{i}, ', '));
end
fprintf('\n\n')
disp(peek(obj.t_data,8))
