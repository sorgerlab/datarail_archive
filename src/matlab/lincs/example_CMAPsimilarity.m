Generate_Plotting_parameters
global Plotting_parameters
if ~exist('d_IC50','var')
    load ../data/TargetInfo_dataset.mat
end

% select the mTOR durgs with relatively good specificity (ratio<100)
mTOR_list = TargetQuery(d_IC50,'MTOR');
% mTOR_list = mTOR_list(mTOR_list.RatioActivity<100,:);

% query the CMAP similarity
[CMAPsim, CMAPrange, CMAPall] = CMAPsimilarity(mTOR_list);
% filter the drugs that were not in the CMAP
CMAPIdx = ~isnan(CMAPsim(:,1));
mTOR_list_CMAP = mTOR_list(CMAPIdx,:);
CMAPsim = CMAPsim(CMAPIdx,CMAPIdx);

% define the lables for the plot
Drug_labels = cell(size(mTOR_list_CMAP,1),1);
for i=1:size(mTOR_list_CMAP,1)
    Drug_labels{i} = [mTOR_list_CMAP.FacilityID{i} ' - ' ...
        mTOR_list_CMAP.CompoundNames{i}(1:min(end,20))];
end

% do the nice plot
figure(30);clf
[perm, h,hmap, hcbar, axs] = nice_dendrogram_heatmap(CMAPsim, Drug_labels);
xlabel(hcbar, 'CMAP similarity');

%% plot for specific cell lines
global CMAPcelllines

% find the interesting cell lines
CLs = {'MCF7' 'PC3'};
[~,CLidx] = ismember(CLs,CMAPcelllines);

% do the nice plots
figure(31);clf
for iC=1:2
    % filter the drugs that were not in the CMAP
    CMAPIdx = ~isnan(CMAPall(:,1,CLidx(iC))) & ~all(CMAPall(:,1,CLidx(iC))==0,2);
    mTOR_list_CMAP = mTOR_list(CMAPIdx,:);
    CMAPsim2 = CMAPall(CMAPIdx,CMAPIdx,CLidx(iC));
    
    % define the lables for the plot
    Drug_labels = cell(size(mTOR_list_CMAP,1),1);
    for i=1:size(mTOR_list_CMAP,1)
        Drug_labels{i} = [mTOR_list_CMAP.FacilityID{i} ' - ' ...
            mTOR_list_CMAP.CompoundNames{i}(1:min(end,20))];
    end
        
    pos=[.08+(iC-1)*.5 .15 .27 .75];
    [perm, h,hmap, hcbar, axs] = nice_dendrogram_heatmap(CMAPsim2, Drug_labels,pos);
    xlabel(hcbar, 'CMAP similarity');
    title(CLs{iC},'fontsize',10)
end