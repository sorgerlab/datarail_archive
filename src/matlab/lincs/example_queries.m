if ~exist('d_IC50','var')
    load ../data/TargetInfo_dataset.mat
end

%% call by target

d_PK3C = TargetQuery(d_IC50,'PK3C');
% display
disp(d_PK3C)

disp(' ')
disp(' ------------------------------------------------------- ')
disp(' only one isoform ')
% only one isoform, top 10-fold drugs, exact match
d_PK3CA = TargetQuery(d_IC50,'PK3CA',10,1);
disp(d_PK3CA)

disp(' ')
disp(' ------------------------------------------------------- ')
disp(' sort by RatioActivity first, then IC50 value ')
% sort by RatioActivity first, then IC50 value
d_PK3CA_sorted = sortrows(d_PK3CA,{'RatioActivity' 'ActivityConcentrationuM'});
disp(d_PK3CA_sorted)

disp(' ')
disp(' ------------------------------------------------------- ')
disp(' display only certain columns ')
% display only certain columns:
disp(d_PK3CA_sorted(:,{'FacilityID' 'CompoundNames' 'RatioActivity' 'ActivityConcentrationuM'}))

disp(' ')
disp(' ------------------------------------------------------- ')
disp(' ')


disp(' ')
disp(' ------------------------------------------------------- ')
disp(' only one isoform ')
% only two isoforms
d_PK3CA = TargetQuery(d_IC50,{'PK3CA' 'PK3CB'});
% display only certain columns:
disp(d_PK3CA(:,{'FacilityID' 'CompoundNames' 'TARGETUNIPROT' 'RatioActivity' 'ActivityConcentrationuM'}))


%% more complex queries for the targets with cutoffs

disp(' ')
disp(' ------------------------------------------------------- ')
disp(' Conditional query, with cutoffs')
d_PK3CA = TargetQuery(d_IC50, {'PK3C' 'OR' 'ERBB' 'OR' 'EGFR' 'AND' 'NOT' 'MTOR'},[50 20 20 100]);
disp(d_PK3CA(:,[1 2 9 11]))

%% call by drug

d_Torin = DrugQuery(d_IC50,'Torin');
disp(d_Torin) % Torin1 and Torin2

disp(' ')
disp(' ------------------------------------------------------- ')
disp(' Torins , top target and target with Ratio<10')
d_Torin = DrugQuery(d_IC50,'Torin',1);
disp(d_Torin(:, {'CompoundNames' 'TARGETUNIPROT' 'ActivityConcentrationuM'} )) % display top target

d_Torin = DrugQuery(d_IC50,'Torin',10);
disp(d_Torin(:, {'CompoundNames' 'TARGETUNIPROT' 'ActivityConcentrationuM' 'RatioActivity'} )) 


disp(' ')
disp(' ------------------------------------------------------- ')
disp(' more specific : Torin2 only, target with Ratio<50')
% more specific
d_Torin2 = DrugQuery(d_IC50,'Torin2', 50);
disp(d_Torin2( :, [1 2 5 9 11])) % only Torin2

disp(' ')
disp(' ------------------------------------------------------- ')
disp(' could also query by HMSLid and specific columns')
% could also query by HMSLid:
d_Torin1 = DrugQuery(d_IC50,'HMSL10079', 100);
disp(d_Torin1( :, [1 2 5 9 11])) % only Torin1 specific columns and rows