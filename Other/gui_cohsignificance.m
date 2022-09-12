%Might not be normal distribution?
%Maybe check skew/kurtosis?
pheno_aff = 1;
siglevel = 0.05;
n = size(BNCT.alldata,1);
filenameappend = horzcat('sigconnectivity_p05_',date);
savefigs = 0;
showfigs = 1;
foldersuffix = BNCT.configfilename.path;
filenamesuffix = strrep(BNCT.configfilename.file,'.mat',[]);
showlabels = 0;
%
temptime = str2mat(BNCT.config.batch_timerange);
temptime = str2num(temptime);
medtimes = mean(temptime')';
phases = {'Encoding', 'Maintenance', 'Retrieval'};
%
for task = 1:1:size(BNCT.config.tasklistraw,1)
    for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
        for t = 1:1:size(BNCT.config.batch_timerange,1)
            for ch1 = 1:1:n-1
                for ch2 = ch1+1:1:n
                coh_temp = [];
                for pheno = 1:1:size(BNCT.config.phenotypelistraw,1)
                    numsubjects = size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}),2);
                    subjectdata = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task});    
                    
                    %Get mean values and organize
                    for sub = 1:1:numsubjects                       
                        coh_temp(sub,pheno) = subjectdata{1,sub}(freq,t).nonthreshmatrix(ch1,ch2);
                    end
                    coh_avg(pheno) = sum(coh_temp(:,pheno)) / numsubjects;
                 
                end   
                 %Need to change if > 2 groups, significance between all
                 %pairs - how to mark later?
                    if size(BNCT.config.phenotypelistraw,1)==2
                        %Remove zeros (for diff # subjects) from ttest arrays
                        data1 = coh_temp(:,1);
                        data2 = coh_temp(:,2);
                        data1 = data1(data1~=0);
                        data2 = data2(data2~=0);
                        %Test & store significance
                        try
                        [h,signif] = ttest2(data1,data2);
                        catch
                            x=1;
                        end
                        coh_significance.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).significance{t}(ch1,ch2) = signif;
                        %Store which group has higher avg coherence
                        if coh_avg(1)>coh_avg(2)
                            pheno_high = 1;
                        else
                            pheno_high = 2;
                        end
                        coh_significance.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).groupavg{t}(ch1,ch2) = pheno_high;
                    
                    end
                end
            
            end
            coh_significance.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).significance{t}(ch2,ch2) = 0;
            %{
            if BNCT.clustering.method == 1
                matrix = coh_significance.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).significance{t};
                matrix(matrix>0.05) = 0;
                total_conn = nnz(matrix);
                %within-region & between region 1 and all regions
                for i = 1:size(BNCT.clustering.clusters,1)
                    r1 = BNCT.clustering.clusters{i};
                    r1_n = [];
                    for y = 1:size(BNCT.clustering.clusters{i},2)
                        r1_n(y) = strmatch(r1{y},BNCT.chanord.orig.labels);
                    end
                    
                    cmatrix1 = matrix(r1_n,r1_n);
                    cmatrix1 = triu(cmatrix1);
                    clusters.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).intraconn{t}(i) = nnz(cmatrix1);
                    cmatrix2 = triu(matrix);
                    cmatrix2 = cmatrix2(r1_n,:);
                    cmatrix2(:,r1_n) = 0;
                    cmatrix3 = triu(matrix);
                    cmatrix3 = cmatrix3(:,r1_n);
                    cmatrix3(r1_n,:) = 0;
                    
                    clusters.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).interconn_all{t}(i) = nnz(cmatrix2)+nnz(cmatrix3);
                    clusters.clusternames{i} = BNCT.clustering.clusternames{i};
                end
                for i = 1:size(BNCT.clustering.clusters,1)-1
                    for j = i+1:size(BNCT.clustering.clusters,1)
                        r1 = BNCT.clustering.clusters{i};
                        r2 = BNCT.clustering.clusters{j};
                        r1_n = [];
                        r2_n = [];
                        for y = 1:size(BNCT.clustering.clusters{i},2)
                            r1_n(y) = strmatch(r1{y},BNCT.chanord.orig.labels);
                        end
                        for y = 1:size(BNCT.clustering.clusters{j},2)
                            r2_n(y) = strmatch(r2{y},BNCT.chanord.orig.labels);
                        end
                        cmatrix2_t = triu(matrix);
                        cmatrix2 = cmatrix2_t(r1_n,r2_n);
                        cmatrix3 = cmatrix2_t(r2_n,r1_n);
                        clusters.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).interconn_bi{t}(i,j) = nnz(cmatrix2)+nnz(cmatrix3);
                        clusters.clusternames{i} = BNCT.clustering.clusternames{i};
                    end
                end
            else
            end
            %}
            
        end
    end
end
%}
%{
if BNCT.clustering.method == 1
    chlist = BNCT.clustering.clusternames;
    chsize = size(BNCT.clustering.clusternames,1);
    a = waitbar(0,'Plotting measures vs time...');
    count = 1;
    for freq = 1:1:size(BNCT.config.freqrangelistraw,1)
        for task = 1:1:size(BNCT.config.tasklist,1)
            h1 = figure('Name',horzcat('Significant Connections vs Time for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},timephrase),'units','normalized','outerposition',[0 0 1 1]);
            set(gcf, 'Color', 'w');
            for ch = 1:chsize
            data = [];
            for t = 1:1:size(BNCT.config.batch_timerange,1)    
                data(t) = clusters.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).interconn_all{t}(ch);
            end   
                %Plot data
                subplot(4,3,ch)
                h2 = subplot(4,3,ch);
                
                bar_handle = bar(data(1:16)); 
                %
                if size(BNCT.alldata,3) > 15
                    set(h2,'XTick',1:1:size(BNCT.alldata,3));
                end
               % set(h2,'XTickLabel',BNCT.config.batch_timerange','fontsize',6);
                set(h2,'XTickLabel',medtimes,'fontsize',6);
               % rotateXLabels(h2,45)
                %Set axis limits based on range of values

                 title(chlist{ch})

                try
                    ylim([min(min(data))-0.1*mean(mean(data)), max(max(data))+0.1*mean(mean(data))]);
                catch
                    ylim([min(min(data))-0.1, max(max(data))+0.1]);
                end

            
   
            end
            legend(pheno_names)
            subtitle(horzcat('Significant Connections vs Time for ',chlist{ch},', ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},' (p < ',num2str(siglevel),' marked with *)',timephrase));
        
            %Save plots
            if savefigs == 1
                filename=horzcat(foldersuffix,filenamesuffix,'_',(BNCT.config.tasklistraw{task}),'_',BNCT.config.freqlabellistraw{freq},'_vs_time_',chlist{ch},'_significance_',filenameappend,'.png');
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
    close(a)
end
%}
if BNCT.clustering.method == 1
    X_loc=[];Y_loc=[];Z_loc=[]; e_label=[]; phi_loc = [];theta_loc = [];r_loc=[]; clust_e_label = [];radius = [];
    for i=1:BNCT.EEG.nbchan
        a=BNCT.EEG.chanlocs(i);
        X_loc=[X_loc; BNCT.EEG.chanlocs(i).X];
        Y_loc=[Y_loc; BNCT.EEG.chanlocs(i).Y];
        Z_loc=[Z_loc; BNCT.EEG.chanlocs(i).Z];
        radius=[radius;BNCT.EEG.chanlocs(i).radius];
        e_label=[e_label {BNCT.EEG.chanlocs(i).labels}];
      %  [phi, theta, r] = cart2sph(BNCT.EEG.chanlocs(i).X,BNCT.EEG.chanlocs(i).Y,BNCT.EEG.chanlocs(i).Z);
     %    phi_loc = [phi_loc; theta*(180/pi)];
     %    theta_loc = [theta_loc;phi*(180/pi)];
     %    r_loc = [r_loc;r];
    end
    e_label = e_label(1:size(X_loc));
    e_label2 = e_label;
    for cnum = 1:size(BNCT.clustering.clusters,1)
        for enum = 1:size(BNCT.clustering.clusters{cnum},2)
            %Find index of cluster electrodes in list
            eindex{cnum}(enum) = find(strcmp(e_label2,BNCT.clustering.clusters{cnum}(enum)));
        end
        %Create clusterlocs variable to mimic EEG.chanlocs structure
        clusterlocs(1,cnum).labels = BNCT.clustering.clusternames{cnum};
        clusterlocs(1,cnum).X = mean(X_loc(eindex{cnum}));
        clusterlocs(1,cnum).Y = mean(Y_loc(eindex{cnum}))*-1;
        clusterlocs(1,cnum).Z = mean(Z_loc(eindex{cnum}));
        [phi, theta, r] = cart2sph(clusterlocs(1,cnum).X,clusterlocs(1,cnum).Y,clusterlocs(1,cnum).Z);
        clusterlocs(1,cnum).sph_phi = theta*(180/pi);
        clusterlocs(1,cnum).sph_theta = phi*(180/pi);
        clusterlocs(1,cnum).sph_radius = r;
        clusterlocs(1,cnum).theta = phi*(180/pi);
        clusterlocs(1,cnum).type = '';
        clusterlocs(1,cnum).ref = '';
        clusterlocs(1,cnum).urchan = [];
        clusterlocs(1,cnum).radius = mean(radius(eindex{cnum}));

        %cluster_data
    end
end
clusterlocs(1,3).radius = 0.01;
%figure
topoplot2([],clusterlocs,'electrodes','ptslabels');
1;
%% TOPOPLOTS
%
  a = waitbar(0,'Plotting significant coherence connections...');
  count = 1;
  %if BNCT.clustering.method == 1
  %    for k = 1:size(clusterlocs,2)
  %      locs_x(k) = clusterlocs(1,k).X;
  %      locs_y(k) = clusterlocs(1,k).Y;
  %    end
  %else
  locs_x = BNCT.chanord.(BNCT.chanord.method).locs(:,2);
  locs_y = BNCT.chanord.(BNCT.chanord.method).locs(:,1);
  %end

  for task = 1:1:size(BNCT.config.tasklist,1)
      for freq = 1:1:2%size(BNCT.config.freqrangelistraw,1)
          h1 = figure('Name',horzcat('Significant coherence connections for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task}),'units','normalized','outerposition',[.25 .25 .4 .65]);
          for t = 1:1:size(BNCT.config.batch_timerange,1)
              h2 = subplot(1,3,t);
              
              if showlabels == 1
                  if BNCT.clustering.method == 1
                      [x_elec,y_elec] = topoplot2([],clusterlocs,'electrodes','ptslabels');
                  else
                      [x_elec,y_elec] = topoplot2([],BNCT.EEG.chanlocs,'electrodes','ptslabels');
                  end
              else
                  if BNCT.clustering.method == 1
                      [x_elec,y_elec] = topoplot2([],clusterlocs);
                  else
                    [x_elec,y_elec] = topoplot2([],BNCT.EEG.chanlocs);
                  end
              end
              z_elec = ones(size(x_elec))*2.1;
              set(gcf, 'Color', 'w');
              
              title(phases{t})
  
              %Plot significant connections with pheno color (ask which group
              %is affected in gui that will be used?)
              for ch1 = 1:1:n-1
                  for ch2 = ch1+1:1:n
                      val = coh_significance.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).significance{t}(ch1,ch2);
                      if coh_significance.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).significance{t}(ch1,ch2) < siglevel
                          if coh_significance.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).groupavg{t}(ch1,ch2) == pheno_aff
                              colorval = 'red';
                          else
                              colorval = 'blue';
                          end
                          if BNCT.clustering.method == 1
                          line([y_elec(ch1) y_elec(ch2)],[x_elec(ch1) x_elec(ch2)],[z_elec(ch1) z_elec(ch2)],'Color',colorval,'Marker','.','LineStyle','-','LineWidth',1)
                          else
                          line([locs_y(ch1) locs_y(ch2)],[locs_x(ch1) locs_x(ch2)],[z_elec(ch1) z_elec(ch2)],'Color',colorval,'Marker','.','LineStyle','-','LineWidth',1)
                          end
                          end
                  end
              end
          end
          %
            %legend('ADHD','TD');
       %   hc = findobj(h5, '-property', 'FaceColor');
       %   set(hc(2),'Color',[0 1 0]);
       %   set(hc(1),'Color',[1 0 0]);
          subtitle(horzcat('Significant coherence connections for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},' (p < ',num2str(siglevel),')'));
          
          %Save plots
          if savefigs == 1
              filename=horzcat(foldersuffix,filenamesuffix,'_',(BNCT.config.tasklistraw{task}),'_',BNCT.config.freqlabellistraw{freq},'_',filenameappend,'.png');
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
      
    close(a)
 %}  

%%  BAR GRAPHS OF SIGNIFICANT CONNECTIONS
%Task/freq windows with time subplots of # of sig connections per region (x
%axis)
newmax  = 0;
    if BNCT.clustering.method == 1
        chlist = BNCT.clustering.clusternames;
        chsize = size(BNCT.clustering.clusternames,1);
        a = waitbar(0,'Plotting measures vs time...');
        count = 1;
        for freq = 1:1:2%size(BNCT.config.freqrangelistraw,1)
            for task = 1:1:size(BNCT.config.tasklist,1)
                h1 = figure('Name',horzcat('Significant Connections vs Time for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task}),'units','normalized','outerposition',[.25 .25 .4 .65]);
                set(gcf, 'Color', 'w');
                for t = 1:1:size(BNCT.config.batch_timerange,1)
                    data = [];
                    for ch = 1:chsize
                    
                        sigmat = triu(coh_significance.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).significance{1,t} < siglevel,1);
                        data(ch) = sum(sigmat(:,ch))+sum(sigmat(ch,:));
                        allmax = max(data);
                        if allmax > newmax
                            newmax = allmax;
                        end
         %               data(ch) = clusters.(BNCT.config.tasklist{task}).(BNCT.config.freqlabellistraw{freq}).interconn_all{t}(ch);
                    end
                    %Plot data
                    subplot(3,1,t)
                    h2 = subplot(3,1,t);
                    
                    bar_handle = bar(data(1:size(chlist,1)));
                    %
                    if size(chlist,1) > 15
                        set(h2,'XTick',1:1:size(chlist,1));
                    end
                    % set(h2,'XTickLabel',BNCT.config.batch_timerange','fontsize',6);
                    set(h2,'XTickLabel',chlist,'fontsize',6);
                %    set(h2,'XTickLabel',medtimes,'fontsize',6);
                    % rotateXLabels(h2,45)
                    %Set axis limits based on range of values
                    ylabel('Significant connections')
                    title(phases{t})
                    %{
                    try
                        ylim([min(min(data))-0.1*mean(mean(data)), max(max(data))+0.1*mean(mean(data))]);
                    catch
                        ylim([min(min(data))-0.1, max(max(data))+0.1]);
                    end
                    
                    %}
                    
                end
                for t=1:1:size(BNCT.config.batch_timerange,1)
                    subplot(3,1,t)
                    try
                        ylim([0, newmax]);
                    catch
                    end
                end
                %legend('ADHD','TD')
                subtitle(horzcat('Significant Connections for ',BNCT.config.freqlabellistraw{freq},', ',BNCT.config.tasklistraw{task},' (p < ',num2str(siglevel),' marked with *)',timephrase));
                
                %Save plots
                if savefigs == 1
                    filename=horzcat(foldersuffix,filenamesuffix,'_',(BNCT.config.tasklistraw{task}),'_',BNCT.config.freqlabellistraw{freq},'_vs_time_',chlist{ch},'_significance_bargraphs_',filenameappend,'.png');
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
        close(a)
    end
    %}