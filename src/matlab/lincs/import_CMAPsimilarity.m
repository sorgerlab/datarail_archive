function import_CMAPsimilarity()


global all_CMAPsim med_CMAPsim n_CMAPsim range_CMAPsim CMAPdrugs CMAPcelllines max_CMAPsim
if isempty(all_CMAPsim)
    % load the data and format the matrices
    load ../data/CMAPdistCPCGold.mat
    CMAPcelllines = CLs;
    [CMAPdrugs,~,cnt] = unique(vertcat(CMAPdist(:).drugs));
    cnt = hist(cnt,1:max(cnt));
    CMAPdrugs = CMAPdrugs(cnt>2);
    
    all_CMAPsim = NaN(length(CMAPdrugs),length(CMAPdrugs),length(CLs));
    
    for i=1:length(CLs)
        [~,DRidx] = ismember(CMAPdist(i).drugs,CMAPdrugs);
        Cidx = DRidx>0;
        DRidx = DRidx(DRidx>0);
        all_CMAPsim(DRidx,DRidx,i) = CMAPdist(i).matrix(Cidx,Cidx);
    end
    
    med_CMAPsim = nanmedian(all_CMAPsim,3);
    max_CMAPsim = nanmax(all_CMAPsim,[],3);
    n_CMAPsim = sum(~isnan(all_CMAPsim),3);
    range_CMAPsim = nanmax(all_CMAPsim,[],3) -nanmin(all_CMAPsim,[],3);
end