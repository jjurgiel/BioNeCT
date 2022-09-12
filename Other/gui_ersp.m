%
[num1,txt1,raw1] = xlsread('C:\Users\Joseph\Dropbox\SDRT\Excel files\ADHD_SDRT_BatchCoh_LOWvsHIGHload');

count = 1;
%subject = [];

h = waitbar(0,'Running ERSP...');
timelist = [0 2000; 2000 5000; 5000 6000];
freqlist = [4 8;8 12;20 30; 30 40];
%
%
fz_avg_adhd_low = [];fz_avg_td_low = [];fz_avg_adhd_high = [];fz_avg_td_high = [];
oz_avg_adhd_low = [];oz_avg_td_low = [];oz_avg_adhd_high = [];oz_avg_td_high = [];
a=1;b=1;c=1;d=1;
for i = 2:size(raw1,1)
    if raw1{i,4} == 1
        EEG = pop_loadset(strcat(raw1{i,1},'\',raw1{i,2}));
        if ~strcmp(EEG.chanlocs(1,9).labels,'F3') || ~strcmp(EEG.chanlocs(1,13).labels,'Fz') || ~strcmp(EEG.chanlocs(1,17).labels,'F4')...
                || ~strcmp(EEG.chanlocs(1,8).labels,'O1') || ~strcmp(EEG.chanlocs(1,16).labels,'Oz') || ~strcmp(EEG.chanlocs(1,24).labels,'O2')
            error('Channel does not match')
        end
        subject{count,1} = horzcat(raw1{i,7},'_',num2str(raw1{i,8}),'_',raw1{i,9});
        fz = (EEG.data(9,:,:)+EEG.data(13,:,:)+EEG.data(17,:,:))/3;
        oz = (EEG.data(8,:,:)+EEG.data(16,:,:)+EEG.data(24,:,:))/3;
        
        if strcmp('Affected',raw1{i,7}) && strcmp('Low',raw1{i,9})
            fz_avg_adhd_low = cat(3,fz_avg_adhd_low, fz); 
            oz_avg_adhd_low = cat(3,oz_avg_adhd_low, oz);
            %[ALL_ERSP.AFFECTED.LOW.FZ.ERSP{a},ALL_ERSP.AFFECTED.LOW.FZ.ITC{a},ALL_ERSP.AFFECTED.LOW.FZ.POWBASE{a},...
            %    ALL_ERSP.AFFECTED.LOW.FZ.TIME{a},ALL_ERSP.AFFECTED.LOW.FZ.FREQS{a},ALL_ERSP.AFFECTED.LOW.FZ.ERSPBOOT{a},...
            %    ALL_ERSP.AFFECTED.LOW.FZ.ITCBOOT{a}] = newtimef(fz, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
            %a=a+1;
        elseif strcmp('Affected',raw1{i,7}) && strcmp('High',raw1{i,9})
            fz_avg_adhd_high = cat(3,fz_avg_adhd_high, fz); 
            oz_avg_adhd_high = cat(3,oz_avg_adhd_high, oz);
            %[ALL_ERSP.AFFECTED.HIGH.FZ.ERSP{a},ALL_ERSP.AFFECTED.LOW.FZ.ITC{a},ALL_ERSP.AFFECTED.LOW.FZ.POWBASE{a},...
            %    ALL_ERSP.AFFECTED.HIGH.FZ.TIME{a},ALL_ERSP.AFFECTED.HIGH.FZ.FREQS{a},ALL_ERSP.AFFECTED.HIGH.FZ.ERSPBOOT{a},...
            %    ALL_ERSP.AFFECTED.HIGH.FZ.ITCBOOT{a}] = newtimef(fz, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
            %b=b+1;
        elseif strcmp('Controls',raw1{i,7}) && strcmp('Low',raw1{i,9})
            fz_avg_td_low = cat(3,fz_avg_td_low, fz); 
            oz_avg_td_low = cat(3,oz_avg_td_low, oz);
        elseif strcmp('Controls',raw1{i,7}) && strcmp('High',raw1{i,9})
            fz_avg_td_high = cat(3,fz_avg_td_high, fz); 
            oz_avg_td_high = cat(3,oz_avg_td_high, oz);
        end
        %ERSPs
            
        count = count+1;
    end
    waitbar(i/size(raw1,1),h);
end
%
%
figure('Name','Frontal ADHD Low ERSP','NumberTitle','off')
[ersp_fz_adhd_low,itc_fz,powbase_fz,time_fz,freqs_fz,erspboot_fz,itcboot_fz] = newtimef(fz_avg_adhd_low, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
figure('Name','Frontal ADHD High ERSP','NumberTitle','off')
[ersp_fz_adhd_high,itc_fz,powbase_fz,time_fz,freqs_fz,erspboot_fz,itcboot_fz] = newtimef(fz_avg_adhd_high, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
figure('Name','Occipital ADHD Low ERSP','NumberTitle','off')
[ersp_oz_adhd_low,itc_fz,powbase_fz,time_fz,freqs_fz,erspboot_fz,itcboot_fz] = newtimef(oz_avg_adhd_low, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
figure('Name','Occipital ADHD High ERSP','NumberTitle','off')
[ersp_oz_adhd_high,itc_fz,powbase_fz,time_fz,freqs_fz,erspboot_fz,itcboot_fz] = newtimef(oz_avg_adhd_high, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);

figure('Name','Frontal TD Low ERSP','NumberTitle','off')
[ersp_fz_td_low,itc_oz,powbase_oz,time_oz,freqs_oz,erspboot_oz,itcboot_oz] = newtimef(fz_avg_td_low, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
figure('Name','Frontal TD High ERSP','NumberTitle','off')
[ersp_fz_td_high,itc_oz,powbase_oz,time_oz,freqs_oz,erspboot_oz,itcboot_oz] = newtimef(fz_avg_td_high, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
figure('Name','Occipital TD Low ERSP','NumberTitle','off')
[ersp_oz_td_low,itc_oz,powbase_oz,time_oz,freqs_oz,erspboot_oz,itcboot_oz] = newtimef(oz_avg_td_low, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
%
figure('Name','Occipital TD High ERSP','NumberTitle','off')
[ersp_oz_td_high,itc_oz,powbase_oz,time_oz,freqs_oz,erspboot_oz,itcboot_oz] = newtimef(oz_avg_td_high, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
%}
%%
%
%datafz = [];
%dataoz = [];
%subject = [];
for i = 2:size(raw1,1)
    if raw1{i,4} == 1
        %Load data
        EEG = pop_loadset(strcat(raw1{i,1},'\',raw1{i,2}));
        %Check channels of file
        if ~strcmp(EEG.chanlocs(1,9).labels,'F3') || ~strcmp(EEG.chanlocs(1,13).labels,'Fz') || ~strcmp(EEG.chanlocs(1,17).labels,'F4')...
                || ~strcmp(EEG.chanlocs(1,8).labels,'O1') || ~strcmp(EEG.chanlocs(1,16).labels,'Oz') || ~strcmp(EEG.chanlocs(1,24).labels,'O2')
            error('Channel does not match')
        end
        %Save filename
        subject{count,1} = horzcat(raw1{i,7},'_',num2str(raw1{i,8}),'_',raw1{i,9});
        %Cluster data
        fz = (EEG.data(9,:,:)+EEG.data(13,:,:)+EEG.data(17,:,:))/3;
        oz = (EEG.data(8,:,:)+EEG.data(16,:,:)+EEG.data(24,:,:))/3;

        %ERSPs
        %
        [ersp_fz,itc_fz,powbase_fz,time_fz,freqs_fz,erspboot_fz,itcboot_fz] = newtimef(fz, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
        close
        datafz_all(count,1:size(ersp_fz,1),1:size(ersp_fz,2)) = ersp_fz;
        [ersp_oz,itc_oz,powbase_oz,time_oz,freqs_oz,erspboot_oz,itcboot_oz] = newtimef(oz, EEG.pnts, [EEG.xmin EEG.xmax]*1000, EEG.srate, 'cycles',[3,0.5]);
        close
        dataoz_all(count,1:size(ersp_oz,1),1:size(ersp_oz,2)) = ersp_oz;
        %Select data from time ranges
        for t=1:size(timelist,1)
            timeind = find(time_fz>=timelist(t,1) & time_fz<=timelist(t,2));
            for f = 1:size(freqlist,1)
                freqind = find(freqs_fz>=freqlist(f,1) & freqs_fz<=freqlist(f,2));
                %datafz{t,f}(count,1) = mean(mean(ersp_fz(freqind,timeind)));
                %dataoz{t,f}(count,1) = mean(mean(ersp_oz(freqind,timeind)));
                datafz(t,f,count) = mean(mean(ersp_fz(freqind,timeind)));
                dataoz(t,f,count) = mean(mean(ersp_oz(freqind,timeind)));
            end
        end
        %}
        count = count+1;
    end
    waitbar(i/size(raw1,1),h);
end
%}
%
erspdata.fz.affected.low = [];
erspdata.fz.affected.high = [];
erspdata.affected.id = [];

erspdata.fz.controls.low = [];
erspdata.fz.controls.high = [];
erspdata.controls.id = [];

erspdata.oz.affected.low = [];
erspdata.oz.affected.high = [];

erspdata.oz.controls.low = [];
erspdata.oz.controls.high = [];

%Structure: t1_theta t2_theta t3_theta t1_alpha t2_alpha...
for j = 1:size(subject,1)
    if strfind(subject{j,1},'Affected') & strfind(subject{j,1},'Low')
        erspdata.fz.affected.low = [erspdata.fz.affected.low; reshape(datafz(:,:,j),1,12)];
        erspdata.oz.affected.low = [erspdata.oz.affected.low; reshape(dataoz(:,:,j),1,12)];
        erspdata.affected.id = [erspdata.affected.id; subject(j,1)];
    elseif strfind(subject{j,1},'Affected') & strfind(subject{j,1},'High')
        erspdata.fz.affected.high = [erspdata.fz.affected.high; reshape(datafz(:,:,j),1,12)];
        erspdata.oz.affected.high = [erspdata.oz.affected.high; reshape(dataoz(:,:,j),1,12)];        
    elseif strfind(subject{j,1},'Controls') & strfind(subject{j,1},'Low')
        erspdata.controls.id = [erspdata.controls.id; subject(j,1)];
        erspdata.fz.controls.low = [erspdata.fz.controls.low; reshape(datafz(:,:,j),1,12)];
        erspdata.oz.controls.low = [erspdata.oz.controls.low; reshape(dataoz(:,:,j),1,12)];        
    elseif strfind(subject{j,1},'Controls') & strfind(subject{j,1},'High')
        erspdata.fz.controls.high = [erspdata.fz.controls.high; reshape(datafz(:,:,j),1,12)];
        erspdata.oz.controls.high = [erspdata.oz.controls.high; reshape(dataoz(:,:,j),1,12)];        
    end
end
%}
%P-value plots
count = 1;
tasks = {'Low','High'};
cond = {'Affected','Control'};
reg = {'Frontal','Occipital'};
for a = 1:2; %region
    for b = 1:2; %task
        for c = 1:2 %cond
            count = 1;
            for k = 1:size(datafz_all,1)
                if strfind(subject{k,1},cond{c}) & strfind(subject{k,1},tasks{b})
                    if a == 1
                        z=squeeze(datafz_all(k,:,:));
                    else
                        z=squeeze(dataoz_all(k,:,:));
                    end
                    if isempty(strfind(subject{k,1},'1172301')) && isempty(strfind(subject{k,1},'1182301'))
                        sigdata.(reg{a}).(tasks{b}).(cond{c})(count,1:size(z,1),1:size(z,2)) = z;
                        count = count+1;
                        
                    else
                        horzcat(subject{k,1},' not selected')
                        
                    end
                end
            end
        end
        %Finished both conditions for pair of task/reg, now do t.tests
        for x = 1:195
            for y = 1:200
                [h,signif] = ttest2(sigdata.(reg{a}).(tasks{b}).(cond{1})(:,x,y),sigdata.(reg{a}).(tasks{b}).(cond{2})(:,x,y));
                sigdata.pvals.conds.(reg{a}).(tasks{b})(x,y) = signif;
                1;
            end
        end
        sigdata.pvals.conds.(reg{a}).(tasks{b})(sigdata.pvals.conds.(reg{a}).(tasks{b}) < 0.05) = 1;
        sigdata.pvals.conds.(reg{a}).(tasks{b})(sigdata.pvals.conds.(reg{a}).(tasks{b}) < 1) = 0;
        figure('name',horzcat('Region:',reg{a},' Task:',tasks{b},' between ADHD and TD'))
        imagesc(time_fz,freqs_fz,sigdata.pvals.conds.(reg{a}).(tasks{b}))%,'YTick',freqs_fz,'XTick',time_fz)
        %ax=gca; set(ax,'XTickLabel',time_fz,'YTickLabel',freqs_fz)
    end
    for x = 1:195
        for y = 1:200
            [h,signif] = ttest2(sigdata.(reg{a}).(tasks{1}).(cond{1})(:,x,y),sigdata.(reg{a}).(tasks{2}).(cond{1})(:,x,y));
            sigdata.pvals.tasks.(reg{a}).(cond{1})(x,y) = signif;
            1;
        end
    end
    sigdata.pvals.tasks.(reg{a}).(cond{1})(sigdata.pvals.tasks.(reg{a}).(cond{1}) < 0.05) = 1;
    sigdata.pvals.tasks.(reg{a}).(cond{1})(sigdata.pvals.tasks.(reg{a}).(cond{1}) < 1) = 0;
    figure('name',horzcat('Region:',reg{a},' Affected between tasks'))
    imagesc(time_fz,freqs_fz,sigdata.pvals.tasks.(reg{a}).(cond{1}));
    for x = 1:195
        for y = 1:200
            [h,signif] = ttest2(sigdata.(reg{a}).(tasks{1}).(cond{2})(:,x,y),sigdata.(reg{a}).(tasks{2}).(cond{2})(:,x,y));
            sigdata.pvals.tasks.(reg{a}).(cond{2})(x,y) = signif;
            1;
        end
    end
    sigdata.pvals.tasks.(reg{a}).(cond{2})(sigdata.pvals.tasks.(reg{a}).(cond{2}) < 0.05) =1;
    sigdata.pvals.tasks.(reg{a}).(cond{2})(sigdata.pvals.tasks.(reg{a}).(cond{2}) < 1) = 0;
    figure('name',horzcat('Region:',reg{a},' TD between tasks'))
    imagesc(time_fz,freqs_fz,sigdata.pvals.tasks.(reg{a}).(cond{2}));
end


%9, 13, 17
