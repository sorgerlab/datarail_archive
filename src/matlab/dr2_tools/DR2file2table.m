
function t_out = DR2file2table(filename)
% t_out = DR2file2table(filename)

[header, data] = readtsv_wHeader(filename);

% convert the header names to MATLAB compatible names
header = convert_DR2header_MATLAB(header);

% convert the data in the right format (numeric or categorical)
datacolumn = cell(1,length(header));
for i=1:length(header)
    datacolumn{i} = cellstr2best(data(:,i));
end

t_out = table(datacolumn{:}, 'VariableNames', header);
