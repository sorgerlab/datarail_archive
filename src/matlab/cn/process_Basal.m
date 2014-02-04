if ~exist('BasalLevels','var')
    load CN10_BasalLevels.mat
end

[Basal_rep, Basla_rep_values] = FindReplicatesDataset(BasalLevels,{'Readout' 'Tissue' 'CellLine'}, 'Mean');
[BasRep_2D, repCL, rep_readout] = DatasetExtract(Basal_rep,{'CellLine' 'Tissue'}, 'Readout','Replicate');

%%
figure(33);clf
axes('position',[.1 .05 .85 .8])
imagesc(BasRep_2D,[-.5 5]);
set(gca,'ytick',1:length(repCL),'yticklabel',repCL.CellLine,'xtick',[],'fontsize',8)
for i=1:length(rep_readout)
    text(i,0,rep_readout.Readout{i},'rotation',90,'fontsize',8)
end
hc = colorbar;
colormap(jet(6))
set(hc,'position',[.96 .4 .02 .2],'ytick',(0:5)/1.1,'yticklabel',0:5)

set(gcf,'color','w','position',[50 50 900 600],'PaperUnits','centimeters',...
    'papersize',[28 18],'paperpositionmode','auto',...
    'filename','Basal_Replicates.png')
%%

[Basal_repMast, Basal_repMast_values] = FindReplicatesDataset(BasalLevels(strcmp(BasalLevels.Source,'Masterbank'),:), ...
    {'Readout' 'Tissue' 'CellLine'}, 'Mean');
[BasRepMast_2D, repCLMast, repMast_readout] = DatasetExtract(Basal_repMast,{'CellLine' 'Tissue'}, 'Readout','Replicate');

%%
figure(34);clf
axes('position',[.1 .05 .85 .8])
imagesc(BasRepMast_2D,[-.5 5]);
set(gca,'ytick',1:length(repCLMast),'yticklabel',repCLMast.CellLine,'xtick',[],'fontsize',8)
for i=1:length(repMast_readout)
    text(i,0,repMast_readout.Readout{i},'rotation',90,'fontsize',8)
end
hc = colorbar;
colormap(jet(6))
set(hc,'position',[.96 .4 .02 .2],'ytick',(0:5)/1.1,'yticklabel',0:5)

set(gcf,'color','w','position',[50 50 900 600],'PaperUnits','centimeters',...
    'papersize',[28 18],'paperpositionmode','auto',...
    'filename','Basal_ReplicatesMaster.png')
%%







%%
temp = BasalLevels(:,{'CellLine' 'Tissue' 'Source' 'BioRep'}); % example for using another dataset as input
temp.Properties.ObsNames = [];
infmean = @(x) mean(x(isfinite(x)));
[BasalLevels_2D, BasalCellLabels, BasalLabels] = DatasetExtract(BasalLevels, temp, {'Readout' 'Assay Rep'}, 'Mean'); 
figure(555);clf
subplot(131);imagesc(BasalLevels_2D,[-8 0])
BasalLevels_temp = DatasetExtract(BasalLevels, temp, 'Readout', 'Mean', @nanmean); 
subplot(132);imagesc(isinf(BasalLevels_temp))
BasalLevels_2D(~isfinite(BasalLevels_2D) & isinf(BasalLevels_temp)) = nanmin(BasalLevels_2D(:));
subplot(133);imagesc(BasalLevels_2D,[-8 0])
save CN10_BasalLevels.mat BasalLevels_2D BasalCellLabels BasalLabels BasalLevels
