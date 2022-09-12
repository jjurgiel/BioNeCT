function gui_measureplotting_local(BNCT,siglevel,savefigs,vstime,vstask,vsfreq,showfigs,fileinfo,channels)
[BNCT.graph_features_local] = gui_featurematrix_local;
[BNCT.graph_features_local_cluster] = gui_featurematrix_local_cluster;
if BNCT.clustering.method == 1
    cluster = 1;
    chlist = BNCT.clustering.clusternames;
    chsize = size(BNCT.clustering.clusternames,1);
    nummeas = size(BNCT.graph_features_local_cluster,1);
    measnames = BNCT.graph_features_local_cluster;
else
    cluster = 0;
    chlist = BNCT.chanord.(BNCT.chanord.method).labels(channels);
    chsize = size(channels,2);
    nummeas = size(BNCT.graph_features_local,1);
    measnames = BNCT.graph_features_local;
end
foldersuffix = fileinfo.foldersuffix;
filenamesuffix = fileinfo.filenamesuffix;
filenameappend = fileinfo.filenameappend;

temptime = str2mat(BNCT.config.batch_timerange);
temptime = str2num(temptime);
medtimes = mean(temptime')';
ylabels = {'Encoding','Maintenance','Retrieval'};

%% Order data vs time/freq/task and calculate significance
try
    
    for task = 1:1:size(BNCT.config.tasklistraw,1)
        for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
            for meas = 1:1:nummeas
                for t = 1:1:size(BNCT.alldata,3)
                    
                    meas_temp = [];
                    for ch = 1:chsize
                        for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                            
                            numsubjects = size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}),2);
                            subjectdata = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task});
                            
                            %Get mean values and organize
                            for sub = 1:1:numsubjects
                                if cluster == 1
                                    meas_temp(sub,pheno) = subjectdata{1,sub}(freq,t).(BNCT.graph_features_local_cluster{meas,3})(ch);
                                else
                                    meas_temp(sub,pheno) = subjectdata{1,sub}(freq,t).(BNCT.graph_features_local{meas,3})(channels(ch));
                                end
                            end
                            measx(:,t,pheno) = meas_temp(:,pheno);
                            meas_temp2 = sum(meas_temp(:,pheno)) / numsubjects;
                            
                            if cluster == 1
                                avg_measures_single_task_and_freq_vs_time.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local_cluster{meas,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})(t)= meas_temp2;
                                avg_measures_single_time_and_task_vs_freq{t}.(BNCT.config.tasklist{task}).(BNCT.graph_features_local_cluster{meas,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})(freq)= meas_temp2;
                                avg_measures_single_time_and_freq_vs_task{t}.(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local_cluster{meas,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})(task)= meas_temp2;
                            else
                                avg_measures_single_task_and_freq_vs_time.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local{meas,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})(t)= meas_temp2;
                                avg_measures_single_time_and_task_vs_freq{t}.(BNCT.config.tasklist{task}).(BNCT.graph_features_local{meas,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})(freq)= meas_temp2;
                                avg_measures_single_time_and_freq_vs_task{t}.(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local{meas,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})(task)= meas_temp2;
                                
                            end
                            
                            
                        end
                        %Need to change if > 2 groups, significance between all
                        %pairs - how to mark later?
                        if size(BNCT.config.phenotypelistraw,1)==2
                            %Remove zeros (for diff # subjects) from ttest arrays
                            data1 = meas_temp(:,1);
                            data2 = meas_temp(:,2);
                            data1 = data1(data1~=0);
                            data2 = data2(data2~=0);
                            %Test & store significance
                            try
                                [h,signif] = ttest2(data1,data2);
                            catch
                                signif = 1;
                            end
                            if cluster == 1
                                avg_measures_single_task_and_freq_vs_time.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local_cluster{meas,3}).significance.(chlist{ch})(t) = signif;
                                avg_measures_single_time_and_task_vs_freq{t}.(BNCT.config.tasklist{task}).(BNCT.graph_features_local_cluster{meas,3}).significance.(chlist{ch})(freq)= signif;
                                avg_measures_single_time_and_freq_vs_task{t}.(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local_cluster{meas,3}).significance.(chlist{ch})(task)= signif;
                                
                            else
                                avg_measures_single_task_and_freq_vs_time.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local{meas,3}).significance.(chlist{ch})(t) = signif;
                                avg_measures_single_time_and_task_vs_freq{t}.(BNCT.config.tasklist{task}).(BNCT.graph_features_local{meas,3}).significance.(chlist{ch})(freq)= signif;
                                avg_measures_single_time_and_freq_vs_task{t}.(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local{meas,3}).significance.(chlist{ch})(task)= signif;
                                
                            end
                            
                        end
                    end
                end
            end
        end
    end
catch
    x=1;
end
%% Measures in single task and freq vs time

if vstime==1
    a = waitbar(0,'Plotting measures vs time...');
    count = 1;
    for freq = 1:1:2%size(BNCT.config.freqrangelistraw,1)
        for task = 1:1:size(BNCT.config.tasklist,1)
            for i = 1:1:nummeas
                h1 = figure('Name',horzcat('Graph Measures vs Time for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},' - ',measnames{i,2}),'units','normalized','outerposition',[0 0 1 1]);
                set(gcf, 'Color', 'w');
                for t = 1:1:size(BNCT.alldata,3)
                    data = [];
                    for ch = 1:chsize
                        for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                            if cluster == 1
                                data(ch,pheno) = avg_measures_single_task_and_freq_vs_time.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local_cluster{i,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})(t);
                            else
                                data(ch,pheno) = avg_measures_single_task_and_freq_vs_time.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local{i,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})(t);
                            end
                            pheno_names{1,pheno} = BNCT.config.phenotypelistraw{pheno};
                        end
                    end
                    %Plot data
                    subplot(size(BNCT.alldata,3),1,t)
                    h2 = subplot(size(BNCT.alldata,3),1,t);
                    
                    bar_handle = bar(data(1:chsize,:));
                    %Change these colors based on which group is affected, etc,
                    if str2num(BNCT.config.condpositive) == 1
                        set(bar_handle(1),'FaceColor',[1,0,0]);
                        set(bar_handle(2),'FaceColor',[0,0,1]);
                    else
                        set(bar_handle(2),'FaceColor',[1,0,0]);
                        set(bar_handle(1),'FaceColor',[0,0,1]);
                    end
                    set(gca, 'XTick', 1:chsize, 'XTickLabel', chlist');
                    ylabel(ylabels{t});
                    % rotateXLabels(h2,45)
                    %Set axis limits based on range of values
                    if cluster == 1
                        title(BNCT.graph_features_local_cluster{i,2})
                    else
                        title(BNCT.graph_features_local{i,2})
                    end
                    try
                        ylim([min(min(data))-0.1*mean(mean(data)), max(max(data))+0.1*mean(mean(data))]);
                    catch
                        ylim([min(min(data))-0.1, max(max(data))+0.1]);
                    end
                    %
                    %Mark significant data with *
                    for ch = 1:chsize
                        yt = get(gca, 'YTick');
                        xt = linspace(1,chsize,chsize);
                        %xt = get(gca, 'XTick');
                        hold on
                        if cluster == 1
                            sigcomp = avg_measures_single_task_and_freq_vs_time.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local_cluster{i,3}).significance.(chlist{ch})(t);
                        else
                            sigcomp = avg_measures_single_task_and_freq_vs_time.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local{i,3}).significance.(chlist{ch})(t);
                        end
                        if sigcomp < siglevel
                            try
                                plot(xt([ch ch]), [1 1]*max(data(ch,:))*1.05, '-k',  mean(xt([ch ch])), max(data(ch,:))*1.03, '*k')
                            catch
                                x=1;
                            end
                            %     plot(medtimes([t t]), [1 1]*max(data(t,:))*1.05, '-k',  mean(medtimes([t t])), max(data(t,:))*1.03, '*k') %CONTINUOUS TIME
                        end
                        hold off
                    end
                    %}
                end
            
            
            legend(pheno_names)
            subtitle(horzcat('Graph Measures vs Time for ',measnames{i},', ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},' (p < ',num2str(siglevel),' marked with *)'));
            
            %Save plots
            if savefigs == 1
                filename=horzcat(foldersuffix,filenamesuffix,'_',(BNCT.config.tasklistraw{task}),'_',BNCT.config.freqlabellistraw{freq},'_vs_time_',measnames{i,2},'_',filenameappend,'.png');
                %print(filename,'-dpng');
                %saveas(gcf,filename,'png')
                export_fig(filename,'-nocrop','-zbuffer')
            end
            if showfigs ~= 1
                close(h1)
            end
            
            waitbar(count/(size(BNCT.config.freqrangelistraw,1)*size(BNCT.config.tasklist,1)),a);
            count = count+1;
        end
    end
end
close(a)
end

%% Measures in single time and freq vs task
%
if vstask == 1 
    a = waitbar(0,'Plotting measures vs task...');
    count = 1;
    for time = 1:1:size(BNCT.config.batch_timerange,1)
        for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
            for ch = 1:size(channels,2)
                h1 = figure('Name',horzcat('Graph Measures vs Task for ',chlist{ch},', ',BNCT.config.freqlabellistraw{freq},', for Time = ',BNCT.config.batch_timerange{time}),'units','normalized','outerposition',[0 0 1 1]);
                set(gcf, 'Color', 'w');
                %set(gcf, 'Renderer', 'painters');
                for i = 1:1:size(BNCT.graph_features_local,1)
                    data = [];
                    for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                        data(:,pheno) = avg_measures_single_time_and_freq_vs_task{1,time}.(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local{i,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})';
                        pheno_names{1,pheno} = BNCT.config.phenotypelistraw{pheno};
                    end
                    subplot(3,3,i)
                    h2 = subplot(3,3,i);
                    bar_handle = bar(data);
                    if str2num(BNCT.config.condpositive) == 1
                        set(bar_handle(1),'FaceColor',[1,0,0]);
                        set(bar_handle(2),'FaceColor',[0,0,1]);
                    else
                        set(bar_handle(2),'FaceColor',[1,0,0]);
                        set(bar_handle(1),'FaceColor',[0,0,1]);
                    end
                    title(BNCT.graph_features_local{i,2})
                    set(h2,'XTickLabel',BNCT.config.tasklistraw,'fontsize',7);
                    rotateXLabels(h2,45)
                    ylim([min(min(data))-0.1*mean(mean(data)), max(max(data))+0.1*mean(mean(data))]);
                    %
                    %Mark significant data with *
                    for task = 1:size(BNCT.config.tasklistraw,1)
                        yt = get(gca, 'YTick');
                        xt = get(gca, 'XTick');
                        hold on
                        if avg_measures_single_time_and_freq_vs_task{time}.(BNCT.config.freqlabellistraw{freq}).(BNCT.graph_features_local{i,3}).significance.(chlist{ch})(task) < siglevel
                            plot(xt([task task]), [1 1]*max(data(task,:))*1.05, '-k',  mean(xt([task task])), max(data(task,:))*1.03, '*k')
                        end
                        hold off
                    end
                    %}
                end
                %descr = horzcat('(p < ',siglevel,' marked with *)');
                %axes(h1);
                %ylims=get(gca,'YLim');
                %xlims=get(gca,'XLim');
                %text(5,0.1,'Outside top right corner',...
                %'VerticalAlignment','bottom',...
                %'HorizontalAlignment','left')
                %text(0.25,0.6,descr);
                legend(pheno_names)
                subtitle(horzcat('Graph Measures vs Task for ',chlist{ch},', ',BNCT.config.freqlabellistraw{freq},', for Time = ',BNCT.config.batch_timerange{time},' (p < ',num2str(siglevel),' marked with *)'));
                
                %Save plots
                if savefigs == 1
                    filename=horzcat(foldersuffix,filenamesuffix,'_',(BNCT.config.batch_timerange{time}),'_',BNCT.config.freqlabellistraw{freq},'_vs_task_',chlist{ch},'_',filenameappend,'.png');
                    export_fig(filename,'-nocrop','-zbuffer')
                end
                if showfigs ~= 1
                    close(h1)
                end
                waitbar(count/(size(BNCT.config.freqrangelistraw,1)*size(BNCT.config.batch_timerange,1)),a);
                count = count+1;
            end
        end
    end
    close(a)
end
%% Measures in single time and task vs freq

if vsfreq == 1
    a = waitbar(0,'Plotting measures vs frequency...');
    count = 1;
    for time = 1:1:size(BNCT.config.batch_timerange,1)
        for task = 1:1:size(BNCT.config.tasklist,1)
            for ch = 1:size(channels,2)
                h1 = figure('Name',horzcat('Graph Measures vs Frequency for ',chlist{ch},', ',BNCT.config.tasklistraw{task},', for Time = ',BNCT.config.batch_timerange{time}),'units','normalized','outerposition',[0 0 1 1]);
                set(gcf, 'Color', 'w');
                
                for i = 1:1:size(BNCT.graph_features_local,1)
                    data = [];
                    for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                        data(:,pheno) = avg_measures_single_time_and_task_vs_freq{1,time}.(BNCT.config.tasklist{task}).(BNCT.graph_features_local{i,3}).(BNCT.config.phenotypelistraw{pheno}).(chlist{ch})';
                        pheno_names{1,pheno} = BNCT.config.phenotypelistraw{pheno};
                    end
                    subplot(3,3,i)
                    h2 = subplot(3,3,i);
                    bar_handle = bar(data);
                    if str2num(BNCT.config.condpositive) == 1
                        set(bar_handle(1),'FaceColor',[1,0,0]);
                        set(bar_handle(2),'FaceColor',[0,0,1]);
                    else
                        set(bar_handle(2),'FaceColor',[1,0,0]);
                        set(bar_handle(1),'FaceColor',[0,0,1]);
                    end
                    title(BNCT.graph_features_local{i,2})
                    set(h2,'XTickLabel',BNCT.config.freqlabellistraw,'fontsize',7);
                    rotateXLabels(h2,45)
                    ylim([min(min(data))-0.1*mean(mean(data)), max(max(data))+0.1*mean(mean(data))]);
                    %
                    %Mark significant data with *
                    for freq = 1:size(BNCT.config.freqlabellistraw,1)
                        yt = get(gca, 'YTick');
                        xt = get(gca, 'XTick');
                        hold on
                        if avg_measures_single_time_and_task_vs_freq{time}.(BNCT.config.tasklist{task}).(BNCT.graph_features_local{i,3}).significance.(chlist{ch})(freq) < siglevel
                            plot(xt([freq freq]), [1 1]*max(data(freq,:))*1.05, '-k',  mean(xt([freq freq])), max(data(freq,:))*1.03, '*k')
                        end
                        hold off
                    end
                    %}
                end
                legend(pheno_names)
                subtitle(horzcat('Graph Measures vs Frequency for ',chlist{ch},', ',BNCT.config.tasklistraw{task},', for Time = ',BNCT.config.batch_timerange{time},' (p < ',num2str(siglevel),' marked with *)'));
                
                
                %Save plots
                if savefigs == 1
                    filename=horzcat(foldersuffix,filenamesuffix,'_',(BNCT.config.batch_timerange{time}),'_',BNCT.config.tasklistraw{task},'_vs_freq_',chlist{ch},'_',filenameappend,'.png');
                    export_fig(filename,'-nocrop','-zbuffer')
                end
                if showfigs ~= 1
                    close(h1)
                end
                waitbar(count/(size(BNCT.config.tasklist,1)*size(BNCT.config.batch_timerange,1)),a);
                count = count+1;
            end
        end
    end
    close(a)
end

