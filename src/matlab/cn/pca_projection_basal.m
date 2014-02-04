Initialization
%%

figure(31);clf

[pcaxes, scores_CL, l] = princomp(LigResp_2D);
hold on
for i=1:length(Tissue_list)
    idx = strcmp(LigCellLabels.Tissue, Tissue_list{i});
    plot3(scores_CL(idx,1), scores_CL(idx,2), scores_CL(idx,3),'.-','color',Ligcolors(i,:),...
        'markersize',15);
end
%


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

hl = legend(h, Tissue_list);
posl = get(hl,'position');
set(hl,'position',[pos(1)+pos(3)+.03 pos(2)+pos(4)-posl(4) posl(3:4)])

title(['PCA for ligand responses'], 'fontweight','bold','fontsize',10)
set(gca,'fontweight','bold','fontsize',8,'xtick',[],'ytick',[],'box','on')

set(gcf,'color','w','position',[50 50 750 500],'PaperUnits','centimeters',...
    'papersize',[22 15],'paperpositionmode','auto',...
    'filename','pca_LigResp_byCL.pdf')

%%

[pcaxes, scores_Lig, l] = princomp(LigResp_2D');


figure(42);clf
pos = [.05 .08 .7 .8];
axes('position',pos)
hold on
% Ligcolors = [max(0,jet(floor(.6*length(LigFam_list))).^.6-.1);
%     gray(1+ceil(.4*length(LigFam_list)))];
% Ligcolors = Ligcolors(1:(end-1),:);
h = [];
for i=1:length(LigFam_list)
    idx = find(strcmp(LigFamLabels.LigFam, LigFam_list{i}));
    if length(idx)>2 && ~strcmp(LigFam_list{i},'misc')
        k = convhull(scores_Lig(idx,1), scores_Lig(idx,2));
        h(i) = plot(scores_Lig(idx(k),1), scores_Lig(idx(k),2), '.-','color',Ligcolors(i,:),'linewidth',2,...
            'markersize',20);
    	plot(scores_Lig(idx,1), scores_Lig(idx,2), '.','color',Ligcolors(i,:),...
            'markersize',20);
    elseif  ~strcmp(LigFam_list{i},'misc')        
    	h(i) = plot(scores_Lig(idx,1), scores_Lig(idx,2), '.-','color',Ligcolors(i,:),...
            'markersize',20,'linewidth',2);
    else
        h(i) = plot(scores_Lig(idx,1), scores_Lig(idx,2), '.','color',Ligcolors(i,:),...
            'markersize',20,'linewidth',2);
    end
end


hl = legend(h, LigFam_list);
posl = get(hl,'position');
set(hl,'position',[pos(1)+pos(3)+.03 pos(2)+pos(4)-posl(4) posl(3:4)])

title(['PCA for ligand responses'], 'fontweight','bold','fontsize',10)
set(gca,'fontweight','bold','fontsize',8,'xtick',[],'ytick',[],'box','on')

set(gcf,'color','w','position',[50 50 750 500],'PaperUnits','centimeters',...
    'papersize',[22 15],'paperpositionmode','auto',...
    'filename','pca_LigResp_byLig.pdf')
