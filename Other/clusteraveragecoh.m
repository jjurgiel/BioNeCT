cluster{1} = [1 3 5 6 9];
cluster{2} = [12 13 14 16 18 19 20 21];
cluster{3} = [22 24 25 26];
%etc

for task = 1:1:size(BNCT.config.tasklistraw,1)
    for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
        for t = 1:1:size(BNCT.alldata,3)%size(BNCT.config.batch_timerange,1)

                for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                    numsubjects = size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}),2);
                    subjectdata = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task});    
                    regconn_temp = zeros(numsubjects,((size(cluster,2))^2 - size(cluster,2))/2);
                    %Get mean values and organize
                    for sub = 1:1:numsubjects
                        fullmatrix = subjectdata{1,sub}(freq,t).matrix;
                        
                        count = 1;
                        for i = 1:size(cluster,2)-1
                            for j = i+1:size(cluster,2)
                                newmat = fullmatrix(cluster{i},cluster{j});
                                newmat_avg = mean(mean(newmat));
                                regconn_temp(sub,count) = newmat_avg;
                                regioninfo{count} = horzcat('Cluster ',num2str(i),' to ',num2str(j));
                                count = count+1;
                            end
                        end
                    end
                    
                    regionalconnectivity.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.config.phenotypelistraw{pheno}){t}= regconn_temp;
                    regionalconnectivity.regioninfo = regioninfo;
                    end   
                
        end
    end
end