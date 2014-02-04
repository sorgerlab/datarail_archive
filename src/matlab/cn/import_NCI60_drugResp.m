load('CNI10_LigResp_Ave.mat','LigCellLabels')
[num,txt,~] = xlsread('NCI60_drugResponse.xlsx');
%%
NCI60_drugs = cell2dataset(txt(2:end,1:2),'VarNames',{'LINCSID' 'DrugName'});
for i=1:length(NCI60_drugs)
    NCI60_drugs.DrugName{i} = NCI60_drugs.DrugName{i}(1:min(end,50));
end

NCI60_lines = txt(1,3:end);
for i=1:length(NCI60_lines)
    NCI60_lines{i} = ReducName(NCI60_lines{i}((find(NCI60_lines{i}==':',1,'first')+1):end));
    if length(NCI60_lines{i})>3 && all(NCI60_lines{i}(1:3)=='NCI')
        NCI60_lines{i} = NCI60_lines{i}(4:end);
    end
end
[NCI60_CL, NCI60idx] = intersect(NCI60_lines,LigCellLabels.CellLine);
disp(setdiff(LigCellLabels.CellLine, NCI60_lines));
NCI60_CellLabels = dataset(NCI60_CL','VarName','CellLine');

NCI60_DrugResp_2D = num(:,NCI60idx)';

NCI60_DrugResp = dataset(reshape(repmat(NCI60_CL,length(NCI60_drugs),1),[],1),...
    repmat(NCI60_drugs.LINCSID,length(NCI60_CL),1), repmat(NCI60_drugs.DrugName,length(NCI60_CL),1), ...
    reshape(num(:,NCI60idx),[],1),'VarNames',{'CellLine' 'LINCSID' 'DrugName' 'IC50'});

save NCI60DrugResp.mat NCI60_DrugResp NCI60_DrugResp_2D NCI60_CellLabels NCI60_drugs
