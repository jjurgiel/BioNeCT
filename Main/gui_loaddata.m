function [alldata, raw, SubjectIDs, Missing, tasklist] = gui_loaddata(BNCT,batchfile,analysisfile,tasklistraw,phenotypelistraw,chanord)
[num, txt, raw] = xlsread(batchfile,1);
raw = raw(2:end,:);

tasklist = tasklistraw;
for a = 1:1:length(phenotypelistraw)
    sub.(phenotypelistraw{a})(1:length(tasklist)) = 1;
end
h = waitbar(0,'Loading Data...');
%% CREATE TASK VARIABLES/CHECK IF USER HAS INPUT APPROPRIATE VARIABLE NAMES
warn = 0;
for j = 1:1:length(tasklist)
    warncount = 0;
    while any(str2num(tasklist{j}(1)))
        tasklist{j} = circshift(tasklist{j},[1 -1]);
        warncount = warncount + 1;
        if warncount > length(tasklist{j})
            h = warndlg('Invalid task name. Task names cannot be entirely numerical.');
            warn = 1;
            break
        end
    end
    if warn == 1
        return
    end
end

%%                      CLEAN OUT UNPROCESSED ROWS OF DATA
for subject = size(raw,1):-1:1
    if isnan(raw{subject,4})
        %DELETE TRIAL
        raw(subject,:)=[];
    end
end
waitbar(.2,h);
%%              STORE RASTER DATA FOR ALL SUBJECTS
for subject = 1:1:size(raw,1)
    
    %FORM FILE NAME
    data_folder = raw{subject,1}; dataloc = raw{subject,2};
    switch BNCT.cohtype
        case 'magcoh'
            dataloc = strcat(dataloc(1:end-4),'_CohValueCS.mat');
        case 'phasecoh'
            dataloc = strcat(dataloc(1:end-4),'_PhaseCohValueCS.mat');
        case 'psi'
            dataloc = strcat(dataloc(1:end-4),'_PSIValueCS.mat');
        case 'imagcoh' 
            dataloc = strcat(dataloc(1:end-4),'_ImagCohValueCS.mat');
        case 'magcoh_cluster'
            dataloc = strcat(dataloc(1:end-4),'_CohValue_Cluster.mat');
    end
    dataloc2 = dataloc;
    dataloc = strcat(data_folder,'\',analysisfile,'\',dataloc);
    
    %LOAD FILE
    if exist(dataloc,'file')
        load(dataloc)
    else
        msgbox(sprintf('Unable to load file %s \n\nFile listed as processed in batch file but not found.',dataloc))
    end
    
    %STORE DATA
    switch chanord.method
        case 'orig'
            %TIME BINS
            try
            alldata(:,:,:,:,subject) = raster_mat; %Should change to just pull from continuous data
            catch
                x=1;
            end
            %{
            %CONTINUOUS TIME, NEED NEW SWITCH/OPTION HERE
            if strcmp(BNCT.cohtype,'magcoh') || strcmp(BNCT.cohtype,'phasecoh') || strcmp(BNCT.cohtype,'imagcoh') || strcmp(BNCT.cohtype,'magcoh_cluster')
                for k = 1:1:size(BNCT.config.freqrangelistraw,1)
                    freq_bin(k,1:2) = str2num(BNCT.config.freqrangelistraw{k});
                end
                time_bin = [];
                for p = 1:1:size(BNCT.config.batch_timerange,1)
                    time_bin(p,1:2) = str2num(BNCT.config.batch_timerange{p});
                end
                
                freqnum = linspace(1,size(BNCT.config.freqrangelistraw,1),size(BNCT.config.freqrangelistraw,1));%[1 2 3 4];%%%%%%%%%%%Update this, frequencies selected I guess?
                timenum = size(time_bin,1);
                for ch1 = 1:size(raw_coh,1)
                    for ch2 = ch1+1:size(raw_coh,2)
                        for y = 1:size(freqnum,2);
                            freqind=find(freqlist>= freq_bin(freqnum(y),1) & freqlist<=freq_bin(freqnum(y),2));

                          %  timeind=find(timelist>= 2000 & timelist<=5000); %Change times here realtime
                          %  for z = 1:size(timeind,2)%realtime
                            for z = 1:size(time_bin,1)%overlap
                                if sum(time_bin)==2 %all times
                                timeind=find(timelist>= 0 & timelist<=max(timelist));
                                else
                                timeind=find(timelist>= time_bin(z,1) & timelist<=time_bin(z,2));%Change times here
                                end
                               % cohdata(ch1,ch2,z,y) = mean(raw_coh{ch1,ch2}(freqind,timeind(z)));
                               % cohdata(ch2,ch1,z,y) = mean(raw_coh{ch1,ch2}(freqind,timeind(z)));
                                cohdata(ch1,ch2,z,y) = mean(mean(raw_coh{ch1,ch2}(freqind,timeind))); %overlap
                                cohdata(ch2,ch1,z,y) = mean(mean(raw_coh{ch1,ch2}(freqind,timeind)));%overlap
                            end
                        end
                    end
                end
                alldata(:,:,:,:,subject) = cohdata;
            elseif strcmp(BNCT.cohtype,'psi')
                switch BNCT.connmethod
                    case 'source'
                     alldata(:,:,:,:,subject) = {raster_mat};
                    case 'channel'
                    alldata(:,:,:,:,subject) = raster_mat;
                end
                
            end
                disp(horzcat('Data loaded for ',num2str(subject),' of ',num2str(size(raw,1))));
            %}
        case 'new'
            EEG = pop_loadset(strcat(raw{subject,1},'\',raw{subject,2}));
            disp(sprintf('Reordering channels for file %s (%d/%d)',dataloc2,subject,size(raw,1)));
            raster_new = gui_reorderchans(EEG,raster_mat,chanord);
            alldata(:,:,:,:,subject) = raster_new;
    end
end

waitbar(.4,h);
%%
%GO THROUGH RAW FOR EACH PHENOTYPE (FROM PHENOTYPE COLUMN) AND TASK (FROM
%FILENAME COLUMN, AND PULLS SUBJECT ID
for i = 1:1:size(raw,1) %# subjects
    for b = 1:1:length(phenotypelistraw) %split into #phenos
        if strfind(raw{i,7},phenotypelistraw{b}) > 0 %if pheno(b) matches subject pheno
            for k = 1:1:length(tasklist) %split into #tasks
                if strfind(raw{i,9},(tasklistraw{k})) > 0 %if task(k) matches, was i,2 before
                    %Create subject x task array of IDs and 1 or 0's to
                    %signify if coherence data is present?
                    SubjectIDs.(phenotypelistraw{b}).(tasklist{k}){sub.(phenotypelistraw{b})(k),1} = raw{i,8};
                    sub.(phenotypelistraw{b})(k) = sub.(phenotypelistraw{b})(k)+1;
                end
            end
        end
    end
end
waitbar(.6,h);
%% CREATE A SEPERATE SUBJECTIDS WHICH ACCOUNTS FOR SUBJECT DATA THAT IS NOT
% PRESENT FOR ALL TASKS
if size(tasklistraw,1) > 1
    for b = 1:1:length(phenotypelistraw)
        for k = 1:1:length(tasklist)-1
            for n = k:1:length(tasklist)
                try
                    [Missing.(phenotypelistraw{b}).ids{k,n} Missing.(phenotypelistraw{b}).locs{k,n}] = setdiff(SubjectIDs.(phenotypelistraw{b}).(tasklist{k}),SubjectIDs.(phenotypelistraw{b}).(tasklist{n}));
                catch
                    [Missing.(phenotypelistraw{b}).ids{k,n} Missing.(phenotypelistraw{b}).locs{k,n}] = [];
                end
            end
        end
    end
else Missing = [];
end

%AllSubjects = [];
waitbar(.8,h);
for b = 1:1:size(phenotypelistraw,1) %For each phenotype
    SubjectIDs.All.(phenotypelistraw{b}) = SubjectIDs.(phenotypelistraw{b}).(tasklist{1}); %Get subject IDs from first task
    if size(tasklistraw,1) > 1 %If more than 1 task
        for k = 2:1:size(tasklist,1) %go through all the other tasks
            SubjectIDs.All.(phenotypelistraw{b}) = [SubjectIDs.All.(phenotypelistraw{b});Missing.(phenotypelistraw{b}).ids{1,k}]; %concatenate subject IDs from other task onto 1st task
        end
        %Remove repeated subjects
        %    SubjectIDs.All.(phenotypelistraw{b}) = unique(SubjectIDs.All.(phenotypelistraw{b}),'stable');
    end
end
close(h)