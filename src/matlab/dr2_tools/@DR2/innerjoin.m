function [dr2_out, Ridx, idx] = innerjoin(obj, t_in, varargin)
% [dr2_out, Ridx, idx] = innerjoin(dr2, t_right, varargin)
%   innerjoin for table t_in on object DR2 to the left, maintain order
%
%   Ridx are the indexes in t_right corresponding to the rows of DR2
%


% find the dimension on which to merge the table
[dimNames,~,dimIdx] = obj.get_dimNames;
lk_idx = find(strcmpi(varargin, 'leftkeys'));
if ~isempty(lk_idx)
    lkeys = varargin{lk_idx+1};
    if ischar(lkeys), lkeys = {lkeys}; end
    SelectedDim = unique(dimIdx(ismember(dimNames, lkeys)));
else
    lkeys = intersect(varnames(t_in), dimNames, 'stable');
    SelectedDim = unique(dimIdx(ismember(dimNames, lkeys)));    
end
% check that all selected keys are on the same dimension
if length(SelectedDim)~=1 || ~all(ismember(lkeys, dimNames))
    ME = MException('DR2:notMatchedKeysJoin', ...
        'All left keys should be on the same dimension of DR2 object');
    throw(ME)
end

% perform the join (outer-left)
[t_out, idx, Ridx] = innerjoin(obj.Properties.Dimensions{SelectedDim}, t_in, ...
     varargin{:}); 


% reassign the levels (need reordering to match original version)
keys = obj.Properties.Dimensions;
keys{SelectedDim} = t_out(sortidx(idx),:);
% same on the data
data = permute(obj.data, [SelectedDim setdiff(1:length(size(obj.data)), SelectedDim)]);
dims = size(data);
data = reshape(data(idx,:), [length(idx), dims(2:end)]);
data = permute(data, sortidx([SelectedDim setdiff(1:length(size(obj.data)), SelectedDim)]));
Ridx = Ridx(sortidx(idx));

% creat teh output DR2 object
dr2_out = DR2(data, keys);
dr2_out = dr2_out.copylog(obj);
dr2_out = dr2_out.addlog(sprintf('innerjoin on dimension %i, keys %s', SelectedDim, strjoin(lkeys,', ')));
 

