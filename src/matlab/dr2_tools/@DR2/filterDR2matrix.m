function sub_obj = filterDR2matrix(obj, idx)

dims = size(obj.data);
if (length(idx)>length(dims) && any(cellfun(@(x) any(x~=1), idx))) || ...
        length(idx)<length(dims)
    ME = MException('DR2:missMatchDimensions', ...
        ['Missmatching dimensions for subindexing: data is (' ...
        strjoin(num2cellstr(dims), ', ') ') whereas idx is (' ...
        strjoin(num2cellstr(cellfun(@length,idx)), ', ') ')']);
    throw(ME)
end

if length(idx) < length(obj.Properties.Dimensions)
    idx((end+1):length(obj.Properties.Dimensions)) = {1};
end

newMD = obj.data(idx{:});
newDimensions = cellfun_(@(x,y) x(y,:), obj.Properties.Dimensions, idx);

sub_obj = constructTwoArgument_(obj, newMD, newDimensions);
sub_obj = sub_obj.copylog(obj);
sub_obj = sub_obj.addlog(['filtering based on indexes: (' ...
    strjoin(num2cellstr(cellfun(@length,idx)), ', ') ')']);
