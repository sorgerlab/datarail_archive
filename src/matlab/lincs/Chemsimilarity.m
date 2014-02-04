function Chemsim = Chemsimilarity(drugs, drugs2, metric)
% [CMAPsim, CMAPrange, CMAPall] = CMAPsimilarity(drugs, drugs2)
%   drugs:  list of drugs either a dataset with 'FacilityID' or a list of HMSLids
%   [optional] drugs2: same as drugs, for rectangular matrix
%
%   Chemsim:    Chemical simlarity (median across cell lines)
%

global ChemSimReference
if isempty(ChemSimReference)
    import_ChemSim
end


if isa(drugs,'dataset')
    drugs = drugs.FacilityID;    
elseif ischar(drugs)
    drugs = {drugs};
end

% do the matching from the HMSL to the Chem matrix
[~,Chemidx1] = ismember(drugs, ChemSimReference.HMSLids);

if any(Chemidx1==0)
    temp = strcat(drugs(Chemidx1==0),'-')';
    fprintf('--> HMSLIDs not in Chem sim: -%s\n', horzcat(temp{:}))
end
    

% if two inputs are provided: rectangular matrix
if exist('drugs2','var') && ~isempty(drugs2)
    if isa(drugs2,'dataset')
        drugs2 = drugs2.FacilityID;        
    elseif ischar(drugs2)
        drugs2 = {drugs2};
    end
    [~,Chemidx2] = ismember(drugs2, ChemSimReference.HMSLids);
%     for i=find(Chemidx2>0)'
%         [~,Chemidx2(i)] = ismember(ChemSimHMSLids(Chemidx2(i),1), CMAPdrugs);
%     end
    if any(Chemidx2==0)
        temp = strcat(drugs2(Chemidx2==0),'-')';
        fprintf('--> HMSLIDs not in Chem sim: -%s\n', horzcat(temp{:}))
    end
else
    Chemidx2 = Chemidx1;
end


Chemsim = NaN(length(Chemidx1), length(Chemidx2));

if ~exist('metric','var') || strcmpi(metric,'Morgan')
    Chemsim(Chemidx1~=0, Chemidx2~=0) = ChemSimReference.Morgan(Chemidx1(Chemidx1~=0), Chemidx2(Chemidx2~=0));
elseif strcmpi(metric,'AtomPair')
    Chemsim(Chemidx1~=0, Chemidx2~=0) = ChemSimReference.AtomPair(Chemidx1(Chemidx1~=0), Chemidx2(Chemidx2~=0));
else
    error('Unknown chemical metric (use ''Morgan'' or ''AtomPair''');
end
