Initialization

%%

Ligand_equivalence = {
    'HRG (CF)' 'HRG'
    'NGFb' 'NGF-beta'
    'IGF1' 'IGF-1'
    'IGF2' 'IGF-2'
    'Ins' 'INS'
    'PDGFBB' 'PDGF-BB'};

CN20Resp_2 = CN20Resp;
for i=1:size(Ligand_equivalence,1)
    CN20Resp_2.Ligand(strcmp(CN20Resp_2.Ligand,Ligand_equivalence{i,2})) = ...
        Ligand_equivalence(i,1);
end

%%

CommonLig = intersect(CN20Resp_2.Ligand, LigRespFC.Ligand);
CommonLig = setdiff(CommonLig,'IGF2');
CommonCL = intersect(CN20Resp_2.CellLine, LigRespFC.CellLine);
CommonTP = 30;
CommonConc = 100;


%%

CNinter = join(CN20Resp_2(CN20Resp_2.TimePoint==CommonTP & ...
    CN20Resp_2.Concentration==CommonConc & strcmp(CN20Resp_2.Target,'pAkt'),:), ...
    LigResp_av, 'keys', {'CellLine', 'Ligand'},'Type','inner',...
   'MergeKeys',true);
CNinter(1:10,:)
%%
[r,p] = corr(CNinter.FoldChange_left, CNinter.FoldChange_right,'type','spearman');
figure(202)
plot(CNinter.FoldChange_left, CNinter.FoldChange_right,'.k','markersize',14)
xlabel('CNI 2.0')
ylabel('CNI 1.0')
xlim([min([xlim ylim]) max([xlim ylim])])
ylim(xlim)
title(sprintf('Corr r=%.2f, p=%.2e', r, p));
%%

subCNI10 = LigResp_av( ismember(LigResp_av.Ligand, CommonLig), :);
[subCNI10_Mx, CL_CN10, Lig_CN10] = DatasetExtract(subCNI10, {'CellLine' 'Tissue'}, 'Ligand', 'FoldChange');

[normsubCN10, mu, sigma] = zscore(subCNI10_Mx);

[pcaxes, scores_CL, l] = princomp(normsubCN10);
disp(scores_CL(1:3,1:2) - normsubCN10(1:3,:)*pcaxes(:,1:2));

subCNI20 = CN20Resp_2( ismember(CN20Resp_2.Ligand, CommonLig) & CN20Resp_2.TimePoint==CommonTP & ...
    CN20Resp_2.Concentration==CommonConc & strcmp(CN20Resp_2.Target,'pAkt'), :);
[subCN20_Mx, CL_CN20, Lig_CN20] = DatasetExtract(subCNI20, {'CellLine' 'Tissue' 'SubType'}, 'Ligand', 'FoldChange');
scores_CN20 = ((subCN20_Mx -repmat(mu,size(subCN20_Mx,1),1))./repmat(sigma,size(subCN20_Mx,1),1) )...
    *pcaxes(:,1:2);

%%


figure(41);clf;
pos = [.05 .08 .7 .8];
axes('position',pos)
hold on

h = [];
for i=1:length(Tissue_list)
    idx = find(strcmp(LigCellLabels.Tissue, Tissue_list{i}));
    k = convhull(scores_CL(idx,1), scores_CL(idx,2));
    h(i) = plot(scores_CL(idx(k),1), scores_CL(idx(k),2), '.-','color',Tissuecolors(i,:),...
        'linewidth',2,'markersize',20);
    plot(scores_CL(idx,1), scores_CL(idx,2), '.','color',Tissuecolors(i,:),...
        'markersize',20);    
end
i = find(strcmp(Tissue_list,'BREAST'));

BreastSubtype = unique(CL_CN20.SubType);
for i=1:length(BreastSubtype)
    idx = find(strcmp(CL_CN20.SubType,BreastSubtype{i}));
    
    k = convhull(scores_CN20(idx,1), scores_CN20(idx,2));
    plot(scores_CN20(idx(k),1), scores_CN20(idx(k),2), '.:','color', ...
        Tissuecolors(strcmp(Tissue_list,'BREAST'),:),'linewidth',1);
    
    plot(scores_CN20(idx,1), scores_CN20(idx,2), BreastSubtypeMarker(i),...
        'Markersize',BreastSubtypeMarkerSize(i),'color',Tissuecolors(strcmp(Tissue_list,'BREAST'),:));   
end

hl = legend(h, Tissue_list);
posl = get(hl,'position');
set(hl,'position',[pos(1)+pos(3)+.03 pos(2)+pos(4)-posl(4) posl(3:4)])

title(['PCA for ligand responses'], 'fontweight','bold','fontsize',10)
set(gca,'fontweight','bold','fontsize',8,'xtick',-1:1,'ytick',-1:1,'box','on')

set(gcf,'color','w','position',[50 50 750 500],'PaperUnits','centimeters',...
    'papersize',[22 15],'paperpositionmode','auto',...
    'filename','pca_LigResp_CN20.pdf')

%%

figure(141);clf
barh(pcaxes(:,1:2))
set(gca,'ytick',1:length(Lig_CN20),'yticklabel',Lig_CN20.Ligand, 'ydir', ...
    'reverse')
xlim([-.5 .9])

%% plot a few distributions based on the tissue type and the ligands

% Selected ligands

SelLig = {'EGF' 'IGF1' 'PDGFBB' 'HRG (CF)' 'HGF' 'NGFb'};
BreastST_list = unique(CN20Resp_2.SubType);

figure(43);clf
for i = 1:length(SelLig)
    subplot(2,3,i)
    hold on
    plot([0 0], [.5 length(Tissue_list)+length(BreastST_list)+1.5], '-c')
    
    for j=1:length(BreastST_list)
        idx = strcmp(CN20Resp_2.Ligand,SelLig{i}) & ...
            strcmp(CN20Resp_2.SubType,BreastST_list{j}) & CN20Resp_2.TimePoint==CommonTP & ...
            CN20Resp_2.Concentration==CommonConc & strcmp(CN20Resp_2.Target,'pAkt');
        val = CN20Resp_2.FoldChange(idx) .* CN20Resp_2.SignResp(idx);
        plot_hbox(j,val,'r');
    end
    idx = strcmp(CN20Resp_2.Ligand,SelLig{i}) & (CN20Resp_2.TimePoint==CommonTP) & ...
    (CN20Resp_2.Concentration==CommonConc) & strcmp(CN20Resp_2.Target,'pAkt');
    val = CN20Resp_2.FoldChange(idx) .* CN20Resp_2.SignResp(idx);
    plot_hbox(1+length(BreastST_list),val,'r');
        
    for j=1:length(Tissue_list)
        idx = strcmp(LigResp_av.Ligand,SelLig{i}) & ...
            strcmp(LigResp_av.Tissue,Tissue_list{j});
        val = LigResp_av.FoldChange(idx) .* (LigResp_av.pVal(idx)<.05);
        plot_hbox(length(BreastST_list)+j+1,val);
    end
    
    set(gca,'ytick',1:(length(Tissue_list)+length(BreastST_list)+1), 'yticklabel', ...
        [BreastST_list; {'Breast CN20'}; Tissue_list],'fontsize',8)
    ylim([.5 length(Tissue_list)+length(BreastST_list)+1.5])
    title(SelLig{i},'fontsize',10,'fontweight','bold')
    xlim([-1 2])
end


set(gcf,'color','w','position',[50 50 700 450],'PaperUnits','centimeters',...
    'papersize',[22 14],'paperpositionmode','auto',...
    'filename','../figures/selectedLigands_dist_CN20.pdf')



%% clustering of the ligand responses

assert(all(strcmp(Lig_CN10.Ligand,Lig_CN20.Ligand)))
allLig = Lig_CN10;
allLigResp = [subCNI10_Mx;subCN20_Mx];
temp = CL_CN20(:,'CellLine');
temp.Tissue = CL_CN20.SubType;
allCL = [CL_CN10;temp];

metricLig = 'correlation';
LigDist = pdist(allLigResp',metricLig);
metricCL = 'Spearman';
CLDist = pdist(allLigResp,metricCL);

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
imagesc(allLigResp(permCL,permLig),[-2 2]);
colormap(Plotting_parameters.cmapBrWGr)
set(gca,'xtick',[],'ytick',[],'box','on')


hc = colorbar;
set(hc,'position',[pos(1)+pos(3)+.05 pos(2)-.1 .01 .08],'fontsize',6)
ylabel(hc,'Fold-change','fontsize',8,'fontweight','bold')

axes('position',[pos(1) pos(2)-.021 pos(3) .02])
hold on
allLig = join(allLig,LigFam);

for i=1:length(LigFam_list)
    idx = find(strcmp(allLig.LigFam(permLig), LigFam_list{i}));
    if isempty(idx),continue,end
    h = bar([-2 -1 idx'], ones(1,length(idx)+2), 1);
    set(h, 'facecolor', Ligcolors(i,:),'edgecolor','none');    
end
ylim([0 1])
xlim([.5 length(permLig)+.5])
for i=1:length(permLig)
    text(i,-.2, [allLig.Ligand{permLig(i)} '-' ...
        allLig.LigFam{permLig(i)}], 'fontsize',8, 'rotation',270)
end
set(gca,'xtick',[],'ytick',[],'box','on')


axes('position',[pos(1)+pos(3)+.001 pos(2) .02 pos(4)])
hold on
for i=1:length(Tissue_list)
    idx = find(strcmp(allCL.Tissue(permCL), Tissue_list{i}));
    h = barh([-2 -1 idx'], ones(1,length(idx)+2), 1);
    set(h, 'facecolor', Tissuecolors(i,:),'edgecolor','none');    
end

for i=1:length(BreastSubtypes)
    idx = find(strcmp(allCL.Tissue(permCL), BreastSubtypes{i}));
    h = barh([-2 -1 idx'], 2*ones(1,length(idx)+2), 1);
    set(h, 'facecolor', ...
        min(1,Tissuecolors(strcmp(Tissue_list,'BREAST'),:)-(.7-i)*.3 ),...
        'edgecolor','none');    
end

xlim([0 2])
ylim([.5 length(permCL)+.501])
set(gca,'xtick',[],'ytick',1:length(permCL),'yticklabel', ...
    strcat(allCL.CellLine(permCL), '-',allCL.Tissue(permCL)),...
    'YAxisLocation','right','fontsize',8,'ydir','normal','box','on')



set(gcf,'color','w','position',[50 50 1000 700],'PaperUnits','centimeters',...
    'papersize',[29 23],'paperpositionmode','auto',...
    'filename','Clust_LigResp.pdf')

%%
clustergram(allLigResp, 'rowlabels', allCL.CellLine, 'columnlabels', ...
    allLig.Ligand, 'standardize', 0, 'RowPDist', metricCL, ...
    'ColumnPDist' , metricLig)