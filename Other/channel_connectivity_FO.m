%r1 = {'FP1','F9','F7','F3','A1','T7','C3','P9','P7','P3','O1'};
%r2 = {'FP2','F4','F8','F10','C4','T8','A2','P4','P8','P10','O2'};
[num, txt, raw] = xlsread('C:\Users\Joseph\Dropbox\SDRT\Excel files\ADHD SDRT Behavioral Data_1196 removed for lowvhigh.xlsx')

r1 = {'MF'};
r2 = {'MO'};
if BNCT.clustering.method == 1
    chanlabels = BNCT.clustering.clusternames;
else
    chanlabels = BNCT.chanord.orig.labels;
end
for i = 1:length(r1)
    r1_n(i) = strmatch(r1{i},chanlabels);
end
for i = 1:length(r2)
    r2_n(i) = strmatch(r2{i},chanlabels);
end
bwreg=[];
total=[];
%
%Extract F-O coherence value
for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
    for task = 1:1:size(BNCT.config.tasklistraw,1)
        subjectdata = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}); 
        for sub = 1:size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}),2) 
            for freq = 1:1:2%size(BNCT.config.freqrangelistraw,1)
                for t = 1:1:size(BNCT.alldata,3)%size(BNCT.config.batch_timerange,1)
                    matrix = subjectdata{1,sub}(freq,t).matrix;

                    %total(pheno,task,sub,freq,t) = matrix(r1_n,r2_n); %total connections at threshold
                    total.(BNCT.config.phenotypelistraw{pheno}){task,freq}(sub,t) = matrix(r1_n,r2_n); 

                end
            end
        end
    end
end
%}
x=1;
    a = waitbar(0,'Plotting measures vs time...');
    timephrase = ' 500ms intervals';
    temptime = str2mat(BNCT.config.batch_timerange);
temptime = str2num(temptime);
medtimes = mean(temptime')';
siglevel = 0.05;
savefigs = 0;
showfigs = 0;
count = 1;
for task = 1:size(BNCT.config.tasklistraw,1)
    for freq = 1:2%size(BNCT.config.freqrangelistraw,1)
        h1 = figure('Name',horzcat('Fronto-Occipital Connectivity vs Time for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},timephrase),'units','normalized','outerposition',[0 0 1 1]);
        set(gcf, 'Color', 'w');

                data = [];
                data2 = [];
                for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                    for t = 1:1:size(BNCT.alldata,3)
                    data2{t,pheno} = squeeze(total(pheno,task,:,freq,t));
                    data(t,pheno) = mean(squeeze(total(pheno,task,:,freq,t)));
                    
                    end
                    pheno_names{1,pheno} = BNCT.config.phenotypelistraw{pheno};
                end
                for t = 1:1:size(BNCT.alldata,3)
                    [h,signif(t)] = ttest2(data2{t,1}(1:25),data2{t,2}(1:23));
                end
               % data = [];
                %Plot data
                subplot(1,1,1)
                h2 = subplot(1,1,1);
                %plot(medtimes,data(:,1),'color','red'); %CONTINUOUS TIME
                %hold on
                %plot(medtimes,data(:,2),'color','blue');
                %
                bar_handle = bar(data(1:size(BNCT.alldata,3),:)); 
                %Change these colors based on which group is affected, etc,
                %also multiple groups?
                if str2num(BNCT.config.condpositive) == 1
                    set(bar_handle(1),'FaceColor',[1,0,0]);
                    set(bar_handle(2),'FaceColor',[0,0,1]);
                else
                    set(bar_handle(2),'FaceColor',[1,0,0]);
                    set(bar_handle(1),'FaceColor',[0,0,1]);  
                end
                %}
                if size(BNCT.alldata,3) > 15
                    set(h2,'XTick',1:1:size(BNCT.alldata,3));
                end
               % set(h2,'XTickLabel',BNCT.config.batch_timerange','fontsize',6);
                set(h2,'XTickLabel',medtimes,'fontsize',6);
               % rotateXLabels(h2,45)
                %Set axis limits based on range of values
%                 title(horzcat('# of fronto-occipital connections between ',num2str(perc(p)),'% - ',num2str(perc(p+1)),'% percentile strength'))
                xlabel('Time'); ylabel('Mean Coherence');
                 try
                ylim([min(min(data))-0.1*mean(mean(data)), max(max(data))+0.1*mean(mean(data))]);
                catch
                    ylim([min(min(data))-0.1, max(max(data))+0.1]);
                end
                %
                %Mark significant data with *
                for t = 1:size(BNCT.alldata,3);%size(BNCT.config.batch_timerange,1)
                    yt = get(gca, 'YTick');
                    xt = linspace(1,size(BNCT.alldata,3),size(BNCT.alldata,3));
                    %xt = get(gca, 'XTick');
                    hold on
                    if signif(t) < siglevel
                        try
                        plot(xt([t t]), [1 1]*max(data(t,:))*1.05, '-k',  mean(xt([t t])), max(data(t,:))*1.03, '*k')
                        catch
                            x=1;
                        end
                        %     plot(medtimes([t t]), [1 1]*max(data(t,:))*1.05, '-k',  mean(medtimes([t t])), max(data(t,:))*1.03, '*k') %CONTINUOUS TIME
                    end
                    hold off
                end
                %}
            
            legend(pheno_names)
            subtitle(horzcat('Fronto-occipital connectivity vs Time for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},' (p < ',num2str(siglevel),' marked with *)',timephrase));
        
            %Save plots
            if savefigs == 1
                filename=horzcat('C:\Users\Joseph\Dropbox\','fronto-occipital_cluster_connectivity_231s_intervals','_',(BNCT.config.tasklistraw{task}),'_',BNCT.config.freqlabellistraw{freq},'_vs_time_',date,'.png');
                %print(filename,'-dpng');
                %saveas(gcf,filename,'png')
                export_fig(filename,'-nocrop','-zbuffer')
            end
            if showfigs ~= 1
                close(h1)
            end
            
            waitbar(count/(size(BNCT.config.freqrangelistraw,1)*size(BNCT.config.tasklist,1)),a);
            count = count+1;
            FO_coh_ADHD{task,freq} = [];
            FO_coh_TD{task,freq} = [];
            %make matrix of data for correlations
            for z = 1:size(data2,1)
                FO_coh_ADHD{task,freq} = [FO_coh_ADHD{task,freq} data2{z,1}]; 
                FO_coh_TD{task,freq} = [FO_coh_TD{task,freq} data2{z,2}];
            end
            FO_coh_TD{task,freq} = FO_coh_TD{task,freq}(1:26,:);
            %{
            if task == 1
                rawcols = [17 18];
            elseif task == 2
                rawcols = [21 22];
            elseif task == 3
                rawcols = [25 26];
            elseif task == 4
                rawcols = [29 30];
            end
            %}
            if task == 1
                rawcols = [43 44];
            elseif task == 2
                rawcols = [45 46];
            end
            %ADHD IQ, Acc, RT v FO Coh
            [RHO_ADHD{task,freq},p_ADHD{task,freq}] = partialcorr([cell2mat(raw(2:27,8)) cell2mat(raw(2:27,rawcols(1))) cell2mat(raw(2:27,rawcols(2)))],FO_coh_ADHD{task,freq},cell2mat(raw(2:27,6)));
            %(I,J)-th entry is the sample linear partial correlation between the I-th column in X and the J-th column in 
            %TD IQ, Acc, RT v FO Coh
            FO_coh_TD_temp = FO_coh_TD{task,freq};
            FO_coh_TD_temp(11,:) = [];
            FO_coh_TD_temp(9,:) = [];
            TD_age_temp = cell2mat(raw(28:51,6));

            [RHO_TD{task,freq},p_TD{task,freq}] = partialcorr([cell2mat(raw(28:51,8)) cell2mat(raw(28:51,rawcols(1))) cell2mat(raw(28:51,rawcols(2)))],FO_coh_TD_temp,TD_age_temp);
            
            %Group correlation IQ, Acc, RT v FO Coh
            group_coh = [FO_coh_ADHD{task,freq};FO_coh_TD_temp];
            group_age = [cell2mat(raw(2:27,6));TD_age_temp];
            [RHO_Group{task,freq},p_Group{task,freq}] = partialcorr([cell2mat(raw(2:51,8)) cell2mat(raw(2:51,rawcols(1))) cell2mat(raw(2:51,rawcols(2)))],group_coh,group_age);
            
            %ADHD Behavioral v FO Coh
            FO_coh_ADHD_temp = FO_coh_ADHD{task,freq};
            FO_coh_ADHD_temp(22,:) = [];
            FO_coh_ADHD_temp(15,:) = [];
            raw_temp = raw(2:27,33:42);
            raw_temp(22,:) = [];
            raw_temp(15,:) = [];
            raw_temp = cell2mat(raw_temp);
            ADHD_age_temp = cell2mat(raw(2:27,6));
            ADHD_age_temp(22,:) = [];
            ADHD_age_temp(15,:) = [];
            [RHO_behav_ADHD{task,freq},p_behav_ADHD{task,freq}] = partialcorr(raw_temp,FO_coh_ADHD_temp,ADHD_age_temp);
            
            tasklist = {'low','high'};
            
            %ADHD IQ, Acc, RT vs ERSP
            [RHO_ADHD_PERFORMANCEvERSP{task},p_ADHD_PERFORMANCEvERSP{task}] = partialcorr([cell2mat(raw(2:27,8)) cell2mat(raw(2:27,rawcols(1))) cell2mat(raw(2:27,rawcols(2)))],[erspdata.fz.affected.(tasklist{task}) erspdata.oz.affected.(tasklist{task})],cell2mat(raw(2:27,6)));
            
            %TD IQ, Acc, RT vs ERSP
            fz_TD_temp = erspdata.fz.controls.(tasklist{task}); 
            fz_TD_temp(11,:) = [];
            fz_TD_temp(9,:) = [];
            oz_TD_temp = erspdata.oz.controls.(tasklist{task});
            oz_TD_temp(11,:) = [];
            oz_TD_temp(9,:) = [];
            TD_age_temp = cell2mat(raw(28:51,6));
            [RHO_TD_PERFORMANCEvERSP{task},p_TD_PERFORMANCEvERSP{task}] = partialcorr([cell2mat(raw(28:51,8)) cell2mat(raw(28:51,rawcols(1))) cell2mat(raw(28:51,rawcols(2)))],[fz_TD_temp oz_TD_temp],TD_age_temp);
            
            
            %ADHD Behavioral v ERSP
            fz_ADHD_temp = erspdata.fz.affected.(tasklist{task});
            fz_ADHD_temp(22,:) = [];
            fz_ADHD_temp(15,:) = [];
            oz_ADHD_temp = erspdata.oz.affected.(tasklist{task});
            oz_ADHD_temp(22,:) = [];
            oz_ADHD_temp(15,:) = [];
            raw_temp = raw(2:27,33:42);
            raw_temp(22,:) = [];
            raw_temp(15,:) = [];
            raw_temp = cell2mat(raw_temp);
            ADHD_age_temp = cell2mat(raw(2:27,6));
            ADHD_age_temp(22,:) = [];
            ADHD_age_temp(15,:) = [];
            [RHO_ADHD_BehavioralvERSP{task},p_ADHD_BehavioralvERSP{task}] = partialcorr(raw_temp,[fz_ADHD_temp oz_ADHD_temp],ADHD_age_temp);
            
            if freq == 1
                fcols = [1 3];
            elseif freq == 2
                fcols = [4 6];
            elseif freq == 3
                fcols = [7 9];
            elseif freq == 4
                fcols = [10 12];
            end
            %ADHD FO Coh vs ERSP
            [RHO_ADHD_COHvERSP{task,freq},p_ADHD_COHvERSP{task,freq}] = partialcorr(FO_coh_ADHD{task,freq},[erspdata.fz.affected.(tasklist{task})(:,fcols(1):fcols(2)) erspdata.oz.affected.(tasklist{task})(:,fcols(1):fcols(2))],cell2mat(raw(2:27,6)));
            
            FO_coh_TD_temp = FO_coh_TD{task,freq};
            FO_coh_TD_temp(11,:) = [];
            FO_coh_TD_temp(9,:) = [];
            fz_TD_temp = erspdata.fz.controls.(tasklist{task})(:,fcols(1):fcols(2)); 
            fz_TD_temp(11,:) = [];
            fz_TD_temp(9,:) = [];
            oz_TD_temp = erspdata.oz.controls.(tasklist{task})(:,fcols(1):fcols(2));
            oz_TD_temp(11,:) = [];
            oz_TD_temp(9,:) = [];
            %TD FO Coh vs ERSP
            [RHO_TD_COHvERSP{task,freq},p_TD_COHvERSP{task,freq}] = partialcorr(FO_coh_TD_temp,[fz_TD_temp oz_TD_temp],TD_age_temp);
           
        
    end
end