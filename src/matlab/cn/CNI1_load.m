data_path = [fileparts(mfilename('fullpath')) '/../datasets/CNI1/' ];

d1_original = dataset('XLSFile', [data_path 'CNI1.0 ligand responses COPY.xls'], 'Sheet', 'Expt1');
d2_original = dataset('XLSFile', [data_path 'CNI1.0 ligand responses COPY.xls'], 'Sheet', 'Expt2');

% issue with importing d1_original: found extra lines
d1_original = d1_original(~isnan(d1_original.AverageSignal),:);

% Add replicate columns to each dataset so we can merge them later.
d1 = [d1_original dataset(ones(size(d1_original, 1), 1), 'VarNames', {'replicate'})];
d2 = [d2_original dataset(2*ones(size(d2_original, 1), 1), 'VarNames', {'replicate'})];

ds = [d1; d2];


%%
% split the name into cell line and tissue type
cl_tissue = cellfun_dispatch(@regexp,ds(:,1),'--','split');
cl_tissue = cl_tissue(2:end);
cl_tissue = vertcat(cl_tissue{:});

LigResp = [ds dataset(cl_tissue(:,1), 'VarNames', {'Tissue'})];
LigResp.CellLine = cl_tissue(:,2);

save CNI10_LigResp.mat LigResp


%%

basal_file = '../datasets/CNI1/CNI1.0 receptor levels COPY.xls';
[~,sheets] = xlsfinfo(basal_file);
sheets = setdiff(sheets,'about');

% initialize the dataset
BasalLevels = dataset;

warning('off','stats:dataset:genvalidnames:ModifiedVarnames')
for iS = 1:length(sheets)   % loop through the different tissues (spreadsheets)
    db_original = dataset('XLSFile', basal_file, 'Sheet', sheets{iS});
    
    % clean the variables names
    db_original.Properties.VarNames = ReducName(db_original.Properties.VarNames,'_');
    % replace the numbers by a string
    if isnumeric(db_original.AssayRep)
        db_original.AssayRep = cellfun(@num2str,num2cell(db_original.AssayRep),'uniformoutput',0);
    end
    
    % filter the rows and columns
    db = db_original( strcmp(db_original.Units10,'pg/cell') & strcmp(db_original.Source,'Masterbank') & ...
        cellfun(@isempty,db_original.Drug2) & strcmp(db_original.Units,'%FBS') & ...
        strcmp(db_original.Drug1,'media') & strcmp(db_original.ExpNum,'CLP001'), ...
        {'CellLine' 'Mean' 'Readout' 'Source' 'BioRep' 'AssayRep'});
    % add the tissue
    db = [db dataset(repmat(upper(sheets(iS)),size(db,1),1),'VarName','Tissue')];
    BasalLevels = [BasalLevels; db];
end
BasalLevels.Mean = log10(BasalLevels.Mean);
warning('on','stats:dataset:genvalidnames:ModifiedVarnames')

save CN10_BasalLevels.mat BasalLevels


