%function [AllFeatures AffectedTopFeatures TDTopFeatures TopFeatures FeaturesNames] = gui_fisher(allmeasures,tasklistraw,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,alphapowertimerange,numfeat,power_freqrange,phenotypelistraw)
function [AllFeatures TopFeatures FeatureNames featureclass] = gui_fisher(allmeasures,tasklistraw,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,numfeat,phenotypelistraw,CalcPowerFeatures,PowerFeatureNames,freqrangelistraw,batch_timerange)

h = waitbar(0,'Performing Feature Analysis...');
tasklist = tasklistraw;
for a = 1:1:length(phenotypelistraw)
    sub.(phenotypelistraw{a})(1:length(tasklist)) = 1;
end

%% CREATE TASK VARIABLES/CHECK IF USER HAS INPUT APPROPRIATE VARIABLE NAMES
[tasklist] = gui_tasklist(tasklistraw);
%{
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
%}
%%                          FEATURE SELECTION

%DETERMINE SIZE OF DATA FOR EACH TASK & CONDITION
for i = 1:1:length(tasklist)
    for a = 1:1:length(phenotypelistraw)
        phenosize.(phenotypelistraw{a})(i) = size(allmeasures.(phenotypelistraw{a}).(tasklist{i}),2);
    end
end

conditionfields = fieldnames(allmeasures);
taskfields = fieldnames(allmeasures.(conditionfields{1}));

%CREATE (#-of-Phenotypes) STRUCTURES, WHICH CONTAIN FULL FEATURE SETS OF
%MEASURES FOR ALL SUBJECTS FOR EACH TASK & FREQUENCY

%FOR EACH PHENOTYPE
for condition = 1:1:length(phenotypelistraw)
    %FOR EACH TASK
    for task = 1:1:length(taskfields)
        %FOR EACH SUBJECT DATA FOR EACH TASK
        for i = 1:1:length(allmeasures.(conditionfields{condition}).(taskfields{task}))
            %FOR EACH FREQUENCY
            for f = 1:1:numfreqs
                temp_data = [];
                temp_names = [];
                %FOR EACH TIME BIN
                for t = 1:1:numtimebins
                    
                    %SET ASIDE RESPECTIVE MEASURES
                    datatemp = allmeasures.(conditionfields{condition}).(taskfields{task}){1,i}(f,t);
                    
                    %CONCATENATE DESIRED GRAPH THEORY MEASURES 
                    for z = 1:1:size(graph_features,1);
                        temp_data = [temp_data datatemp.(graph_features{z,3})];
                        temp_names = [temp_names strcat(graph_features(z,2),',Task-',taskfields(task),',Freq-',freqrangelistraw{f},',Timebin-',batch_timerange{t})];%num2str(f)
                    end      
                end
               
                %ADD IN ABSOLUTE POWERS TO WHATEVER FREQS WERE CALCULATED
                if power_features{2,1} == 1
                    for n = 1:1:size(CalcPowerFeatures,1)
                        if CalcPowerFeatures{n}(1) == f
                            temp_data = [temp_data abs_power.(conditionfields{condition}).(taskfields{task})(i,n)];
                            temp_names = [temp_names strcat('abs_power,','Task-',taskfields(task),',',PowerFeatureNames{n,1})];
                        end
                    end
                end
                %ADD IN RELATIVE POWERS
                if power_features{1,1} == 1
                    for n = 1:1:size(CalcPowerFeatures,1)
                        if CalcPowerFeatures{n}(1) == f
                            temp_data = [temp_data rel_power.(conditionfields{condition}).(taskfields{task})(i,n)];
                            temp_names = [temp_names strcat('rel_power,','Task-',taskfields(task),',',PowerFeatureNames{n,1})];
                        end
                    end
                end
                %STORE DATA FOR SUBJECT&FREQ IN RESPECTIVE CONDITION STRUCT
                try
                    AllFeatures2.(conditionfields{condition}).(taskfields{task}){f}(i,:) = temp_data;
                catch
                    msgbox('Data not available for selected features');
                    return
                end
                FeatureNames.(taskfields{task}){f}(1,:) = temp_names;               
            end
        end
    end
    waitbar(condition/length(phenotypelistraw),h);
end

        
%CLASSIFY GROUPS
for i=1:1:length(tasklist)
    for a = 1:1:length(phenotypelistraw)
        if a == 1
            featureclass{i}(1:phenosize.(phenotypelistraw{a})(i),1) = 1;
        else
            %%%WHY DOES FISHER RANKINGS DEPEND ON FEATURE CLASS LABEL???
            featureclass{i}(length(featureclass{i})+1:length(featureclass{i})+phenosize.(phenotypelistraw{a})(i),1) = a;
        end
    end
end


%% Fisher Feature Selection Method (fsFisher.m)
%--Ranks individual features (i.e. each column of data) on their ability to
%--distinguish between control and affected group. Has a range of 0-1, with
%--higher distinguishability being represented by a higher value

%FOR EACH FREQUENCY
for a = 1:1:length(AllFeatures2.(conditionfields{1}).(tasklist{1}))    
    for i = 1:1:length(tasklistraw)   
        %COMBINE CONDITIONS FOR FEATURE SELECTION 
        AllFeatures.(tasklist{i}){1,a} = []; 
        for b = 1:1:length(phenotypelistraw)
            AllFeatures.(tasklist{i}){1,a} = [AllFeatures.(tasklist{i}){1,a};AllFeatures2.(phenotypelistraw{b}).(tasklist{i}){1,a}];
        end
        %FISHER SCORE ANALYSIS
        out.(tasklist{i}){1,a} = fsFisher(AllFeatures.(tasklist{i}){1,a},featureclass{i});   
        %SORT RANKINGS IN ORDER FROM HIGHEST TO LOWEST MERIT
        locs.(tasklist{i}){1,a} = sort(out.(tasklist{i}){1,a}.W,'descend');
        %DUMMY VARIABLE FOR TOP MERIT FEATURES
        temp.(tasklist{i}){1,a} = [];
    end

%%                   FINDING TOP MERIT FEATURES

    %FIND COLUMN LOCATIONS OF HIGHEST MERIT FEATURES AND PLACE INTO
    %COLUMN DATA INTO ARRAY
    for i = 1:1:numfeat  
        for j = 1:1:length(tasklistraw)            
            [l,m] = find(out.(tasklist{j}){1,a}.W == locs.(tasklist{j}){1,a}(i));
            temp.(tasklist{j}){1,a}.feature(:,i) = AllFeatures.(tasklist{j}){1,a}(:,m);
            temp.(tasklist{j}){1,a}.featname(1,i) = FeatureNames.(tasklist{j}){1,a}(1,m);
            temp.(tasklist{j}){1,a}.featloc(1,i) = m;
        end
    end
    
    %SORT DATA BACK INTO PHENOTYPE GROUPS
    for i = 1:1:length(tasklistraw)       
        for b = 1:1:length(phenotypelistraw)
            if b == 1
                TopFeatures.(phenotypelistraw{b}).(tasklist{i}){a} = temp.(tasklist{i}){1,a}.feature(1:phenosize.(phenotypelistraw{b})(i),:);
            else
                TopFeatures.(phenotypelistraw{b}).(tasklist{i}){a} = temp.(tasklist{i}){1,a}.feature(phenosize.(phenotypelistraw{b-1})(i)+1:phenosize.(phenotypelistraw{b-1})(i)+phenosize.(phenotypelistraw{b})(i),:);
            end
        end

        TopFeatures.Locs.(tasklist{i}){a} = temp.(tasklist{i}){1,a}.featloc;
        TopFeatures.Names.(tasklist{i}){a} = temp.(tasklist{i}){1,a}.featname;
        %   if a == 2 && i == 4
        %debug for alpha 7dot
        %   end
    end
end
   
   prog = strcat('Top (', num2str(numfeat),') features extracted via Fisher Score.');
   disp(prog);
   disp('Top feature names/locations placed into TopFeatures')
   close(h)

