function dr2_out = sort_levels(obj, dim, mode)
% dr2_out = sort_levels(obj, dim, mode)
%   sort the dimension dim (based on idx or name) based on MATLAB 'sort'
%   with selected mode (default is 'ascend')

if nargin==1
    mode = 'ascend';
end

if ischar(dim)
    [~,dimIdx] = obj.get_dimLevels(dim);
    [~,order] = sortrows(obj.Properties.Dimensions{dimIdx}, dim, mode);
else
    dimIdx = dim;
    [~,order] = sortrows(obj.Properties.Dimensions{dimIdx}, ...
        1:width(obj.Properties.Dimensions{dimIdx}), mode);
end

% reorder the selected dimension
keys = obj.Properties.Dimensions;
keys{dimIdx} = obj.Properties.Dimensions{dimIdx}(order,:);

Dim_order = cellfun_(@(x) 1:x, num2cell(size(obj.data)));
Dim_order{dimIdx} = order;
perm_data = obj.data(Dim_order{:});

dr2_out = DR2(perm_data, keys);
dr2_out = dr2_out.copylog(obj);

if ischar(dim)
    dr2_out = dr2_out.addlog(['sort_levels (' dim ', ' mode ')']);
else
    dr2_out = dr2_out.addlog(['sort_levels (' num2str(dimIdx) ', ' mode ')']);
end
