function d_out = TargetQuery(d_in, Target, cutoff, exact)
% d_out = TargetQuery(d_in, Target, cutoff, exact)
%
%   Target: - single target (string)
%           - list of targets (cell of string), defauilt using 'OR'
%           - list targets and criterion
%                   e.g.:  {'PK3CA' 'OR' PK3CB' 'AND' 'NOT' 'MTOR'}
%               kez workds are 'AND' 'OR' 'NOT'; AND/OR are evaluated
%               sequentially:  [ (PK3CA OR PKC3B) AND (NOT MTOR) ]
%
%   exact:  1 = exact match; 0 = partial match (default)
%
%   cutoff: cutoff for the Target (using RatioActivity)
%
%   e.g.: TargetQuery(d_IC50,'PK3') --> DAPK3, PK3CA, PK3CB, ...
%         TargetQuery(d_IC50,'PK3_') --> DAPK3, *PK3
%         TargetQuery(d_IC50,'PK3',1) --> null
%         TargetQuery(d_IC50,'PK3CA',1) --> PK3CA
%         TargetQuery(d_IC50,{'PK3CA' 'PK3CB'},1) --> PK3CA, PK3CB
%

if ~exist('exact','var')
    exact = false;
end
if ~exist('cutoff','var') || isempty(cutoff)
    cutoff = Inf;
end

Target = upper(Target);

if exact && isempty(strfind(Target,'_HUMAN'))
    Target = [Target '_HUMAN'];
end

if ~ischar(Target) && length(Target)>1
    if any(ismember({'OR' 'NOT' 'AND'}, Target))
        idx_OR = find(ismember(Target,{'OR'}));
        idx_NOT = find(ismember(Target,{'NOT'}));
        idx_AND = find(ismember(Target,{'AND'}));
        idx_AND_OR = find(ismember(Target,{'AND' 'OR'}));
        idx_target = find(~ismember(Target,{'AND' 'NOT' 'OR'}));
        
        if length(cutoff)>1
            assert(length(cutoff)==length(idx_target))
        else
            cutoff = cutoff*ones(1,length(idx_target));
        end
        
        d_temp = cell(1,length(idx_target));
        for i=1:length(idx_target)
            d_temp{i} = TargetQuery(d_in, Target{idx_target(i)}, cutoff(i), exact);
        end
        
        Aidx = idx_target(idx_target<idx_AND_OR(1)); assert(length(Aidx)==1)
        A = d_temp{Aidx==idx_target};
        if any(idx_NOT==(Aidx-1)),A = setdiff(d_in,A);end
        Bidx = idx_target(find(idx_target>idx_AND_OR(1),1,'first'));
        B = d_temp{Bidx==idx_target};
        if any(idx_NOT==(Bidx-1)),B = setdiff(d_in,B);end
        if strcmp(Target(idx_AND_OR(1)),'OR')
            d_out = [A;B];
        else
            d_out = intersect_FacilityID(A,B);
        end
        
        for i=2:length(idx_AND_OR)
            Bidx = idx_target(find(idx_target>idx_AND_OR(i),1,'first'));
            B = d_temp{Bidx==idx_target};
            if any(idx_NOT==(Bidx-1)),B = setdiff_FacilityID(d_in,B);end
            if strcmp(Target(idx_AND_OR(i)),'OR')
                d_out = [d_out;B];
            else
                d_out = intersect_FacilityID(d_out,B);
            end
        end
        d_out = unique(TargetQuery(d_out, Target(idx_target)),{'FacilityID' 'TARGETUNIPROT'});
        d_out = sortrows(d_out,{ 'TARGETUNIPROT' 'ActivityConcentrationuM'});
        
    else % list of target; using 'OR'
        d_out = dataset;
        
        if length(cutoff)>1
            assert(length(cutoff)==length(Target))
        else
            cutoff = cutoff*ones(1,length(Target));
        end
        for i=1:length(Target)
            d_out = [d_out; TargetQuery(d_in, Target{i}, cutoff(i), exact)];
        end
        d_out = sortrows(d_out,{'TARGETUNIPROT' 'ActivityConcentrationuM'});
    end
else
    if exact
        d_out = d_in( strcmp(d_in.TARGETUNIPROT,Target),:);
    else
        d_out = d_in( ~cellfun(@isempty,strfind(d_in.TARGETUNIPROT,Target)),:);
    end
    d_out = d_out(d_out.RatioActivity<cutoff,:);
    d_out = sortrows(d_out,{'TARGETUNIPROT' 'ActivityConcentrationuM'});
end

end

function C = intersect_FacilityID(A,B)
[~,idxA,idxB] = intersect(A,B,'FacilityID');
C = sortrows([A(idxA,:);B(idxB,:)],{'FacilityID' 'TARGETUNIPROT'});
end

function C = setdiff_FacilityID(A,B)
C = sortrows(A(~ismember(A.FacilityID,B.FacilityID),:),{'FacilityID' 'TARGETUNIPROT'});
end
