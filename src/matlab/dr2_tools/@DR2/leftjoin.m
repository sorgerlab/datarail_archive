function [dr2_out, Ridx, idx] = leftjoin(obj, t_in, varargin)
% [dr2_out, Ridx, idx] = leftjoin(dr2, t_right, varargin)
%   outerjoin for table t_in on object DR2 to the left, maintain order
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
[t_out, idx, Ridx] = outerjoin(obj.Properties.Dimensions{SelectedDim}, ...
    table2categorical(t_in), ...
     'type', 'left', 'MergeKeys', true, varargin{:}); 
assert(all(idx>0))
warnassert(all(hist(idx,1:height(obj.Properties.Dimensions{SelectedDim}))<=1), ...
    ['DR2:LEFTJOIN: multiple entries from table match a row of dr2.(' strjoin(lkeys,', ') ')'])
% relabel the column names after the merge


for i=1:length(lkeys)
    t_out.Properties.VariableNames = regexprep(t_out.Properties.VariableNames,...
        ['^' lkeys{i} '_[\w]*'], lkeys{i});
end

% reassign the levels (need reordering to match original version)
keys = obj.Properties.Dimensions;
keys{SelectedDim} = t_out(sortidx(idx),:);
% same on the data
data = permute(obj.data, [SelectedDim setdiff(1:length(size(obj.data)), SelectedDim)]);
data(:,:) = data(idx,:);
data = permute(data, sortidx([SelectedDim setdiff(1:length(size(obj.data)), SelectedDim)]));
Ridx = Ridx(sortidx(idx));

% creat teh output DR2 object
dr2_out = DR2(data, keys);
dr2_out = dr2_out.copylog(obj);
dr2_out = dr2_out.addlog(sprintf('leftjoin on dimension %i, keys %s', SelectedDim, strjoin(lkeys,', ')));
 

