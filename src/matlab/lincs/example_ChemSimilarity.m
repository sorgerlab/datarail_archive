Generate_Plotting_parameters
global Plotting_parameters
if ~exist('d_IC50','var')
    load ../data/TargetInfo_dataset.mat
end

% select the mTOR durgs with relatively good specificity (ratio<100)
mTOR_list = TargetQuery(d_IC50,'MTOR');
mTOR_list = mTOR_list(mTOR_list.RatioActivity<100,:);

Chemsim = Chemsimilarity(mTOR_list);

figure(31);clf;
metrics = {'Morgan' 'AtomPair'};
for i=1:2
    pos = [.06+(i-1)*.5 .15 .27 .75];
    Chemsim = Chemsimilarity(mTOR_list, [], metrics{i});
    [perm, h, hmap, hcbar, axs] = nice_dendrogram_heatmap(Chemsim, mTOR_list.CompoundNames, pos);    
    title(metrics{i});
end
colormap(Plotting_parameters.cmapRW(end:-1:1,:))

%%
% select the PI3K durgs with relatively good specificity (ratio<100)
mPK3_list = TargetQuery(d_IC50,'PK3C');
mPK3_list = unique(mPK3_list(mPK3_list.RatioActivity<100,{'FacilityID' 'CompoundNames'}));

% query the chemical similarity
% query the CMAP similarity
Chemsim = Chemsimilarity(mTOR_list,mPK3_list);

figure(32);clf
axes('position',[.32 .35 .65 .6]);
imagesc(Chemsim,[0 1])
set(gca,'ydir','normal','ytick',1:size(mTOR_list,1),'yticklabel',mTOR_list.CompoundNames, ...
    'fontsize',8,'fontweight','bold','xtick',[])
for i=1:size(mPK3_list,1)
    text(i,0, mPK3_list.CompoundNames{i}, 'fontsize',8,'fontweight','bold','rotation',90,...
        'horizontalalign','right')
end
colormap(Plotting_parameters.cmapRW(end:-1:1,:))
ylabel('mTOR durgs','fontsize',10)
annotation('textbox',[.43 .03 .3 .03], 'string', 'PI3K durgs','fontsize',10, ...
    'horizontalalign','center','edgecolor','none','fontweight','bold')