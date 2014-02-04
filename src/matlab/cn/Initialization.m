if ~exist('LigResp_av','var')
    load CNI10_LigResp_Ave.mat
    load CN10_BasalLevels.mat
    load CN20Resp.mat
end
addpath('m:/Work/MATLABlibrary/','d:/Harvard/MATLABlibrary/');
Generate_Plotting_parameters
global Plotting_parameters


LigFam = dataset('xlsfile','CNI1.0_Ligands_families.xlsx','ReadVarNames',0, ...
    'VarNames',{'Ligand','LigFam'});

LigFamLabels = join(LigLabels,LigFam);
LigFamLabels.Properties.ObsNames = {};

LigFam_list = unique(LigFamLabels.LigFam);
LigFam_list = LigFam_list([4 5 6 8 12 1 2 7 9 13 11 3 10 14]);
Tissue_list = unique(LigCellLabels.Tissue);
BasalFam_list = unique(BasalReadout.KinaseFam);
BasalFam_list = BasalFam_list([1 2 3 5 6 4 7]);

Ligcolors = [ % GF : blue to Purple
    0   0   .7
    .1  .1  1
    .4  .2  .8
    .8  .2  .8
    .5  .1  .5 % 5 GFs
    .4  .7  .4  % CC green
    .2  .4  .2  % CXC dark green
    ... cytokines : red to brown
    .8  0   0
    1   .1  .1
    .9  .3  .1
    .8  .7  .2 % 4 cytokines
    .2  .2  .2  % Eph, dark gray
    .5  .5   .5  % IntAg, mid gray
    .7  .7  .7  % misc; light gray
    ];
    
Basalcolors = [ % RTK : blue to Purple
    0   0   .7
    .1  .1  1
    .4  .2  .8
    .8  .2  .8
    .5  .1  .5 % 5 GFs
    .4  .7  .4  % signaling kinases
    .2  .4  .2  % misc
    ];

Tissuecolors = [Plotting_parameters.colors
    Plotting_parameters.SelectedGrays(3,:)];
Tissuecolors(6,:) = Plotting_parameters.Darkcolors(6,:);

BreastSubtypes = {'HER2amp' 'HR+' 'TNBC'};
BreastSubtypeMarker = '^so';
BreastSubtypeMarkerSize = [13 11 10]*.7;
