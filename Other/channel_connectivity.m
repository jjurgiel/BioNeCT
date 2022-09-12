%r1 = {'FP1','F9','F7','F3','A1','T7','C3','P9','P7','P3','O1'};
%r2 = {'FP2','F4','F8','F10','C4','T8','A2','P4','P8','P10','O2'};

perc = [0,25,50,75,100];
r1 = {'FP1','FPz','FP2'};
r2 = {'O1','Oz','O2'};

for i = 1:length(r1)
    r1_n(i) = strmatch(r1{i},BNCT.chanord.orig.labels);
end
for i = 1:length(r2)
    r2_n(i) = strmatch(r2{i},BNCT.chanord.orig.labels);
end
bwreg=[];
total=[];
%
for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
    for task = 1:1:size(BNCT.config.tasklistraw,1)
        subjectdata = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}); 
        for sub = 1:size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}),2) 
            for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
                for t = 1:1:size(BNCT.alldata,3)%size(BNCT.config.batch_timerange,1)
                    matrix = subjectdata{1,sub}(freq,t).matrix;
                    matrix = triu(matrix);
                    m = sort(matrix(:),'descend');
                    m = m(m~=0);
                    for p = 1:length(perc)-1
                        matrix2=matrix;
                        p1 = prctile(m,perc(p));
                        p2 = prctile(m,perc(p+1));
                        matrix2(matrix<p1)=0; %threshold
                        matrix2(matrix>p2)=0;
                        matrix3 = matrix2(r1_n,r2_n); %removes all other electrodes and within-region connections
                        bwreg(pheno,p,task,sub,freq,t) = nnz(matrix3); %# of connections between regions
                        total(pheno,p,task,sub,freq,t) = nnz(matrix2); %total connections at threshold
                        
                    end
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
savefigs = 1;
showfigs = 0;
count = 1;
for task = 1:size(BNCT.config.tasklistraw,1)
    for freq = 1:size(BNCT.config.freqrangelistraw,1)
        h1 = figure('Name',horzcat('Fronto-Occipital Connectivity vs Time for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},timephrase),'units','normalized','outerposition',[0 0 1 1]);
        set(gcf, 'Color', 'w');

            for p = 1:length(perc)-1
                data = [];
                data2 = [];
                for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                    for t = 1:1:size(BNCT.alldata,3)
                    data2{t}(:,pheno) = squeeze(bwreg(pheno,p,task,:,freq,t));
                    data(t,pheno) = mean(squeeze(bwreg(pheno,p,task,:,freq,t)));
                    
                    end
                    pheno_names{1,pheno} = BNCT.config.phenotypelistraw{pheno};
                end
                for t = 1:1:size(BNCT.alldata,3)
                    [h,signif(t)] = ttest2(data2{t}(:,1),data2{t}(:,2));
                end
               % data = [];
                %Plot data
                subplot(2,2,p)
                h2 = subplot(2,2,p);
                %plot(medtimes,data(:,1),'color','red'); %CONTINUOUS TIME
                %hold on
                %plot(medtimes,data(:,2),'color','blue');
                %
                bar_handle = bar(data(1:16,:)); 
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
                 title(horzcat('# of fronto-occipital connections between ',num2str(perc(p)),'% - ',num2str(perc(p+1)),'% percentile strength'))
                xlabel('Time'); ylabel('# of connections');
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
            end
            
            legend(pheno_names)
            subtitle(horzcat('Fronto-occipital connectivity vs Time for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},' (p < ',num2str(siglevel),' marked with *)',timephrase));
        
            %Save plots
            if savefigs == 1
                filename=horzcat('C:\Users\Joseph\Dropbox\','fronto-occipital_connectivity','_',(BNCT.config.tasklistraw{task}),'_',BNCT.config.freqlabellistraw{freq},'_vs_time_','.png');
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