%function [abs_power rel_power] = gui_alpha_power_calculation(raw,tasklistraw,timerange1,timerange2,freqrange,chn_clust)
function [abs_power rel_power] = gui_power_calculation(raw,tasklistraw,CalcPowerFeatures,phenotypelistraw)
tasklist = tasklistraw;
%Group = {'Affected';'Control'};
for a = 1:1:length(phenotypelistraw)
sub.(phenotypelistraw{a})(1:length(tasklist)) = 1;
end
%Afftasksubject(1:length(tasklist)) = 1;
%Controltasksubject(1:length(tasklist)) = 1;


%% CREATE TASK VARIABLES/CHECK IF USER HAS INPUT APPROPRIATE VARIABLE NAMES
warn = 0;

for j = 1:1:length(tasklist)
    warncount = 0;
    while any(str2num(tasklist{j}(1)))
        %SHIFT STRING LEFT IF FIRST STRING COMPONENT IS A NUMBER
        tasklist{j} = circshift(tasklist{j},[1 -1]);
        warncount = warncount + 1;
        %GIVE WARNING IF CAN'T FIND A LETTER TO START STRING
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

subjects = length(raw(:,2));
%eeglab
h = waitbar(0,'Computing Power...');
%%
for subject = 1:1:subjects
    for a = 1:1:size(CalcPowerFeatures,1)
     %   if size(PowerFeatures,1) == 1
   %         freqrange(1) = PowerFeatures(a,1);
   %         freqrange(2) = PowerFeatures(a,2);
   %         timerange1 = PowerFeatures(a,3);
   %         timerange2 = PowerFeatures(a,4);
 %           chn_clust = PowerFeatures(a,5:end);
   %     else
            freqrange(1) = CalcPowerFeatures{a}(2);
            freqrange(2) = CalcPowerFeatures{a}(3);
            timerange1 = (CalcPowerFeatures{a}(4));
            timerange2 = (CalcPowerFeatures{a}(5));
            chn_clust = CalcPowerFeatures{a}(6:end);            
     %   end
    
    %LOAD DATA
    EEG = pop_loadset(strcat(raw(subject,1),'\',raw(subject,2)));
    
    %ADJUST SAMPLING RATE
    if EEG.srate~=500
        EEG = pop_resample(EEG, 500);
    end
    
    %SET TIME BOUNDARIES & COMPUTE PSD
    time_range(1) = timerange1;
    if timerange2 > EEG.xmax
        time_range(2) = 1000*EEG.xmax;
    else
        time_range(2) = timerange2;
    end
    
    %COMPUTE SPECTRUM
    figure;
    out = pop_spectopo(EEG, 1,[time_range(1) time_range(2)], 'EEG', 'percent',100,'freq',[2 8 12 15 20 25 30 35 40 45 50],'freqrange',[2 60],'electrodes','off','plot','off');
    close();

    %if db_opt~=1
    %	out=10.^(out/10); % converting data from Log
    %end

    %FIND BINS OF DESIRED FREQUENCIES
    binsize = 256/length(out);
    bin1 = round(freqrange(1)/binsize);
    bin2 = round(freqrange(2)/binsize);

    %SET BIN RANGE
    bin_range=[bin1:bin2];
    
    %SET CHANNELS TO AVERAGE SPECTRUM OVER
    if length(chn_clust) == 1
        Average_chn = out(chn_clust,:);
    else
        Average_chn=mean(out(chn_clust,:));
    end
    
%%  ABSOLUTE POWER
    abs_power_temp=mean(Average_chn(bin_range));
    
    %RELATIVE POWER
    avg_power=sum(Average_chn(round(1/binsize):round(50/binsize)));
    rel_power_temp = abs_power_temp/avg_power;

%%                  STORE DATA TO RESPECTIVE LOCATION
%{
    if strfind(raw{subject,7},'Affected') > 0 %HARD CODED COND
        for k = 1:1:length(tasklist)
            if strfind(raw{subject,2},(tasklistraw{k})) > 0
                abs_power.Affected.(tasklist{k})(Afftasksubject(k),1) = abs_power_temp;
                rel_power.Affected.(tasklist{k})(Afftasksubject(k),1) = rel_power_temp;
                Afftasksubject(k) = Afftasksubject(k)+1;
            end
        end
    elseif strfind(raw{subject,7},'Control') > 0
        for k = 1:1:length(tasklist)
            if strfind(raw{subject,2},(tasklistraw{k})) > 0
                abs_power.Control.(tasklist{k})(Controltasksubject(k),1) = abs_power_temp;
                rel_power.Control.(tasklist{k})(Controltasksubject(k),1) = rel_power_temp;
                Controltasksubject(k) = Controltasksubject(k)+1;
            end
        end
    end
 %}   
    for b = 1:1:length(phenotypelistraw)
        if strfind(raw{subject,7},phenotypelistraw{b}) > 0
            for k = 1:1:length(tasklist)
                if strfind(raw{subject,2},(tasklistraw{k})) > 0
                    abs_power.(phenotypelistraw{b}).(tasklist{k})(sub.(phenotypelistraw{b})(k),a) = abs_power_temp; %a was a 1 before
                    rel_power.(phenotypelistraw{b}).(tasklist{k})(sub.(phenotypelistraw{b})(k),a) = rel_power_temp;
                    
                    if a == size(CalcPowerFeatures,1)
                       sub.(phenotypelistraw{b})(k) = sub.(phenotypelistraw{b})(k)+1; 
                    end
                end
            end
        end
    end
    
    end
    waitbar(subject/subjects,h);  
end
close(h)