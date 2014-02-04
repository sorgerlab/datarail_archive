function d_out = AddTargetPathway(d_in,layer)
% d_out = AddTargetPathway(d_in,layer)
%   
%   d_in:   input dataset with a column 'TARGETUNIPROT'
%   layer:  [opt, default=2] pathway layer to add according to 'TargetReference'
%                                                  (see fct test_TargetFile)
%
%   d_out:  output dataset with additional column
%

global TargetReference
if isempty(TargetReference)
    test_TargetFile
    %%% could be rewritten as a hash table for efficiency
end
if ~exist('layer','var') || isempty(layer)
    layer=2;
end

% check in the variable was already assigned
LayerNames = cell(1,length(layer));
for j=1:length(layer)
    LayerNames{j} = ['Pathway_L' num2str(layer(j))];
end
idx = ~ismember(LayerNames, d_in.Properties.VarNames);
if all(~idx)
    d_out=d_in;
    fprintf('\t AddTargetPathway --> pathway already assigned\n')
    return
end
layer = layer(idx);
LayerNames = LayerNames(idx);


TargetPathway = cell(size(d_in,1),length(layer));
for i=1:length(TargetPathway)
    TargetIdx = find(strcmp(TargetReference.GENENAME,d_in.TARGETUNIPROT{i}));
    if isempty(TargetIdx)
        warning('Target %s not found!', d_in.TARGETUNIPROT{i})
        for j=1:length(layer)
            TargetPathway{i,j} = '';
        end
        continue
    end
    for j=1:length(layer)
        temp = unique(TargetReference(TargetIdx,layer(j)+1));
        if length(temp)>1
            warning('Multiple pathways found for %s!', d_in.TARGETUNIPROT{i})
        end
        TargetPathway{i,j} = temp{1,1};
    end
end
%%


d_out = [d_in mat2dataset(TargetPathway,'VarNames',LayerNames)];