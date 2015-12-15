function [matrix, dims] = List_toHD(data, value_name, DimNames, DuplicateFct)
% [matrix, dim1_labels, dim2_labels] = DatasetExtract(data, value_name, DimNames, DuplicateFct)
%
%  very slow !! works only until 5 dimensions!!
%

assert(ischar(value_name))
assert(ismember(value_name, data.Properties.VarNames))
if ischar(DimNames); DimNames = {DimNames};end

dims = cell(1,length(DimNames));
isnum = true(1,length(DimNames));
ldim = zeros(1,length(DimNames));
idxes = cell(1,length(DimNames));

for i=1:length(DimNames)
    dim = DimNames{i};
    
    if (ischar(dim) || (iscell(dim) && all(cellfun(@ischar,dim)))) && ...
            all(ismember(dim,data.Properties.VarNames))
        % case 1: field name as input
        dim = unique(data(:,dim));
    elseif isa(dim,'dataset')
        % case 2: dataset as an input
        assert(size(dim,2)==1)
        if length(unique(dim)) ~= length(dim)
            % if replicates are found -> remove them
            warning('compacting dimension %i to avoid replicates',i)
            dim = unique(dim);
        end
    elseif isempty(dim)
        error('dim %i not properly defined',i)
    end
    
    dims{i} = dim;
    isnum(i) = isnumeric(data.(dim.Properties.VarNames{1}));
    ldim(i) = length(dim);
    
    idxes{i} = false(size(data,1), ldim(i));
    for j=1:ldim(i)
        if isnum(i)
            idxes{i}(:,j) = data.(dim.Properties.VarNames{1}) == dim{j,1};
        else
            idxes{i}(:,j) = strcmp(data.(dim.Properties.VarNames{1}), dim{j,1});
        end
    end
end

if length(ldim)==1
    matrix = NaN(ldim,1);
else
    matrix = NaN(ldim);
end
duplicateWarn = true;
for i1=1:ldim(1)
    if length(DimNames)>1; for i2=1:ldim(2)
            if length(DimNames)>2; for i3=1:ldim(3)
                    if length(DimNames)>3; for i4=1:ldim(4)
                            
                            
                            if length(DimNames)>4; for i5=1:ldim(5)
                                    
                                    idx = find(idxes{1}(:,i1) & idxes{2}(:,i2) & ...
                                        idxes{3}(:,i3) & idxes{4}(:,i4)  & idxes{5}(:,i5));
                                    if length(idx)>1
                                        if exist('DuplicateFct','var') && isa(DuplicateFct,'function_handle')
                                            if duplicateWarn, warning('Duplicates founds --> using merging function'),end
                                            duplicateWarn = false;
                                            matrix(i1,i2,i3,i4,i5) = DuplicateFct(data.(value_name)(idx));
                                        else
                                            disp('More than one value at a given position:')
                                            disp(data(idx,:))
                                            error('Provide a proper function to handle duplicate')
                                        end
                                    elseif ~isempty(idx)
                                        matrix(i1,i2,i3,i4,i5) = data.(value_name)(idx);
                                    end
                                end
                            else
                                idx = find(idxes{1}(:,i1) & idxes{2}(:,i2) & ...
                                    idxes{3}(:,i3) & idxes{4}(:,i4));
                                if length(idx)>1
                                    if exist('DuplicateFct','var') && isa(DuplicateFct,'function_handle')
                                        if duplicateWarn, warning('Duplicates founds --> using merging function'),end
                                        duplicateWarn = false;
                                        matrix(i1,i2,i3,i4) = DuplicateFct(data.(value_name)(idx));
                                    else
                                        disp('More than one value at a given position:')
                                        disp(data(idx,:))
                                        error('Provide a proper function to handle duplicate')
                                    end
                                elseif ~isempty(idx)
                                    matrix(i1,i2,i3,i4) = data.(value_name)(idx);
                                end
                            end
                        end
                    else
                        idx = find(idxes{1}(:,i1) & idxes{2}(:,i2) & idxes{3}(:,i3));
                        if length(idx)>1
                            if exist('DuplicateFct','var') && isa(DuplicateFct,'function_handle')
                                if duplicateWarn, warning('Duplicates founds --> using merging function'),end
                                duplicateWarn = false;
                                matrix(i1,i2,i3) = DuplicateFct(data.(value_name)(idx));
                            else
                                disp('More than one value at a given position:')
                                disp(data(idx,:))
                                error('Provide a proper function to handle duplicate')
                            end
                        elseif ~isempty(idx);matrix(i1,i2,i3) = data.(value_name)(idx);end
                    end
                end
            else
                idx = find(idxes{1}(:,i1) & idxes{2}(:,i2) );
                if length(idx)>1
                    if exist('DuplicateFct','var') && isa(DuplicateFct,'function_handle')
                        if duplicateWarn, warning('Duplicates founds --> using merging function'),end
                        duplicateWarn = false;
                        matrix(i1,i2) = DuplicateFct(data.(value_name)(idx));
                    else
                        disp('More than one value at a given position:')
                        disp(data(idx,:))
                        error('Provide a proper function to handle duplicate')
                    end
                elseif ~isempty(idx);matrix(i1,i2) = data.(value_name)(idx);end
            end
        end
    else
        idx = find(idxes{1}(:,i1) );
        if length(idx)>1
            if exist('DuplicateFct','var') && isa(DuplicateFct,'function_handle')
                if duplicateWarn, warning('Duplicates founds --> using merging function'),end
                duplicateWarn = false;
                matrix(i1) = DuplicateFct(data.(value_name)(idx));
            else
                disp('More than one value at a given position:')
                disp(data(idx,:))
                error('Provide a proper function to handle duplicate')
            end
        elseif ~isempty(idx);matrix(i1) = data.(value_name)(idx);end
    end
end





