Initialization

%%

metricReadout = 'correlation';
ReadoutDist = pdist(BasalLevels2D',metricReadout);
metricCL = 'correlation';
CLDist = pdist(BasalLevels2D,metricCL);

ZCL = linkage(CLDist,'average');
ZRO = linkage(ReadoutDist,'average');

pos = [.1 .2 .7 .7];
figure(34);clf

axes('position',[pos(1)-.05 pos(2) .05 pos(4)])
[hCL,~,permCL] = dendrogram(ZCL,0,'orientation','left','colorthreshold',.5);
set(gca,'xtick',[],'ytick',[],'fontweight','bold','fontsize',8,'visible','off')
ylim([.5 length(permCL)+.5])
% set(hCL,'color','k')

axes('position',[pos(1) pos(2)+pos(4) pos(3) .05])
[hRO,~,permRO] = dendrogram(ZRO,0,'orientation','top','colorthreshold',.8);
set(gca,'ytick',[],'xtick',[],'fontweight','bold','fontsize',8,'visible','off')
xlim([.5 length(permRO)+.5])
% set(hLig,'color','k')

axes('position',pos)
imagesc(BasalLevels2D(permCL,permRO),[-5.5 .5]);
colormap(Plotting_parameters.cmapWP)
set(gca,'xtick',[],'ytick',[],'box','on')


hc = colorbar;
set(hc,'position',[pos(1)+pos(3)+.05 pos(2)-.1 .01 .08],'fontsize',6)
ylabel(hc,'pg/cell','fontsize',8,'fontweight','bold')

axes('position',[pos(1) pos(2)-.021 pos(3) .02])
hold on
for i=1:length(BasalFam_list )
    idx = find(strcmp(BasalReadout.KinaseFam(permRO), BasalFam_list {i}));
    h = bar([-2 -1 idx'], ones(1,length(idx)+2), 1);
    set(h, 'facecolor', Basalcolors(i,:),'edgecolor','none');    
end
ylim([0 1])
xlim([.5 length(permRO)+.5])
for i=1:length(permRO)
%     text(i,-.2, BasalReadout.Readout{permRO(i)}, 'fontsize',8, 'rotation',270)
    text(i,-.2, [BasalReadout.Readout{permRO(i)} '-' ...
        BasalReadout.KinaseFam{permRO(i)}], 'fontsize',8, 'rotation',270)
end
set(gca,'xtick',[],'ytick',[],'box','on')


axes('position',[pos(1)+pos(3)+.001 pos(2) .02 pos(4)])
hold on
for i=1:length(Tissue_list)
    idx = find(strcmp(BasalCellLabels.Tissue(permCL), Tissue_list{i}));
    h = barh([-2 -1 idx'], ones(1,length(idx)+2), 1);
    set(h, 'facecolor', Tissuecolors(i,:),'edgecolor','none');    
end
xlim([0 1])
ylim([.5 length(permCL)+.501])
set(gca,'xtick',[],'ytick',1:length(permCL),'yticklabel', ...
    strcat(BasalCellLabels.CellLine(permCL), '-',BasalCellLabels.Tissue(permCL)),...
    'YAxisLocation','right','fontsize',8,'ydir','normal','box','on')



set(gcf,'color','w','position',[50 50 1000 700],'PaperUnits','centimeters',...
    'papersize',[29 23],'paperpositionmode','auto',...
    'filename','Clust_LigResp.pdf')

%%
clustergram(BasalLevels2D, 'rowlabels', BasalCellLabels.CellLine, 'columnlabels', ...
    BasalReadout.Readout, 'standardize', 0, 'RowPDist', metricCL, ...
    'ColumnPDist' , metricReadout)