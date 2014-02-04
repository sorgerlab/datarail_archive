function [perm, h, hmap, hcbar, axs] = nice_dendrogram_heatmap(SimMap, Labels, pos)
% [perm, h, hmap, hcbar, axs] = nice_dendrogram_heatmap(SimMap, Labels, pos)
%       SimMap: similarity or distance matrix (square or output of pdist)
%       Labels: labels corresponding at each row/column in the SimMap
%       [optional] pos: position of the heatmap
%
%       perm: permutation on the heatmap
%       h, hmap, hcbar, axs: handles
%

Generate_Plotting_parameters
global Plotting_parameters

if ~exist('pos','var')
    pos = [.1 .15 .5 .8];
end
axs(1) = axes('position',pos+[-.05 0 .05-pos(3) 0]);

Z = linkage(SimMap,'average');
[h,~,perm] = dendrogram(Z,'Orientation','left');
set(h,'color','k','linewidth',2)

ylim([.5 length(Labels)+.5])
set(gca,'box','off','xtick',[])

axs(2) = axes('position',pos);
hmap = imagesc(SimMap(perm,perm),[0 1]);

ylim([.5 length(Labels)+.5])
set(axs(2),'fontsize',8,'fontweight','bold','box','on','ydir','normal','ytick',...
    1:length(Labels), 'yticklabel', Labels(perm),'YAxisLocation',...
    'right','xtick',[])

colormap(Plotting_parameters.cmapRW(end:-1:1,:))
hcbar = colorbar('location','south');
set(hcbar,'position',[pos(1)+.5*pos(3)-.1 pos(2)-.05 .2 .02],'fontsize',8,'fontweight','bold',...
    'XAxisLocation','bottom')
xlabel(hcbar,'Similarity','fontsize',10);