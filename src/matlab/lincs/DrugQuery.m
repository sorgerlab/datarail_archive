function d_out = DrugQuery(d_in, Drug, Targetcutoff, exact)
% d_out = DrugQuery(d_in, Drug, exact, Targetcutoff)
%
%   e.g.: DrugQuery(d_IC50,'Torin') --> Torin1, Torin2
%         DrugQuery(d_IC50,'Torin1') --> Torin1
%         DrugQuery(d_IC50,'HMSL10079') --> Torin1
%         DrugQuery(d_IC50,10079, 50) --> Torin1, top 50-fold target
%         DrugQuery(d_IC50,'Torin',[],1) --> null
%         DrugQuery(d_IC50,'Torin1',[],1) --> Torin1
%         DrugQuery(d_IC50,{'Torin1' 'Torin2'}) --> Torin1, Torin2
%         DrugQuery(d_IC50,{'Torin1' 10080}, [50 100]) --> Torin1, Torin2
%                                                       top 50- and 100-fold target
%


if ~exist('Targetcutoff','var') || isempty(Targetcutoff)
    Targetcutoff = Inf;
end

if ~exist('exact','var') || isempty(exact)
    exact = false;
end

if ~ischar(Drug) && length(Drug)>1
    if length(Targetcutoff)==1
        Targetcutoff = Targetcutoff*size(Drug);
    else
        assert(length(Targetcutoff)==length(Drug));
    end
    d_out = dataset;
    for i=1:length(Drug)
        if iscell(Drug(i))
            d_out = [d_out; DrugQuery(d_in, Drug{i}, Targetcutoff(i), exact)];
        else
            d_out = [d_out; DrugQuery(d_in, Drug(i), Targetcutoff(i), exact)];
        end
    end
    d_out = sortrows(d_out,{'FacilityID' 'ActivityConcentrationuM'});
    return
end


if isnumeric(Drug)
    Drug = ['HMSL' num2str(Drug)];
end

if exact
    d_out = d_in( strcmp(d_in.CompoundNames,Drug) | ...
        strcmp(d_in.FacilityID,Drug) ,:);
else
    d_out = d_in( ~cellfun(@isempty,strfind(d_in.CompoundNames,Drug)) | ...
        ~cellfun(@isempty,strfind(d_in.FacilityID,Drug)) ,:);
end


d_out = sortrows(d_out(d_out.RatioActivity<=Targetcutoff,:), ...
    {'FacilityID' 'ActivityConcentrationuM'});