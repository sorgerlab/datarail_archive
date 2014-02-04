Initialization


%%


[CommonCL, idxB_CL, idxL_CL] = intersect(BasalCellLabels,LigCellLabels);

[r,p] = corr(BasalLevels2D(idxB_CL, :), LigResp_2D(idxL_CL, :), 'type','spearman');

get_newfigure(50)
imagesc(r.*(p<.01),[-1 1])
colormap(Plotting_parameters.cmapBR)

set(gca,'xtick',[],'ytick',1:length(BasalReadout),'yticklabel',BasalReadout.Readout,...
    'ydir','normal')
for i=1:length(LigLabels)
    text(i,.4,LigLabels.Ligand{i},'rotation',270,'fontsize',7)
end

%%

Ligand_Basal = {
    'EGF' 'EGFR'
    'EGF' 'pEGFR'
    'HRG (CF)' 'EGFR'
    'HRG (CF)' 'ErbB3'
    'HRG (CF)' 'ErbB2'
    'IGF1' 'IGF1R'
    'Ins' 'IGF1R'
    'PDGFBB' 'PDGFRa-R&D'
    'HGF' 'MET'
    'HGF' 'pMET'
    'EphA1' 'EphA2'
    'KGF' 'FGFR2'
    'KGF' 'FGFR3'
    'KGF' 'FGFR4'};

%
% intersection for each pair
cnt = 0;
idxAKT= find(strcmp(BasalReadout.Readout,'pAKT'));
disp(' ')
get_newfigure(51)
for iL = 1:length(Ligand_Basal)
    
    idxL = find(strcmp(LigLabels.Ligand,Ligand_Basal{iL,1}));
    idxB = find(strcmp(BasalReadout.Readout,Ligand_Basal{iL,2}));
    
    
    [CommonCL, idxB_CL, idxL_CL] = intersect(BasalCellLabels,LigCellLabels);
    
    
    
    valB = BasalLevels2D(idxB_CL, idxB);
    valAKT = BasalLevels2D(idxB_CL, idxAKT);
    
    valL = abs(LigResp_2D(idxL_CL, idxL)).*(LigResp_2D(idxL_CL, idxL)<.05);
    valL = (LigResp_2D(idxL_CL, idxL)).*(LigResp_2D(idxL_CL, idxL)<.05);
    valL = LigResp_2D(idxL_CL, idxL);
    
    [r,p] = corr(valB,valL,'type','spearman');
    [rAKT,pAKT] = corr(valAKT ,valL,'type','spearman');
    
    pEnrich = ranksum(valB(LigResp_2D(idxL_CL, idxL)<.05), valB(LigResp_2D(idxL_CL, idxL)>.05));
    pEnrichAKT = ranksum(valAKT(LigResp_2D(idxL_CL, idxL)<.05), valAKT(LigResp_2D(idxL_CL, idxL)>.05));
    
    fprintf('%-7s-%-10s resp: r=%5.2f, p=%5.3f, (w/pAKT r=%5.2f p=%5.3f)\n    Enrich p=%6.3f (pAKT p=%.3f)\n', ...
        Ligand_Basal{iL,1}, Ligand_Basal{iL,2}, r, p, rAKT, pAKT, pEnrich, pEnrichAKT);
    
    if p<.1 || pEnrich<.1
        cnt = cnt+1;
        subplot(2,2,cnt)
        hold on
        for i=1:length(Tissue_list)
            idx = strcmp(CommonCL.Tissue, Tissue_list{i});
            plot(BasalLevels2D(idxB_CL(idx), idxB), LigResp_2D(idxL_CL(idx), idxL), ...
                '.','color',Ligcolors(i,:),'markersize',15);
        end
        ylabel([Ligand_Basal{iL,1} ' response'])
        xlabel(['Basal ' Ligand_Basal{iL,2}])
        
    end
end

