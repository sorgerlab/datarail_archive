function [matrix, dim1_labels, dim2_labels] = DatasetExtract(data, dim1, dim2, value_name, merging_fct)
% [matrix, dim1_labels, dim2_labels] = DatasetExtract(data, dim1, dim2, value_name, merging_fct)
%
%  very slow !!

if ~exist('merging_fct','var')
    merging_fct = @(x) x;
    merging_used = -1;
else
    merging_used = 0;
end

assert(ischar(value_name))

% controls for the 1st dimension; cannot be empty
if (ischar(dim1) || (iscell(dim1) && all(cellfun(@ischar,dim1)))) && ...
        all(ismember(dim1,data.Properties.VarNames))
    % case 1: field name as input
    dim1 = unique(data(:,dim1));
elseif isa(dim1,'dataset')
    % case 2: dataset as an input
    if length(unique(dim1)) ~= length(dim1)
        % if replicates are found -> remove them
        warning('compacting dim1 to avoid replicates')
        dim1 = unique(dim1);
    end
elseif isempty(dim1)
    error('dim1 needs to be defined')
end
isnum1 = true(1,size(dim1,2));
for i=1:size(dim1,2)
    isnum1(i) = isnumeric(data.(dim1.Properties.VarNames{i}));
end
l1 = length(dim1);

% controls for the 2nd dimension; could be empty
usedim2 = true;
if (ischar(dim2) || (iscell(dim2) && all(cellfun(@ischar,dim2)))) && ...
        ismember(dim2,data.Properties.VarNames)
    dim2 = unique(data(:,dim2));
elseif isa(dim2,'dataset')
    if length(unique(dim2)) ~= length(dim2)
        warning('compacting dim1 to avoid replicates')
        dim2 = unique(dim2);
    end
elseif isempty(dim2)
    usedim2 = false;
end

if usedim2
    l2 = length(dim2);
    dim2_labels = dim2;
else    % case for an empty 2nd dimension -> fill with everything that is not in 1st dim.
    l2 = size(data,1)/l1;
    if isnum1
        idx1 = data.(dim1.Properties.VarNames{1}) == dim1{1,:};
    else
        idx1 = strcmp(data.(dim1.Properties.VarNames{1}), dim1{1,:});
    end
    dim2_labels = data(idx1, ...
        setdiff(data.Properties.VarNames, {dim1.Properties.VarNames{1}, value_name}));
    dim2 = grpstats(data, dim2_labels.Properties.VarNames ,'mean', ...
        'DataVars',dim1.Properties.VarNames);
    dim2.GroupCount = [];
    dim2.(['mean_' dim1.Properties.VarNames{1}]) = [];
    assert(l2==size(dim2,1), 'not possible to define the 2nd dimension')
end

isnum2 = true(1,size(dim2,2));
for i=1:size(dim2,2)
    isnum2(i) = isnumeric(data.(dim2.Properties.VarNames{i}));
end

missing_values = 0;
matrix = NaN(l1,l2);
dim1_labels = dim1;
for i=1:l1
    % filter for dimension 1; depending if numeric or nor
    idx1 = true(size(data,1),1);
    for i1 = 1:size(dim1,2)
        if isnum1(i1)
            idx1 = idx1 & (data.(dim1.Properties.VarNames{i1}) == dim1{i,i1});
        else
            idx1 = idx1 & strcmp(data.(dim1.Properties.VarNames{i1}), dim1{i,i1});
        end
    end
    for j=1:l2
        % filter for dimension 1; depending if numeric or nor
        idx2 = true(size(data,1),1);
        for j2 = 1:size(dim2,2)
            if isnum2(j2)
                idx2 = idx2 & (data.(dim2.Properties.VarNames{j2}) == dim2{j,j2});
            else
                idx2 = idx2 & strcmp(data.(dim2.Properties.VarNames{j2}), dim2{j,j2});
            end
        end
        
        % multiple values after filtering -> specific function
        temp = data.(value_name)( idx1 & idx2, : );
        if length(temp)>1
            temp = merging_fct(temp);
            if merging_used==0 && length(temp)==1
                warning('Found multiple matches for same position --> use merging fct');
                merging_used=1;
            elseif merging_used==-1 || length(temp)>1
                disp(data( idx1 & idx2, : ))
                error('Found multiple matches for same position and/or NO proper merging fct!');                
            elseif length(temp)~=1
                error('Unknown issue with merging fct!');
            end
        elseif isempty(temp)
            if missing_values==0
                warning('Missing values in the 2D matrix --> NaN at positions')
            end
            missing_values = 1;
            continue
        else
            temp = merging_fct(temp);
        end
        matrix(i,j) = temp;
    end
end

