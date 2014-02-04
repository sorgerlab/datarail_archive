function [CMAPsim, CMAPmax, CMAPrange, CMAPall] = CMAPsimilarity(drugs, drugs2)
% [CMAPsim, CMAPmax, CMAPrange, CMAPall] = CMAPsimilarity(drugs, drugs2)
%   drugs:  list of drugs either a dataset with 'FacilityID' or a list of HMSLids
%   [optional] drugs2: same as drugs, for rectangular matrix
%
%   CMAPsim:    CMAP simlarity (median across cell lines)
%   CMAPmax:    CMAP simlarity (maximum across cell lines)
%   CMAPrange:  CMAP range (max similarity - min similarity across cell lines)
%   CMAPall:    CMAP similarity for all cell lines (ordered as global
%                                               variables: CMAPcelllines)
%

global all_CMAPsim med_CMAPsim max_CMAPsim n_CMAPsim range_CMAPsim CMAPdrugs CMAPcelllines
if isempty(all_CMAPsim)
    % load the data and format the matrices
    import_CMAPsimilarity
end
if ~exist('BRD_HMSL_map','var')
    % load the mappign from BRD to HMSL ids
    temp = importdata('../data/HSML_BRD_drug_labels.txt');
    BRD_HMSL_map = cell(length(temp),3);
    for i=1:length(temp)
        BRD_HMSL_map(i,:) = regexp(temp{i},'\t','split');
    end
end


if isa(drugs,'dataset')
    drugs = drugs.FacilityID;
elseif ischar(drugs)
    drugs = {drugs};
end

% do the matching from the HMSL to the CMAP matrix
[~,BRDidx1] = ismember(drugs, BRD_HMSL_map(:,2));
for i=find(BRDidx1>0)'
    [~,BRDidx1(i)] = ismember(BRD_HMSL_map(BRDidx1(i),1), CMAPdrugs);
end

if any(BRDidx1==0)
    temp = strcat(drugs(BRDidx1==0),'-')';
    fprintf('--> HMSLIDs not in CMAP: -%s\n', horzcat(temp{:}))
end

% if two inputs are provided: rectangular matrix
if exist('drugs2','var')
    if isa(drugs2,'dataset')
        drugs2 = drugs2.FacilityID;
    elseif ischar(drugs2)
        drugs2 = {drugs2};
    end
    [~,BRDidx2] = ismember(drugs2, BRD_HMSL_map(:,2));
    for i=find(BRDidx2>0)'
        [~,BRDidx2(i)] = ismember(BRD_HMSL_map(BRDidx2(i),1), CMAPdrugs);
    end
    if any(BRDidx2==0)
        temp = strcat(drugs2(BRDidx2==0),'-')';
        fprintf('--> HMSLIDs not in CMAP: -%s\n', horzcat(temp{:}))
    end
else
    BRDidx2 = BRDidx1;
end

% assigning the matrices
CMAPsim = NaN(length(BRDidx1), length(BRDidx2));
CMAPsim(BRDidx1~=0, BRDidx2~=0) = med_CMAPsim(BRDidx1(BRDidx1~=0),BRDidx2(BRDidx2~=0));

CMAPmax = NaN(length(BRDidx1), length(BRDidx2));
CMAPmax(BRDidx1~=0, BRDidx2~=0) = max_CMAPsim(BRDidx1(BRDidx1~=0),BRDidx2(BRDidx2~=0));

CMAPrange = NaN(length(BRDidx1), length(BRDidx2));
CMAPrange(BRDidx1~=0, BRDidx2~=0) = range_CMAPsim(BRDidx1(BRDidx1~=0),BRDidx2(BRDidx2~=0));
CMAPall(BRDidx1~=0, BRDidx2~=0, :) = all_CMAPsim(BRDidx1(BRDidx1~=0),BRDidx2(BRDidx2~=0), :);