d_original = dataset('XLSFile','../data/Raw_data_20131220.xlsx','sheet','With_Targets');
%% clean name; reduce size

assert(all(strcmp(d_original.Outcome,'Active')));
assert(all(d_original.ActivityConcentration_uM_>0));
d_original = d_original(:,{'FacilityID', 'CompoundNames', 'SMILES', 'PubChemCID', ...
    'ActivityConcentrationName' 'ActivityConcentration_uM_' 'AID__PanelID_', ...
    'Target_GI' 'PMID' 'TARGET_UNIPROT'});
d_original.Properties.VarNames = ReducName(d_original.Properties.VarNames,'_');

% check for only 'HUMAN' genes
assert(~any(cellfun(@isempty,strfind(d_original.TARGETUNIPROT,'HUMAN'))))

disp('Found ActivityConcentrationName:')
disp(unique(d_original.ActivityConcentrationName))
disp(' ')
%%
% split by assay type: IC50
d_original_IC50 = d_original( ismember(d_original.ActivityConcentrationName, ...
    {'IC50' 'EC50' 'GI50' 'IC_Mean', 'EC50_uM' 'AC50_uM'}), :);
d_IC50 = Dataset_stats(d_original,{1 1 1 1 0 @mean @horzcat @horzcat @horzcat 1});
% add the # of assays
d_IC50 = [d_IC50 dataset( cellfun(@length,d_IC50.AIDPanelID), 'VarNames', 'N_assays')];

d_original_Kd = d_original( ismember(d_original.ActivityConcentrationName, ...
    {'Kd' 'Ki' 'Km' 'Potency' 'Potency-Replicate_1'}), :);
d_Kd = Dataset_stats(d_original_Kd,{1 1 1 1 0 @mean @horzcat @horzcat @horzcat 1});
% add the # of assays
d_Kd = [d_Kd dataset( cellfun(@length,d_Kd.AIDPanelID), 'VarNames', 'N_assays')];

% add column RatioActivity and sort the datasets

for iD = 1:2
    if iD==1
        d_temp = d_IC50;
    elseif iD==2
        d_temp = d_Kd;
    end
    RatioActivity = d_temp.ActivityConcentrationuM;
    [Dr,~,DrIdx] = unique(d_temp.FacilityID);
    for iDr = 1:length(Dr)
        subDrIdx = find(DrIdx==iDr);
        RatioActivity(subDrIdx) = RatioActivity(subDrIdx)/min(RatioActivity(subDrIdx));
    end
    
    d_temp = [d_temp dataset(RatioActivity, 'VarNames', 'RatioActivity')];
    d_temp = sortrows(d_temp, {'FacilityID' 'RatioActivity'});
    
    if iD==1
        d_IC50 = AddTargetPathway(d_temp,1:4);
    elseif iD==2
        d_Kd = AddTargetPathway(d_temp,1:4);
    end
end

TarSim_IC50 = Generate_TargetSimilarity(d_IC50);
TarSim_Kd = Generate_TargetSimilarity(d_Kd);

save ../data/TargetInfo_dataset.mat d_IC50 d_Kd TarSim_IC50 TarSim_Kd
        
        
        