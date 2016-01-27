function dr2_out = sort_dims(obj, sort_keys)
% dr2_out = sort_dims(obj, sort_keys)
%   sort the dimensions by number of levels. 
%   If mutiple keys refer to the same dimensions, they are sorted if 
%   sort_keys is true (default is false)

if nargin==1
    sort_keys = false;
end


% order the dimensions by length and alphabetical (for even cases)
dim_length = cellfun(@height, obj.Properties.Dimensions);
[dimNames, ~,dimIdx] = get_dimNames(obj);
[~,idx] = sort(dimNames);
[~,idx] = sort(idx);
for i=1:length(dim_length)
    dim_length(i) = dim_length(i)-min(idx(dimIdx==i))/(1+length(dimNames));
end
[~,dim_order] = sort(dim_length,'descend');

% reassign the dimensions
if sort_keys
    keys = cellfun_(@(x) x(:,sort(x.Properties.VariableNames)), ...
        obj.Properties.Dimensions(dim_order));
else
    keys = obj.Properties.Dimensions(dim_order);
end
perm_data = permute(obj.data, dim_order);

dr2_out = DR2(perm_data, keys);
dr2_out = dr2_out.copylog(obj);
dr2_out = dr2_out.addlog(['sort_dims (' num2str(sort_keys) ')']);
