
if ~exist('d_IC50','var')
    load ../data/TargetInfo_dataset.mat
end

% distance : define new dataset with single drug
d1 = DrugQuery(d_IC50,'Torin1');
d2 = DrugQuery(d_IC50,'Rapamycin');

% evaluate distance
TarSim = TargetSimilarity(d1, d2);
fprintf('\nSimilarity (Jaccard) between  %s  and  %s  : %.3f\n', d1.CompoundNames{1}, ...
    d2.CompoundNames{2}, TarSim);

% evaluate distance
TarSim = TargetSimilarity(d1, d2, 'JaccardPathway');
fprintf('Similarity (JaccardPathway) between  %s  and  %s  : %.3f\n\n', d1.CompoundNames{1}, ...
    d2.CompoundNames{2}, TarSim);
%% distances for a set of drugs
% selet metric
metrics = {'Jaccard' 'JaccardPathway' 'weighted'};

% add the pathway for each target
d_IC50 = AddTargetPathway(d_IC50,2);

% select drugs based on a target.
mTOR_list = TargetQuery(d_IC50,'MTOR');
Drug_labels = GenerateDrugLabels(mTOR_list,2);
for iM = 1:length(metrics)
    metric = metrics{iM};
    
    % select drugs based on a target.
    TarSim = TargetSimilarity(mTOR_list.FacilityID, [], metric);
    %%
    figure(20+iM);clf
    
    [perm, h, hmap, hcbar, axs] = nice_dendrogram_heatmap(TarSim, Drug_labels);
    xlabel(hcbar,[metric ' similarity'],'fontsize',10);
end

%%

d_in = TargetQuery(d_IC50, {'EGFR' 'IGF' 'ErbB'}); 
d_in = d_in( d_in.RatioActivity<10, :);
TarSim = TargetSimilarity(unique(d_in.FacilityID),[],'all');
figure(29);clf;
for i=1:6
    pos = [.06+mod(i-1,3)*.3 1.1-ceil(i/3)*.5 .15 .3];
    [perm, h, hmap, hcbar, axs] = nice_dendrogram_heatmap(TarSim.Sim(:,:,i), TarSim.d1, pos);    
    title(TarSim.metrics{i});
end
colormap(Plotting_parameters.cmapRW(end:-1:1,:))
