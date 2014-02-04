Initialization

%%

metricLig = 'correlation';
LigDist = pdist(LigResp_2D',metricLig);
metricCL = 'Spearman';
CLDist = pdist(LigResp_2D,metricCL);

ZCL = linkage(CLDist,'average');
ZLig = linkage(LigDist,'average');

pos = [.1 .2 .7 .7];
figure(34);clf

axes('position',[pos(1)-.05 pos(2) .05 pos(4)])
[hCL,~,permCL] = dendrogram(ZCL,0,'orientation','left','colorthreshold',.55);
set(gca,'xtick',[],'ytick',[],'fontweight','bold','fontsize',8,'visible','off')
ylim([.5 length(permCL)+.5])
% set(hCL,'color','k')

axes('position',[pos(1) pos(2)+pos(4) pos(3) .05])
[hLig,~,permLig] = dendrogram(ZLig,0,'orientation','top','colorthreshold',.8);
set(gca,'ytick',[],'xtick',[],'fontweight','bold','fontsize',8,'visible','off')
xlim([.5 length(permLig)+.5])
% set(hLig,'color','k')

axes('position',pos)
imagesc(LigResp_2D(permCL,permLig),[-2 2]);
colormap(Plotting_parameters.cmapBrWGr)
set(gca,'xtick',[],'ytick',[],'box','on')


hc = colorbar;
set(hc,'position',[pos(1)+pos(3)+.05 pos(2)-.1 .01 .08],'fontsize',6)
ylabel(hc,'Fold-change','fontsize',8,'fontweight','bold')

axes('position',[pos(1) pos(2)-.021 pos(3) .02])
hold on
for i=1:length(LigFam_list)
    idx = find(strcmp(LigFamLabels.LigFam(permLig), LigFam_list{i}));
    h = bar([-2 -1 idx'], ones(1,length(idx)+2), 1);
    set(h, 'facecolor', Ligcolors(i,:),'edgecolor','none');    
end
ylim([0 1])
xlim([.5 length(permLig)+.5])
for i=1:length(permLig)
    text(i,-.2, [LigFamLabels.Ligand{permLig(i)} '-' ...
        LigFamLabels.LigFam{permLig(i)}], 'fontsize',8, 'rotation',270)
end
set(gca,'xtick',[],'ytick',[],'box','on')


axes('position',[pos(1)+pos(3)+.001 pos(2) .02 pos(4)])
hold on
for i=1:length(Tissue_list)
    idx = find(strcmp(LigCellLabels.Tissue(permCL), Tissue_list{i}));
    h = barh([-2 -1 idx'], ones(1,length(idx)+2), 1);
    set(h, 'facecolor', Tissuecolors(i,:),'edgecolor','none');    
end
xlim([0 1])
ylim([.5 length(permCL)+.501])
set(gca,'xtick',[],'ytick',1:length(permCL),'yticklabel', ...
    strcat(LigCellLabels.CellLine(permCL), '-',LigCellLabels.Tissue(permCL)),...
    'YAxisLocation','right','fontsize',8,'ydir','normal','box','on')



set(gcf,'color','w','position',[50 50 1000 700],'PaperUnits','centimeters',...
    'papersize',[29 23],'paperpositionmode','auto',...
    'filename','Clust_LigResp.pdf')

%%
clustergram(LigResp_2D, 'rowlabels', LigCellLabels.CellLine, 'columnlabels', ...
    LigFamLabels.Ligand, 'standardize', 0, 'RowPDist', metricCL, ...
    'ColumnPDist' , metricLig)