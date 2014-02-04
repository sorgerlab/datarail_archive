function [allsim, FacilityID_ordered, DrugName_ordered] = DrugDrugQuery(drug_ref, OrderingSim, nmax)
% [allsim, FacilityID_ordered, DrugName_ordered] = DrugDrugQuery(drug_ref, OrderingSim, nmax)
%   found all the similarities with a drug (drug-drug query)
%
%   drug_ref:   the seeded drug for comparison; given either as as a string
%                   (HMSLid, drug name)
%               or can be a list of drugs (therefor OrderingSim and nmax
%                   are irrlevant)
%   OrderingSim: similarity used for finding the top drugs:
%                   - 1 [default]: target (IC50)
%                   - 2 : target (Kd)
%                   - 3 : JaccardPathway2
%                   - 4 : CMAP
%                   - 5 : chemical
%                   - 0 : top nmax of each similarity score
%   nmax:       number of drugs selected [default=10 or 5 if OrderingSim=0]
%
%
%   allsim:     all similarity scores ordered as [target IC50, target Kd,
%                               pathway, CMAP, Chemical]
%   FacilityID_ordered:     list of ordered HSMLids
%   DrugName_ordered:       list of ordered drug names
%


if ~exist('OrderingSim','var') || isempty(OrderingSim)
    OrderingSim = 1;
end
if ~exist('nmax','var') || isempty(nmax)
    if OrderingSim>0
        nmax = 10;
    else
        nmax = 5;
    end
end

global backgrd

if (isvector(drug_ref) && isnumeric(drug_ref)) || iscellstr(drug_ref)
    
    nmax = length(drug_ref);
    subset_drugs = cell(nmax,1);
    DrugName_ordered = subset_drugs;
    for i=1:nmax
        subset_drugs{i} = find_DrugID(drug_ref{i});
        DrugName_ordered{i} = backgrd.ID_nameMap(subset_drugs{i});
    end
    FacilityID_ordered = subset_drugs;
    
    
else
    drug_ref = find_DrugID(drug_ref);
    
    Tarsim = TargetSimilarity(drug_ref,backgrd.data.FacilityID);
    TarsimKd = TargetSimilarity(drug_ref,backgrd.data.FacilityID,[],'Kd');
    Pathsim = TargetSimilarity(drug_ref,backgrd.data.FacilityID,'JaccardPathway2');
    [CMAPsim, maxCMAPsim] = CMAPsimilarity(drug_ref,backgrd.data.FacilityID);
    Chemsim = Chemsimilarity(drug_ref,backgrd.data.FacilityID);
    allsim = [Tarsim; TarsimKd; Pathsim; CMAPsim; Chemsim]';
    allsim(isnan(allsim)) = -1;
    
    if OrderingSim~=0
        [~,order] = sort(allsim(:,OrderingSim),'descend');
    else
        [~,order1] = sort(allsim,'descend');
        [~,rank1] = sort(order1,'ascend');
        allranks = sum(rank1,2);
        [~,order2] = sort(allranks,'ascend');
        [~,rank2] = sort(order2,'ascend');
        
        [~,order] = sort(rank2 + 2*length(rank2)*all([rank1 rank2]>nmax,2),'ascend');
        nmax = sum(any([rank1 rank2]<=nmax,2));
    end
    allsim = allsim(order,:);
    allsim(allsim==-1) = NaN;
    allsim = [allsim(:,1:4) maxCMAPsim(order)' allsim(:,5)];
    
    FacilityID_ordered = backgrd.data.FacilityID(order);
    DrugName_ordered = backgrd.data.SMName(order);
    
    subset_drugs = FacilityID_ordered(1:nmax);
end

headers = {'HMSLids' 'Drugs' 'TarSim(IC)' 'TarSim(Kd)' 'PathSim(IC)' 'CMAP sim.' 'max' 'Chem sim.'};
output = sprintf('%-12s %-22s | %-11s| %-11s| %-11s| %-10s(%-6s)| %-10s|',headers{:});
subset_drugname = cell(nmax,1);
for i=1:nmax
    subset_drugname{i} = DrugName_ordered{i}(1:min(end,18));
    textdata = [ FacilityID_ordered(i) subset_drugname(i) ...
        transpose(cellfun_dispatch(@num2str,num2cell(allsim(i,:)),'%.3f')) ];
    output = [ output
        sprintf('%-12s %-22s | %-11s| %-11s| %-11s| %-10s(%-6s)| %-10s|',textdata{:})];
end
disp(output)

%%

pos=NaN(6,4);
for i=1:6
    pos(i,:) = [.08+mod(i-1,3)*.32 1.1-ceil(i/3)*.5 .2 .35];
end

annotation('textbox',pos(1,:)+[-.07 0 .12 0],'string',output,'fontsize',...
    9,'fontname','Arial Narrow','interpreter','none')

for i=1:5
    switch i
        case 1
            SimMx = TargetSimilarity(subset_drugs);
        case 2
            SimMx = TargetSimilarity(subset_drugs,[],[],'Kd');
        case 3
            SimMx = TargetSimilarity(subset_drugs,[],'JaccardPathway2');
        case 4
            SimMx = CMAPsimilarity(subset_drugs);
        case 5
            SimMx = Chemsimilarity(subset_drugs);
    end
    idx = false(length(subset_drugs),1);j=1;
    while all(~idx) && j<length(subset_drugs)
        idx = ~isnan(SimMx(:,j));
        j=j+1;
    end
    if isempty(idx),continue,end
    
    SimMx = SimMx(idx,idx);
    if i==4 % exception for CMAP distance
        SimMx(isnan(SimMx)) = -.1;
        SimMx(SimMx<-.1) = -.1;
    end
    [perm, h, hmap, hcbar, axs] = nice_dendrogram_heatmap(SimMx, ...
        subset_drugname(idx),pos(i+1,:));
    title(headers{i+2});
end



