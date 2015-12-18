function display(obj)

if obj.updatedTable
    fprintf('\nDR2 object as table with %i x %i entries\n\n', ...
        height(obj.t_data), width(obj.t_data));
end

if obj.updatedMDarray
    fprintf('\nDR2 object as array with size (%s)\n\n', ...
        strjoin(num2cellstr(size(obj.m_data)), 'x'));
end

fprintf('\tDimensions:')
for i=1:length(obj.Dimensions)    
    fprintf('\n\t %2i: (%s), %i level%s', i, strjoin(varnames(obj.Dimensions{i}), ', '), ...
        height(obj.Dimensions{i}), 's'*(height(obj.Dimensions{i})>1));
end
fprintf('\n\n')
disp(peek(obj.t_data,8))
