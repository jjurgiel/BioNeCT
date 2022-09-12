%function gui_clusterconnections(BNCT)
for task = 1:1:size(BNCT.config.tasklistraw,1)
    for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
        for t = 1:1:size(BNCT.config.batch_timerange,1)

                for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                meas_long = [];
                meas_short = [];             
                    numsubjects = size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}),2);
                    subjectdata = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task});    
                    
                    for sub = 1:1:numsubjects
                        meas_long(sub,:) = cell2mat(subjectdata{1,sub}(freq,t).connections.longrange);
                        meas_short(sub,:) = cell2mat(subjectdata{1,sub}(freq,t).connections.shortrange);
                    end
                    longrange.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}){t}= meas_long;
                    shortrange.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}){t}= meas_short;
                end   
        end
    end
end