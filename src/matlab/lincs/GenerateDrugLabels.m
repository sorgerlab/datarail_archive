function Drug_labels = GenerateDrugLabels(data, level, ref_data)

global reference_dataset

if ~exist('level','var')
    level = 2;
end
if ~exist('ref_data','var')
    if isempty(reference_dataset)
        reference_dataset = load('../data/TargetInfo_dataset.mat','d_IC50');
        reference_dataset = reference_dataset.d_IC50;
    end
    ref_data = reference_dataset;
end

Drug_labels = cell(size(data,1),1);

for i=1:size(data,1)
    if mod(level,10)>1 && ismember('FacilityID',data.Properties.VarNames)
        Drug_labels{i} = [data.FacilityID{i} ' - '];
    end
    if mod(level,10)<=2
        Drug_labels{i} = [Drug_labels{i} data.CompoundNames{i}(1:min( ...
            [end,15, find(data.CompoundNames{i}==';',1,'first')-1]))];
    else
        Drug_labels{i} = [Drug_labels{i} data.CompoundNames{i}];
    end
    if level>10
        topTarget = DrugQuery(ref_data, data.CompoundNames{i});
        if ~isempty(topTarget)
            Drug_labels{i} = [Drug_labels{i} ' (' topTarget.(['Pathway_L' num2str(floor(level/10))]){1} ')'];
        end
    end
end
