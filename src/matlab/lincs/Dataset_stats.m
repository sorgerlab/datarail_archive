function d_out = Dataset_stats(d_in , criteria)
% function d_out = Dataset_stats(d_in , criteria)
%   criteria:   * 1 or true for merging criterion
%               * 0 or flase for removing the column
%               * function handle for anything else
%                   e.g. @mean, @horzcat

assert(size(d_in,2)==length(criteria))
lc = length(criteria);

% record criteria :
MergeIdx = false(size(criteria)); % merging idxes
RemoveIdx = false(size(criteria)); % idxes to remove
FctIdx =  false(size(criteria)); % idxes with fcts
for i = 1:lc
    MergeIdx(i) = (isnumeric(criteria{i}) && (criteria{i}==1)) || ...
        (islogical(criteria{i}) && criteria{i});
    RemoveIdx(i) = (isnumeric(criteria{i}) && (criteria{i}==0)) || ...
        (islogical(criteria{i}) && ~criteria{i});
    FctIdx(i) = isa(criteria{i},'function_handle');
end

assert(all(sum([MergeIdx; RemoveIdx; FctIdx]==1)))
FctIdx = find(FctIdx);

% merging the dataset based on the selected columns
[d_tempMerge,~,idx_in] = unique(d_in(:,MergeIdx));

% applying functions on the other columns
d_tempFct = dataset();
for j=1:length(FctIdx)
    temp = cell(size(d_tempMerge,1),1);
    for i=1:size(d_tempMerge,1)
        temp{i} = criteria{FctIdx(j)}(d_in.(d_in.Properties.VarNames{FctIdx(j)})(idx_in==i));
    end
    if all(cellfun(@length,temp)==1) && all(cellfun(@isnumeric,temp))
        % replace the cell by an array if single numeric value per row
        d_tempFct = [d_tempFct dataset(cell2mat(temp),'VarNames',d_in.Properties.VarNames(FctIdx(j)))];
    else
        d_tempFct = [d_tempFct dataset(temp,'VarNames',d_in.Properties.VarNames(FctIdx(j)))];
    end
end

% concatenate the two datasets
d_out = [d_tempMerge d_tempFct];
% reorder the columns as d_in
[~,idx] = ismember(d_out.Properties.VarNames, d_in.Properties.VarNames);
[~,order] = sort(idx,'ascend');
d_out = d_out(:,order);
