%Overlapping time for each subject
%{
for task = 2:size(BNCT.config.tasklistraw,1)
    for freq = 2:size(BNCT.config.freqrangelistraw,1)
        for sub = 1:size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{g}).(BNCT.config.tasklist{task}),2);
        
            for g = 1:size(BNCT.config.phenotypelistraw,1)
                figure(g)
                hold on
                subplot(3,3,sub);
                farray = [];
                xiarray = [];
               % figure
                hold on
                col=hsv(size(BNCT.config.batch_timerange,1));
                
                    for t = 1:size(BNCT.config.batch_timerange,1)
                    data = BNCT.allmeasures.(BNCT.config.phenotypelistraw{g}).(BNCT.config.tasklist{task}){1,sub}(freq,t).matrix;
                    data2 = triu(data,1);
                    data3 = sort(data2(:),'ascend');
                    data4 = data3(data3~=0);
                    [f,xi]=ksdensity(data4);
                    plot(xi,f,'color',col(t,:))
                    farray(t,:) = f;
                    xiarray(t,:) = xi;
                %    title(horzcat('Coherence PDF for ',(BNCT.config.phenotypelistraw{g}),' ',(BNCT.config.tasklistraw{task}),' ', (BNCT.config.freqlabellistraw{freq}),', t = ',BNCT.config.batch_timerange{t}));
                    title(horzcat('Coherence PDF for subject ',num2str(sub),'(',(BNCT.config.phenotypelistraw{g}),')'));

                    end
                figure
                farray_mean = mean(farray);
                xiarray_mean = mean(xiarray);
                plot(xiarray_mean,farray_mean);
            end
        end
    end
end
%}
%Overlapping subjects for time
for task = 2:size(BNCT.config.tasklistraw,1)
    for freq = 2:size(BNCT.config.freqrangelistraw,1)
        c=1;
        for t = 1:8%size(BNCT.config.batch_timerange,1)
            for g = 1:size(BNCT.config.phenotypelistraw,1)
                figure(g)
                hold on
                subplot(4,4,c);
                farray = [];
                xiarray = [];
               % figure
                hold on
                col=hsv(size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{g}).(BNCT.config.tasklist{task}),2));
                
                    for sub = 1:size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{g}).(BNCT.config.tasklist{task}),2);
                    data = BNCT.allmeasures.(BNCT.config.phenotypelistraw{g}).(BNCT.config.tasklist{task}){1,sub}(freq,t).matrix;
                    data2 = triu(data,1);
                    data3 = sort(data2(:),'ascend');
                    data4 = data3(data3~=0);
                    [f,xi]=ksdensity(data4);
                    plot(xi,f,'color',col(sub,:))
                    farray(sub,:) = f;
                    xiarray(sub,:) = xi;
                    title(horzcat('Coherence PDF for ',(BNCT.config.phenotypelistraw{g}),' ',(BNCT.config.tasklistraw{task}),' ', (BNCT.config.freqlabellistraw{freq}),', t = ',BNCT.config.batch_timerange{t}));
                %    title(horzcat('Coherence PDF for subject ',num2str(sub),'(',(BNCT.config.phenotypelistraw{g}),')'));

                    end
                subplot(4,4,c+1)
                farray_mean = mean(farray);
                xiarray_mean = mean(xiarray);
                plot(xiarray_mean,farray_mean);
                
            end
            c=c+2;
        end
    end
end