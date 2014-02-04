Initialization

%%

metricCL = 'correlation';
% metric = 'correlation';
CLDist = pdist(BasalLevels2D,metricCL);


figure(122);clf
MDS_CL = mdscale(CLDist,2,'criterion','stress');
% MDS_CL = tsne_d(squareform(CLDist));

hold on
distances = pdist(MDS_CL);
plot(CLDist,distances,'b.');
xlabel([metricCL ' distance']); ylabel('MDS Distances')
legend({'Distances' 'Disparities'},'Location','NW');
for i=1:7
    plot([0 1], [0 1]+.1*(i-3), 'k')
end

figure(32);clf;
pos = [.05 .08 .7 .8];
axes('position',pos)
hold on

h = [];
for i=1:length(Tissue_list)
    idx = find(strcmp(BasalCellLabels.Tissue, Tissue_list{i}));
    if length(idx)>2
        k = convhull(MDS_CL(idx,1), MDS_CL(idx,2));
    else
        k = 1:length(idx);
    end
    h(i) = plot(MDS_CL(idx(k),1), MDS_CL(idx(k),2), '.-','color',Tissuecolors(i,:),...
        'linewidth',2,'markersize',20);
    plot(MDS_CL(idx,1), MDS_CL(idx,2), '.','color',Tissuecolors(i,:),...
        'markersize',20);    
end

plot([.1 .1 .2 .2 .2 .4 .4]+.4, -[.6 .62 .62 .6 .62 .62 .6], 'k-')
text(.65, -.57, ['Approx. ' metricCL ' distance'],'fontsize',8,'horizontalalignment','center')
for i=[0 1 3]
    text(.5+.1*i, -.64, num2str(.1*i),'fontsize',6,'horizontalalignment','center')
end

hl = legend(h, Tissue_list);
posl = get(hl,'position');
set(hl,'position',[pos(1)+pos(3)+.03 pos(2)+pos(4)-posl(4) posl(3:4)])

title(['MDS projection, ' metricCL ' distance for ligand responses'], 'fontweight','bold','fontsize',10)
set(gca,'fontweight','bold','fontsize',8,'xtick',[],'ytick',[],'box','on')

set(gcf,'color','w','position',[50 50 750 500],'PaperUnits','centimeters',...
    'papersize',[22 15],'paperpositionmode','auto',...
    'filename','mds_LigResp_byCL.pdf')

%%

metricLig = 'correlation';
LigDist = pdist(BasalLevels2D',metricLig);


figure(123);clf
[MDS_Lig,stress,disparities] = mdscale(LigDist,2,'criterion','stress');

hold on
distances = pdist(MDS_Lig);
plot(LigDist,distances,'b.');
xlabel([metricLig ' distance']); ylabel('MDS Distances')
legend({'Distances' 'Disparities'},'Location','NW');
for i=1:7
    plot([0 1], [0 1]+.1*(i-3), 'k')
end

figure(33);clf
pos = [.05 .08 .7 .8];
axes('position',pos)
hold on
% Basalcolors = [max(0,jet(floor(.6*length(BasalFam_list))).^.6-.1);
%     gray(1+ceil(.4*length(BasalFam_list)))];
% Basalcolors = Basalcolors(1:(end-1),:);
h = [];
for i=1:length(BasalFam_list)
    idx = find(strcmp(BasalReadout.KinaseFam, BasalFam_list{i}));
    if length(idx)>2 && ~strcmp(BasalFam_list{i},'misc')
        k = convhull(MDS_Lig(idx,1), MDS_Lig(idx,2));
        h(i) = plot(MDS_Lig(idx(k),1), MDS_Lig(idx(k),2), '.-','color',Basalcolors(i,:),'linewidth',2,...
            'markersize',20);
    	plot(MDS_Lig(idx,1), MDS_Lig(idx,2), '.','color',Basalcolors(i,:),...
            'markersize',20);
    elseif  ~strcmp(BasalFam_list{i},'misc')        
    	h(i) = plot(MDS_Lig(idx,1), MDS_Lig(idx,2), '.-','color',Basalcolors(i,:),...
            'markersize',20,'linewidth',2);
    else
        h(i) = plot(MDS_Lig(idx,1), MDS_Lig(idx,2), '.','color',Basalcolors(i,:),...
            'markersize',20,'linewidth',2);
    end
end

plot([.1 .1 .2 .2 .2 .4 .4]+.2, -[.6 .62 .62 .6 .62 .62 .6], 'k-')
text(.45, -.56, ['Approx. ' metricLig ' distance'],'fontsize',8,'horizontalalignment','center')
for i=[0 1 3]
    text(.3+.1*i, -.65, num2str(.1*i),'fontsize',6,'horizontalalignment','center')
end


hl = legend(h, BasalFam_list);
posl = get(hl,'position');
set(hl,'position',[pos(1)+pos(3)+.03 pos(2)+pos(4)-posl(4) posl(3:4)])

title(['MDS projection, ' metricCL ' distance for ligand responses'], 'fontweight','bold','fontsize',10)
set(gca,'fontweight','bold','fontsize',8,'xtick',[],'ytick',[],'box','on')

set(gcf,'color','w','position',[50 50 750 500],'PaperUnits','centimeters',...
    'papersize',[22 15],'paperpositionmode','auto',...
    'filename','mds_LigResp_byLig.pdf')

