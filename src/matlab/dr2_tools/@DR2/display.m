function display(obj)

if obj.Properties.isTable
    fprintf('\nDR2 object as table with %i x %i entries\n', ...
        height(obj.data), width(obj.data));
end

if obj.Properties.isMDarray
    fprintf('\nDR2 object as array with size (%s)\n', ...
        strjoin(num2cellstr(size(obj.data)), 'x'));
end

fprintf('\tDimensions:')
for i=1:length(obj.Properties.Dimensions)
    fprintf('\n\t %2i: (%s), %i level%s', i, strjoin(varnames(obj.Properties.Dimensions{i}), ', '), ...
        height(obj.Properties.Dimensions{i}), 's'*(height(obj.Properties.Dimensions{i})>1));
end
fprintf('\n\tcomment:\n')
disp(tabbed_comment(obj.comment))
fprintf('\n\n')

end


function c_out = tabbed_comment(c)
EOL_idx = [0 find(c==sprintf('\n'))];
c_out = sprintf('\t  ');
for i=1:length(EOL_idx)-1
    c_out = [c_out c((EOL_idx(i)+1):EOL_idx(i+1)) sprintf('\t  ')];
end
c_out = [c_out c((EOL_idx(length(EOL_idx))+1):end)];

end

