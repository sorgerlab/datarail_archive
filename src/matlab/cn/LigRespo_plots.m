if ~exist('LigResp_av','var')
    load CNI10_LigResp_Ave.mat
end


%% scatter plot comparing two ligand responses

Tissue_list = unique(LigResp_av.Tissue);

[~,TissueIdx] = ismember(LigResp_av.Tissue, Tissue_list);

figure(21);clf
scatter(LigResp_av.FoldChange(strcmp(LigResp_av.Ligand,'EGF')), ...
    LigResp_av.FoldChange(strcmp(LigResp_av.Ligand,'IGF1')), ...
    250, TissueIdx(strcmp(LigResp_av.Ligand,'EGF')),'.')

Ligand_list = unique(LigResp_av.Ligand);

%% plot a few distributions based on the tissue type and the ligands

test_ligands = {'EGF' 'HRG1b (ECD)' 'HGF' 'BTC' 'IGF1' 'PDGFAB' };

figure(22);clf
for i = 1:length(test_ligands)
    subplot(2,3,i)
    hold on
    plot([0 0], [.5 length(Tissue_list)+.5], '-c')
    for j=1:length(Tissue_list)
        idx = strcmp(LigResp_av.Ligand,test_ligands{i}) & ...
            strcmp(LigResp_av.Tissue,Tissue_list{j});
%         val = LigResp_av.FoldChange(idx);
        val = LigResp_av.FoldChange(idx) .* (LigResp_av.pVal(idx)<.05);
        plot_hbox(j,val);
    end
    set(gca,'ytick',1:length(Tissue_list), 'yticklabel', Tissue_list,'fontsize',8)
    ylim([.5 length(Tissue_list)+.5])
    title(test_ligands{i},'fontsize',10,'fontweight','bold')
    xlim([-1 2])
end



set(gcf,'color','w','position',[50 50 700 450],'PaperUnits','centimeters',...
    'papersize',[22 14],'paperpositionmode','auto',...
    'filename','../figures/selectedLigands_dist.pdf')

    