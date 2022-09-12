%load('C:\Users\Joseph\Documents\ADHD SDRT\Coherence_Processed\Affected\986302\epoched\AACAP15_Config_1p25thr\986302-1dotMATCHNOMATCH-Correct1_CohValue')
%fb=2;
%ind=find(freqlist>= freq_bin(fb,1) & freqlist<=freq_bin(fb,2));
%alpha = mean(raw_coh{1,2}(ind,:));
freqnum = 1;
tasknum = 1;
chan1 = 'Frontal Cluster';
chan2 = 'Occipital Cluster';
ch1 = 1;%find(strcmp(BNCT.chanord.(BNCT.chanord.method).labels,chan1));
ch2 = 2;%find(strcmp(BNCT.chanord.(BNCT.chanord.method).labels,chan2));
if ch1>ch2
    ch1temp = ch1;
    ch1 = ch2;
    ch2 = ch1temp;
end
time_bin = [0 2000];
siglevel = 0.05;
analysisfile = 'SDRT_Config_0to2s_500ms_overlapping_intervals';
%{
for subject = 1:1:size(BNCT.raw,1)%length(raw)

    %FORM FILE NAME
    data_folder = BNCT.raw{subject,1};
    dataloc = BNCT.raw{subject,2};
    taskind = find(strcmp([BNCT.config.tasklistraw], BNCT.raw{subject,9}));
    if taskind == tasknum
        
  if strcmp(BNCT.cohtype,'mag')
    dataloc = strcat(dataloc(1:end-4),'_CohValue.mat');
  elseif strcmp(BNCT.cohtype,'mag_cluster')
    dataloc = strcat(dataloc(1:end-4),'_CohValue_Cluster.mat'); 
  else
    dataloc = strcat(dataloc(1:end-4),'_PhaseCohValue.mat');
  end

    dataloc = strcat(data_folder,'\',analysisfile,'\',dataloc);
    if exist(dataloc,'file')
        load(dataloc)
    else
       msgbox(sprintf('Unable to load file %s \n\nFile listed as processed in batch file but not found.',dataloc))
   %     msgbox('Coherence raster file not found for a file labeled as processed in batch file!');
    end

    try
        rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).coh{length(rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).coh)+1} = raw_coh;
        rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).freqlist{length(rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).freqlist)+1} = freqlist;
        rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).timelist{length(rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).timelist)+1} = timelist;
    catch
        rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).coh{1} = raw_coh;
        rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).freqlist{1} = freqlist;
        rawcoh.(BNCT.raw{subject,7}).(BNCT.config.tasklist{taskind}).timelist{1} = timelist;
    end
    end
    prog = horzcat(num2str(subject),'/',num2str(size(BNCT.raw,1)),' files loaded');
    disp(prog)
end
%}
for k = 1:1:size(BNCT.config.freqrangelistraw,1)
    freq_bin(k,1:2) = str2num(BNCT.config.freqrangelistraw{k});
end
cohdata = [];
cohavg = [];
colorVec = [1 0 0; 0 0 1];
for i = 1:size(BNCT.config.phenotypelistraw,1)
    cohdata= [];
    for n = 1:size(rawcoh.(BNCT.config.phenotypelistraw{i}).(BNCT.config.tasklist{tasknum}).coh,2)
        raw_coh = rawcoh.(BNCT.config.phenotypelistraw{i}).(BNCT.config.tasklist{tasknum}).coh{n};
        
        freqind=find(freqlist>= freq_bin(freqnum,1) & freqlist<=freq_bin(freqnum,2));
        timeind=find(timelist>= time_bin(1) & timelist<=time_bin(2));
        %alpha = mean(raw_coh{1,2}(ind,:));
        cohdata(n,:) = mean(raw_coh{ch1,ch2}(freqind,timeind));
    end
    figure(97)
    for m = 1:size(cohdata,1)
  %      plot(timelist(timeind)/1000,cohdata(m,:),'Color',colorVec(i,:));
        hold on      
    end
    coh.(BNCT.config.phenotypelistraw{i}) = cohdata;
    figure(98)
    plot(timelist(timeind)/1000,mean(cohdata),'Color',colorVec(i,:))
    cohavg(i,:) = mean(cohdata); 
    hold on

end

figure(97)
    %legend(BNCT.config.phenotypelistraw)
    ylim([0 1])
    xlabel('Time');
    ylabel('Coherence');
    title(horzcat('Average coherence between channels ',chan1,' and ',chan2,' for ',BNCT.config.tasklistraw{tasknum},' ', BNCT.config.freqlabellistraw{freqnum}));
close
    figure(98)
    legend(BNCT.config.phenotypelistraw)
    ylim([0 1])
    xlabel('Time');
    ylabel('Coherence');
    title(horzcat('Average coherence between channels ',chan1,' and ',chan2,' for ',BNCT.config.tasklistraw{tasknum},' ', BNCT.config.freqlabellistraw{freqnum}));
realtime = timelist(timeind)/1000;
for t = 1:size(timeind,2)
    
    [h,signif] = ttest2(coh.(BNCT.config.phenotypelistraw{1})(:,t),coh.(BNCT.config.phenotypelistraw{2})(:,t));
    data_comb = [coh.(BNCT.config.phenotypelistraw{1})(:,t);coh.(BNCT.config.phenotypelistraw{2})(:,t)];
    hold on
    if signif < siglevel
      %  plot(xt([t t]), [1 1]*max(data_comb(:))*1.05, '-k',  mean(xt([t t])), max(data_comb(:))*1.03, '*k')
        plot(realtime(t), [1 1]*max(max(cohavg(:)))*1.2, '-k',  realtime(t), max(max(cohavg(:)))*1.2, '*k')
    end
end
cohavg = cohavg';