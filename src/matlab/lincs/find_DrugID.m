
function corr_drugID = find_DrugID(drug_label)

global backgrd
if isempty(backgrd)
    backgrd.data = dataset('xlsfile','../data/small_molecule_20140104143233.xls');
    temp = cellfun_dispatch(@regexp,backgrd.data.SmallMolHMSLINCSID,'-','split');
    temp = reshape([temp{:}],2,[]);
    backgrd.data.FacilityID = cellfun_dispatch(@horzcat,'HMSL',temp(1,:));
    [~,idx] = unique(backgrd.data.FacilityID,'first');
    backgrd.data = backgrd.data(idx,:);
    backgrd.ID_nameMap = containers.Map(backgrd.data.FacilityID, backgrd.data.SMName);
    backgrd.ID_AltnameMap = containers.Map(backgrd.data.FacilityID, backgrd.data.AlternativeNames);
    backgrd.ID_MWMap = containers.Map(backgrd.data.FacilityID, backgrd.data.MolecularMass);
end

if ~ismember(drug_label,backgrd.data.FacilityID)    
    if strcmp(drug_label(1:4),'HMSL')
        error('unknown HMSL id')
    elseif isnumeric(drug_label)
        corr_drugID = ['HMSL' num2str(drug_label)];
        if ~ismember(corr_drugID,backgrd.data.FacilityID)
            error('unknown HMSL id')
        end
    elseif ~isempty(str2num(drug_label))
        corr_drugID = ['HMSL' drug_label];
        if ~ismember(corr_drugID,backgrd.data.FacilityID)
            error('unknown HMSL id')
        end
    elseif any(~cellfun(@isempty,strfind(upper(backgrd.data.SMName),upper(drug_label))))
        idx = find(~cellfun(@isempty,strfind(upper(backgrd.data.SMName),upper(drug_label))));
        if length(idx)>1
            temp = cellfun_dispatch(@strcat,backgrd.data.SMName(idx),'-')';
            error('More than one match found: -%s ', horzcat(temp{:}))
        end
        if ~strcmpi(backgrd.data.SMName{idx},drug_label)
            warning('Using partial match: %s',backgrd.data.SMName{idx})
        end
        corr_drugID = backgrd.data.FacilityID{idx};
    elseif any(~cellfun(@isempty,strfind(upper(backgrd.data.AlternativeNames),upper(drug_label))))
        idx = find(~cellfun(@isempty,strfind(upper(backgrd.data.AlternativeNames),upper(drug_label))));
        if length(idx)>1
            temp = cellfun_dispatch(@strcat,backgrd.data.AlternativeNames(idx),'-')';
            error('More than one match found: -%s ', horzcat(temp{:}))
        end
        if ~strcmpi(backgrd.data.SMName{idx},drug_label)
            warning('Using partial match: %s',backgrd.data.AlternativeNames{idx})
        end
        corr_drugID = backgrd.data.FacilityID{idx};
    else
        error('Unknown durg name: %s', drug_label)
    end
    fprintf('   %s --> %s \n', drug_label, corr_drugID);
end