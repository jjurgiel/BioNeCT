channel_list = {{'O1','Oz','O2'};{'F3','Fz','F4'}};
degree_all = [];
strength_all = [];
degree = [];
strength = [];
strength_clust = [];
degree_clust = [];
for i = 1:size(channel_list,1) %Each cluster
    for j = 1:size(channel_list{i},2) %Each electrode in cluster
        ch_loc = find(strcmp(BNCT.chanord.(BNCT.chanord.method).labels,channel_list{i}(j)));
        
        for task = 1:1:size(BNCT.config.tasklistraw,1)
            for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
                for t = 1:1:size(BNCT.config.batch_timerange,1)
                    
                    for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                        meas_deg = [];
                        meas_str = [];
                        numsubjects = size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}),2);
                        subjectdata = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task});
                        
                        for sub = 1:1:numsubjects
                            try
                            meas_deg(sub,1) = subjectdata{1,sub}(freq,t).degree(ch_loc);
                            meas_str(sub,1) = (subjectdata{1,sub}(freq,t).strength(ch_loc));%/(meas_deg(sub));
                            catch
                                x=1;
                            end
                        end
                        degree.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno})(:,t)= meas_deg;
                        strength.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno})(:,t)= meas_str;
                    end
                end
            end
        end
        
        degree_all{j} = degree;
        strength_all{j} = strength;
    end
    degree_clust = [];
    strength_clust = [];
    for task = 1:1:size(BNCT.config.tasklistraw,1)
        for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
            for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                for k=1:size(channel_list{i},2)
                    try
                        degree_clust.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}) = degree_clust.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}) + degree_all{1,k}.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno});
                        strength_clust.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}) = strength_clust.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}) + strength_all{1,k}.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno});                  
                    catch
                        degree_clust.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}) = degree_all{1,k}.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno});
                        strength_clust.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}) = strength_all{1,k}.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno});
                    end
                end
                
            end
        end
    end
    degree_avg{i} = degree_clust;
    strength_avg{i} = strength_clust;
end
x=1;