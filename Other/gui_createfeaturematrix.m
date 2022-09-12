tasks = {'Low';'High'};
pheno = {'Affected';'Controls'};
%measures = {'clusteringcoeff';'efficglobal';'avgpath';'meancoherence';'radius';'diameter'};
%measures = {'nodeclusteringcoeff';'efficlocal';'eccentricity';'strength';'participationcoeff'};
measures={'avgcoh_O';'avgcoh_F'};
regions = [1];
rlabel= {'test'};
data= [];
for r =1:size(regions,2)
    for p = 1:size(pheno,1)
        for task = 1:size(tasks,1)
            c = 1;
            for f = 1:2
                for t = 1:3
                    for m = 1:size(measures,1)
                        for s = 1:size(BNCT.allmeasures.(pheno{p}).(tasks{task}),2)
                            data.(rlabel{r}).(pheno{p}).(tasks{task})(s,c) = BNCT.allmeasures.(pheno{p}).(tasks{task}){1,s}(f,t).(measures{m})(regions(r));
                        end
                        data.(rlabel{r}).(pheno{p}).labels.(tasks{task}){1,c} = horzcat((measures{m}),' t=',num2str(t),' f=',num2str(f),' task=',num2str(task), ' region=',rlabel{r});
                        c=c+1;
                        
                    end
                end
            end
        end
    end
end
data.IDS = BNCT.SubjectIDs;