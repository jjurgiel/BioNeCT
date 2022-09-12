pheno =1;
for task = 1:size(BNCT.config.tasklistraw,1)
    for freq = 1:size(BNCT.config.freqrangelistraw,1)
        for t = 1:size(BNCT.config.batch_timerange,1)
            for s=1:size(BNCT.SubjectIDs.ASD.Resting,1)
                for g = 1:size(BNCT.graph_features,1)
                    featurematrix{freq}(s,g) = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}){1,s}(freq,t).(BNCT.graph_features{g,3});
                end
            end
        end
    end
end
for g = 1:size(BNCT.graph_features,1)
    featurematrixlabels{g} = BNCT.graph_features{g,2};
end