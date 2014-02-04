if ~exist('LigResp','var')
    load CNI10_LigResp.mat
end

    
%% merge replicates; check for correlation before

[LigResp_replicates, temp_r, temp_c] = DatasetExtract(LigResp, 'replicate', '', 'AverageSignal');  %% quite slow as now!

r = corr(LigResp_replicates');
fprintf('\n-------------\nCorrelation between replicates = %.3f\n\n',r(1,2))

%% find the distribution for the lowest values

xi = -5:10:1000;
[f,xi] = ksdensity(LigResp.AverageSignal,xi,'width',20);

figure(11)
plot(xi,f)

setmin = 200;


%% check the controls (HSA)

ctrlidx = ~cellfun(@isempty,strfind(LigResp.Ligand, 'HSA'));
% check bias by plate
LigCellLabels = unique(LigResp.CellLine);
ReplicateIdx = unique(LigResp.replicate);


Ctrlvalues = cell(length(LigCellLabels), length(ReplicateIdx));
for iC=1:length(LigCellLabels)
    pvals = [];
    for iR=1:length(ReplicateIdx)
        Ctrlvalues{iC,iR} = LigResp.AverageSignal(strcmp(LigResp.CellLine, LigCellLabels{iC}) & ...
            LigResp.replicate==ReplicateIdx(iR) & ctrlidx);
        Ctrlvalues{iC,iR} = log10(max(Ctrlvalues{iC,iR},setmin)); % set minimal value, log10 transformed.
        for iR2 = 1:(iR-1)
            [~,pvals(end+1)] = ttest2(Ctrlvalues{iC,iR}, Ctrlvalues{iC,iR2});
        end
    end
    
    if any(pvals<.05)
        warning(sprintf('Significant difference for %s (p=%.3f)', LigCellLabels{iC}, min(pvals)))
        disp(horzcat(Ctrlvalues{iC,:})')
    end
end

%% 

Signal = LigResp.AverageSignal;     
Signal(Signal<setmin) = setmin;     % set minimal value for 'below threshold'
FCdata = NaN(size(Signal));         % fold-change data (log10 transformed, ctrl subtracted)
pval = NaN(size(Signal));      % significance response: p<0.01, ttest against control
CorrespControl = NaN(size(Signal)); % control corresponding to the measured value
for iC=1:length(LigCellLabels)
    idxC = strcmp(LigResp.CellLine, LigCellLabels{iC});
    for iR=1:length(ReplicateIdx)
        idx = find(idxC & LigResp.replicate==ReplicateIdx(iR));
        CorrespControl(idx) = trimmean(Ctrlvalues{iC,iR},50);    % 50% trimmed mean of control subtraction
        FCdata(idx) = log10(Signal(idx)) - CorrespControl(idx);
        for i=1:length(idx)
            [~,pval(idx(i))] = ttest(Ctrlvalues{iC,iR}, log10(Signal(idx(i))));
        end
    end
%     disp([pval(idx)<.01 log10(Signal(idx)) FCdata(idx) CorrespControl(idx) pval(idx)])
%     pause
end
%%

LigRespFC = LigResp; % new dataset with fold-change
LigRespFC.Properties.VarNames{strcmp(LigRespFC.Properties.VarNames, 'AverageSignal')} = ...
    'Rawdata';
LigRespFC = [LigRespFC mat2dataset([FCdata pval CorrespControl], 'VarNames', {'FoldChange' 'pVal' 'Ctrl'})];
LigRespFC(ctrlidx,:) = [];

%%
%
LigResp_av = grpstats(LigRespFC, {'CellLine', 'Ligand', 'Tissue'} ,'mean', ...
    'DataVars',{'Rawdata', 'replicate' 'FoldChange' 'pVal' 'Ctrl'});

% relabel the variables (remove 'mean')
for i=1:length(LigResp_av.Properties.VarNames)
    temp = LigResp_av.Properties.VarNames{i};
    temp = regexp(temp,'mean_','split');
    if length(temp)==2
        LigResp_av.Properties.VarNames{i} = temp{2};
    end
end

% sanity check and removal of obselete variables
assert(all(LigResp_av.replicate==1.5))
LigResp_av.replicate = [];
assert(all(LigResp_av.GroupCount==2))
LigResp_av.GroupCount = [];

% proper calculus of the p-values: Fisher's combined probability test
[LigResp_pval, cellLabels] = DatasetExtract(LigRespFC, {'CellLine', 'Ligand'}, 'replicate',  'pVal');  %% quite slow as now!
Xi2 = -2*sum(log(LigResp_pval),2);       
pval = 1-chi2cdf(Xi2, 2*size(LigResp_pval,2));
LigResp_CombpVal = [cellLabels dataset(pval,'VarName','pVal')];

LigResp_av.pVal = [];   % replace the mean p-value by the Fisher method
LigResp_av = join(LigResp_av, LigResp_CombpVal);
LigResp_av(1:10,:)




%%   Examples of calls for DatasetExtract

temp = LigResp_av(:,{'CellLine' 'Tissue'}); % example for using another dataset as input
temp.Properties.ObsNames = [];
[LigResp_2D, LigCellLabels, LigLabels] = DatasetExtract(LigResp_av, temp, 'Ligand', 'FoldChange'); 
LigResp_2Dpval = DatasetExtract(LigResp_av, temp, 'Ligand', 'pVal'); 

save CNI10_LigResp_Ave.mat LigResp_2D LigCellLabels LigLabels LigResp_av LigRespFC LigResp_2Dpval
%%
temp = dataset({'EGF' 'BTC'}', 'VarName', 'Ligand'); % example for using another dataset as input
LigResp_sub = DatasetExtract(LigResp_av, {'CellLine' 'Tissue'}, temp , 'FoldChange');
