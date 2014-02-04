if ~exist('d_IC50','var')
    load ../data/TargetInfo_dataset.mat
end

% display the drug-drug query for HMSL10097 (default: 10 durgs, sorted by
% target similarity)
figure(90);clf
DrugDrugQuery('HMSL10097');

% display the drug-drug query for Erlotinib sorted by chemical similarity 
% (default: 10 durgs)
figure(91);clf
DrugDrugQuery('Erlotinib',5);

% display the drug-drug query for BIBW2992 sorted by chemical similarity 
% (default: 10 durgs)
% using an alternative name -- only in very few databases
figure(92);clf
DrugDrugQuery('BIBW-2992',5);
%%
% display the drug-drug query for Torin1 15 durgs (default: sorted by
% target similarity)
figure(93);clf
DrugDrugQuery('Torin1',[],15);

% display the drug-drug query for HMSL10080 15 durgs (default: sorted by
% target similarity)
figure(94);clf
DrugDrugQuery('BEZ235',[],15);

%%

% display the drug-drug query for HMSL10080 (all suimilarities, top 5)
figure(95);clf
DrugDrugQuery('Torin1',0);

