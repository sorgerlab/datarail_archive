function TarSim = Generate_TargetSimilarity(d_in)

Pathwaylayers = [2 3];

metrics = {'Jaccard' 'weighted'};
for i=Pathwaylayers
    metrics = [metrics {['JaccardPathway' num2str(i)] ['weightedPathway' num2str(i)]}];
    PathwayNames{Pathwaylayers==i} = ['Pathway_L' num2str(i)];
end

% check that pathways are present for all target
d_in = AddTargetPathway(d_in,Pathwaylayers);
alldrugs = unique(d_in.FacilityID);

TarSim = [];
TarSim.metricMap = containers.Map(metrics, 1:length(metrics));
TarSim.drugMap = containers.Map(alldrugs, 1:length(alldrugs));
TarSim.metrics = metrics;
TarSim.drugs = alldrugs;
TarSim.Sim = repmat(eye(length(alldrugs)),[1 1 length(metrics)]);

for iD1=1:length(alldrugs)
    d1 = d_in(strcmp(d_in.FacilityID, alldrugs{iD1}), ...
        [{'TARGETUNIPROT' 'RatioActivity'} PathwayNames]);
    
    for iD2=(iD1+1):length(alldrugs)
        d2 = d_in(strcmp(d_in.FacilityID, alldrugs{iD2}), ...
            [{'TARGETUNIPROT' 'RatioActivity'} PathwayNames]);
        
        Targets = union(d1.TARGETUNIPROT, d2.TARGETUNIPROT);
        weights = zeros(length(Targets),2);
        [~,idx1] = ismember(d1.TARGETUNIPROT,Targets);
        [~,idx2] = ismember(d2.TARGETUNIPROT,Targets);
        
        weights(idx1,1) = 1./(1+log10(d1.RatioActivity));
        weights(idx2,2) = 1./(1+log10(d2.RatioActivity));
        
        % weighted Jaccard similarity 
        iM = TarSim.metricMap('weighted');
        TarSim.Sim(iD1,iD2,iM) = sum(prod(weights,2))/(sum(sum(weights.^2))-sum(prod(weights,2)));
        TarSim.Sim(iD2,iD1,iM) = TarSim.Sim(iD1,iD2,iM);
        
        % Jaccard similarity 
        iM = TarSim.metricMap('Jaccard');
        TarSim.Sim(iD1,iD2,iM) = length(intersect(idx1, idx2))/length(Targets);      
        TarSim.Sim(iD2,iD1,iM) = TarSim.Sim(iD1,iD2,iM);  
        
        % pathway similarities
        for iP = 1:length(Pathwaylayers)
            filter = [{0 @min} num2cell(zeros(1,length(Pathwaylayers)))];
            filter{iP+2} = 1;
            Path1 = Dataset_stats(d1,filter);
            Path2 = Dataset_stats(d2,filter);
            
            Paths = union(Path1.(PathwayNames{iP}), Path2.(PathwayNames{iP}));
            weights = zeros(length(Paths),2);
            [~,idx1] = ismember(Path1.(PathwayNames{iP}),Paths);
            [~,idx2] = ismember(Path2.(PathwayNames{iP}),Paths);
            
            weights(idx1,1) = 1./(1+log10(Path1.RatioActivity));
            weights(idx2,2) = 1./(1+log10(Path2.RatioActivity));
            
            % weighted Jaccard similarity based on pathway
            iM = TarSim.metricMap(['weightedPathway' num2str(Pathwaylayers(iP))]);
            TarSim.Sim(iD1,iD2,iM) = sum(prod(weights,2))/(sum(sum(weights.^2))-sum(prod(weights,2)));
            TarSim.Sim(iD2,iD1,iM) = TarSim.Sim(iD1,iD2,iM);
        
            % Jaccard similarity based on pathway
            iM = TarSim.metricMap(['JaccardPathway' num2str(Pathwaylayers(iP))]);
            TarSim.Sim(iD1,iD2,iM) = length(intersect(idx1, idx2))/length(Paths);
            TarSim.Sim(iD2,iD1,iM) = TarSim.Sim(iD1,iD2,iM);
        end
    end
end
            
            