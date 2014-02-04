function [OutDS, matrix] = FindReplicatesDataset(data, dim, value_name)

assert(ischar(value_name))

% controls for the dimension; cannot be empty
if (ischar(dim) || (iscell(dim) && all(cellfun(@ischar,dim)))) && ...
        all(ismember(dim,data.Properties.VarNames))
    % case 1: field name as input
    dim = unique(data(:,dim));
elseif isa(dim,'dataset')
    % case 2: dataset as an input
    if length(unique(dim)) ~= length(dim)
    end
elseif isempty(dim)
    error('dim needs to be defined')
end
isnum = true(1,size(dim,2));
for i=1:size(dim,2)
    isnum(i) = isnumeric(data.(dim.Properties.VarNames{i}));
end
ldim = size(dim,2);

OutDS = unique(data(:,dim.Properties.VarNames));
OutDS = [OutDS dataset(zeros(size(OutDS,1),1), 'VarNames', 'Replicate')];
loDS = size(OutDS,1);

matrix = NaN(loDS,ceil(length(data)/loDS)+2);
nReplicate = 0;
for iD=1:loDS
    idx = true(size(data,1),1);
    for i1 = 1:ldim
        if isnum(i1)
            idx = idx & (data.(dim.Properties.VarNames{i1}) == ...
                OutDS.(dim.Properties.VarNames{i1})(iD));
        else
            idx = idx & strcmp(data.(dim.Properties.VarNames{i1}), ...
                  OutDS.(dim.Properties.VarNames{i1}){iD});
        end
    end
    nReplicate = max(nReplicate, sum(idx));
    if nReplicate>size(matrix,2)
        matrix = [ matrix NaN(size(matrix,1), nReplicate-size(matrix,2) ) ];
    end
    matrix(iD,1:sum(idx)) = data.(value_name)(idx)';
    OutDS.Replicate(iD) = sum(idx);
end