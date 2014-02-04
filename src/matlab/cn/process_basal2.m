if ~exist('BasalLevels','var')
    load CN10_BasalLevels.mat
end


%% 

noninfmin = @(x) min(x(~isinf(x))) ;
[minvalue, Readout] = List_toHD(BasalLevels, 'Mean', 'Readout', noninfmin);
BasalLevels_noinf = BasalLevels;
for i=1:length(Readout{1})
    idx = strcmp(BasalLevels_noinf.Readout,Readout{1}.Readout{i}) & isinf(BasalLevels_noinf.Mean);
    BasalLevels_noinf.Mean(idx) = minvalue(i);
end

[fullBasalLevels2D, dim1, dim2] = DatasetExtract(BasalLevels_noinf,{'CellLine' 'Tissue'}, 'Readout', 'Mean', @mean);
% [fullBasalLevels2D, dims] = List_toHD(BasalLevels_noinf, 'Mean', {'CellLine', 'Readout'}, @mean);

%%
imagesc(isnan(fullBasalLevels2D))

set(gca,'ytick',1:length(dim1),'yticklabel',dim1.CellLine,'xtick',[],'fontsize',8)
for i=1:length(dim2)
    text(i,0,dim2.Readout{i},'rotation',90,'fontsize',8)
end
%%
Readidx = (sum(isnan(fullBasalLevels2D),1)<3) & ...
    ~ismember(dim2.Readout,{'BTC' 'HRG1beta'})';
CLidx = (sum(isnan(fullBasalLevels2D(:,Readidx)),2)<2) & ...
    ~strcmp(dim1.CellLine,'NCI/ADR-RES');

BasalLevels2D = fullBasalLevels2D(CLidx, Readidx);
BasalCellLabels = dim1(CLidx,:);
BasalCellLabels.CellLine = upper(ReducName(BasalCellLabels.CellLine,'- ')');
for i=1:length(BasalCellLabels.CellLine)
    if strcmp(BasalCellLabels.CellLine{i,1}(1:3),'NCI')
        BasalCellLabels.CellLine{i,1} = BasalCellLabels.CellLine{i,1}(4:end);
    end
end
BasalReadout = dim2(Readidx,:);
BasalFamily = cell(length(BasalReadout),1);
[~,txt] = xlsread('BasalMeasurements_families.xlsx');
for i=1:length(BasalReadout)
    idx = find(strcmp(BasalReadout.Readout{i},txt(:,1)));
    assert(length(idx)==1)
    BasalFamily{i} = txt{idx,2};
end
BasalReadout = [BasalReadout dataset(BasalFamily,'VarNames','KinaseFam')];

imagesc(BasalLevels2D)

set(gca,'ytick',1:length(BasalCellLabels),'yticklabel',BasalCellLabels.CellLine,'xtick',[],'fontsize',8)
for i=1:length(BasalReadout)
    text(i,0,BasalReadout.Readout{i},'rotation',90,'fontsize',8)
end
colormap hot

%
if ~exist('LigResp_av','var')
    load CNI10_LigResp_Ave.mat
end

for i=1:length(BasalCellLabels)
    idx = find(strcmp(BasalCellLabels.CellLine{i}, LigCellLabels.CellLine));
    if length(idx)==1
        if ~strcmp(BasalCellLabels.Tissue{i}, LigCellLabels{idx,2})
            fprintf('Mismatch tissue for %s: %s - %s\n', BasalCellLabels.CellLine{i}, ...
                BasalCellLabels.Tissue{i}, LigCellLabels{idx,2});
        end
    elseif length(idx)>2
        fprintf('Too many matches for %s\n', BasalCellLabels.CellLine{i});
    else
        fprintf('Not found: %s!\n', BasalCellLabels.CellLine{i});
    end
end


save CN10_BasalLevels.mat BasalCellLabels BasalLevels2D BasalReadout