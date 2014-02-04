
Generate_Plotting_parameters;global Plotting_parameters
if ~exist('CMAPdist','var')
    load ../data/CMAPdistCPCGold.mat
end
if ~exist('BRD_HMSL_map','var')
    temp = importdata('../data/HSML_BRD_drug_labels.txt');
    BRD_HMSL_map = cell(length(temp),3);
    for i=1:length(temp)
        BRD_HMSL_map(i,:) = regexp(temp{i},'\t','split');
    end
end

CLdrugs = cell(1,length(CLs));
for i=1:length(CLs)
    CLdrugs{i} = CMAPdist(i).durgs{:};
end

%%

[alldrugs,~,cnt] = unique(vertcat(CMAPdist(:).durgs));
cnt = hist(cnt,1:max(cnt));
alldrugs = alldrugs(cnt>2);

all_CMAPsim = NaN(length(alldrugs),length(alldrugs),length(CLs));

for i=1:length(CLs)
    [~,DRidx] = ismember(CMAPdist(i).durgs,alldrugs);
    Cidx = DRidx>0;
    DRidx = DRidx(DRidx>0);
    all_CMAPsim(DRidx,DRidx,i) = CMAPdist(i).matrix(Cidx,Cidx);
end

med_CMAPsim = nanmedian(all_CMAPsim,3);
mean_CMAPsim = nanmean(all_CMAPsim,3);
n_CMAPsim = sum(~isnan(all_CMAPsim),3);
range_CMAPsim = nanmax(all_CMAPsim,[],3) -nanmin(all_CMAPsim,[],3);

%%

if ~exist('Randcutoff','var')
    nRand = 2e3;
    r = rand(nRand,976);
    Randsim = 1-pdist(r,'spearman');
    Randcutoff = quantile(Randsim,[.025 .975]);
end



%%
figure(110);clf
subplot(131)
hist(med_CMAPsim(~isnan(med_CMAPsim) & eye(size(med_CMAPsim))==0),-1:.05:1)
title('Distribution median across cell lines','fontweight','bold')

subplot(132)
hist(mean_CMAPsim(~isnan(mean_CMAPsim) & eye(size(med_CMAPsim))==0),-1:.05:1)
title('Distribution mean across cell lines','fontweight','bold')

subplot(133)
hist(range_CMAPsim(~isnan(range_CMAPsim) & eye(size(med_CMAPsim))==0),0:.05:2)
title('Distribution range across cell lines','fontweight','bold')

figure(10);clf

axes('position',[.08 .15 .4 .8])
imagesc(med_CMAPsim,[-.03 1])
title('Median across cell lines','fontweight','bold')
hc = colorbar('location','southoutside');
set(hc,'position',[.18 .07 .2 .03],'fontsize',8)
xlabel(hc,'Spearman''s corr for CMAP')

axes('position',[.57 .15 .4 .8])
imagesc(range_CMAPsim,[0 1.2])
title('Range across cell lines','fontweight','bold')
hc = colorbar('location','southoutside');
set(hc,'position',[.67 .07 .2 .03],'fontsize',8)
xlabel(hc,'Range of Spearman''s corr')

cmap = Plotting_parameters.cmapWP;
colormap(cmap)
%%
cmap = Plotting_parameters.cmapBrWGr;

[~,idx] = ismember(alldrugs, BRD_HMSL_map(:,1));
DrugLabel = BRD_HMSL_map(idx,3);

pos = [.08 .1 .7 .8];
figure(11);clf

sim_CMAP = med_CMAPsim;
% sim_CMAP = mean_CMAPdist;

sim_CMAP2 = sim_CMAP;
sim_CMAP2(isnan(sim_CMAP2)) = 0;
sim_CMAP2((sim_CMAP2>Randcutoff(1)) & (sim_CMAP2<Randcutoff(2))) = 0;
axes('position',pos+[-.05 0 .05-pos(3) 0]);
Z = linkage(sim_CMAP2,'average');
[h,~,perm] = dendrogram(Z,0,'Orientation','left');
set(h,'color','k','linewidth',2)
xlim([0 2.55])
ylim([.5 length(alldrugs)+.5])
set(gca,'fontsize',8,'fontweight','bold','ytick',[])


axes('position',pos);
imagesc(sim_CMAP2(perm,perm),[-.9 .9]);

ylim([.5 length(alldrugs)+.5])
set(gca,'fontsize',6,'fontweight','bold','box','on','ydir','normal','ytick',...
    1:length(alldrugs), 'yticklabel', DrugLabel(perm),'YAxisLocation',...
    'right','xtick',[])

colormap(cmap)
h = colorbar('location','southoutside');
posh = get(h,'position');
set(h,'position', [pos(1)+.4*pos(3) pos(2)-.05 pos(3)*.2 .01],'xtick',-.5:.5:.5, ...
    'fontsize',8,'fontweight','bold')
xlabel(h,'median CMAP distance (Spearman)')

set(gcf,'color','w','position',[50 50 900 950],'PaperUnits','centimeters',...
    'papersize',[28 30],'paperpositionmode','auto', ...
    'filename','Alldrugs_CMAPdist.png')


figure(12);clf
range_CMAPdist2 = range_CMAPsim;
sim_CMAP2(isnan(sim_CMAP2)) = 0;

imagesc(range_CMAPsim(perm,perm),[0 1]);
set(gca,'fontsize',6,'fontweight','bold','box','on','ydir','normal','ytick',...
    1:length(alldrugs), 'yticklabel', DrugLabel(perm),'YAxisLocation',...
    'right','xtick',[])

cmap = Plotting_parameters.cmapWP;
colormap(cmap)
hc = colorbar('location','southoutside');
set(hc,'position',[.4 .05 .2 .01],'fontsize',8)
xlabel(hc,'Range of Spearman''s corr')


figure(13);clf
imagesc(n_CMAPsim(perm,perm),[0 5]);
set(gca,'fontsize',6,'fontweight','bold','box','on','ydir','normal','ytick',...
    1:length(alldrugs), 'yticklabel', DrugLabel(perm),'YAxisLocation',...
    'right','xtick',[])

cmap = Plotting_parameters.cmapWP;
colormap(cmap)
hc = colorbar('location','southoutside');
set(hc,'position',[.4 .05 .2 .01],'fontsize',8)
xlabel(hc,'# cell lines per pair')