function [TopFeatures FeatureNames featureclass] = gui_createfeatureset(allmeasures,tasklistraw,SubjectIDs,numtimebins,numfreqs,ForcedFeatures,PowerFeatures,PowerFeatureNames,abs_power,rel_power,phenotypelistraw)

[graph_features power_features] = gui_featurematrix;

features = [graph_features;power_features];

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
%%                          

%DETERMINE SIZE OF DATA FOR EACH TASK & CONDITION
%for i = 1:1:length(tasklist)
%    asize(i) = size(allmeasures.Affected.(tasklist{i}),2);
%    csize(i) = size(allmeasures.Control.(tasklist{i}),2);
%end
for i = 1:1:length(tasklist)
    for a = 1:1:length(phenotypelistraw)
        phenosize.(phenotypelistraw{a})(i) = size(allmeasures.(phenotypelistraw{a}).(tasklist{i}),2);
    end
end
conditionfields = fieldnames(allmeasures);
taskfields = fieldnames(allmeasures.(conditionfields{1}));

%%                      CREATE FEATURE SET

    for b = 1:1:size(phenotypelistraw,1)
        temp_data{b}(:,1) = SubjectIDs.All.(phenotypelistraw{b});
     if any(ForcedFeatures)   
        for numfeats = 1:1:size(ForcedFeatures,1) %# features selected
            meas = ForcedFeatures(numfeats,1);
            task = ForcedFeatures(numfeats,2);
            freq = ForcedFeatures(numfeats,3);
            time = ForcedFeatures(numfeats,4);
            TaskIDs = SubjectIDs.(phenotypelistraw{b}).(tasklist{task}); %ids for selected task

            for i = 1:1:size(allmeasures.(conditionfields{b}).(taskfields{task}),2) %# subjects in selected meas/task combo
                IDtype = class(TaskIDs{i});
                switch IDtype
                    case 'double'
                        subject  = [];
                        for a = 1:size(temp_data{b},1)
                            if isempty(subject)
                                if find([temp_data{b}{a,1}] == TaskIDs{i});%strmatch(TaskIDs{i},temp_data{b}(:,1));
                                    subject = a;
                                end
                            else
                                break
                            end
                        end
                    case 'char'
                        subject = find(strcmp(TaskIDs{i},temp_data{b}(:,1)));%strmatch(TaskIDs{i},temp_data{b}(:,1));
                end
                 %find where id matches or if id is missing
                if any(subject)
                    temp_data{b}{subject,1+numfeats} = double([allmeasures.(conditionfields{b}).(taskfields{task}){1,i}(freq,time).(features{meas,3})]);
                    temp_names(1,1+numfeats) = strcat(features(meas,2),',Task-',taskfields(task),',Freq-',num2str(freq),',Timebin-',num2str(time));
                end
            end
        end
    end
end
%CHECK IF ANY GRAPH MEASURES WERE SELECTED
%try size(temp_data{1},2);
    x = size(temp_data{1},2);
%catch
%    x = 0;
%end

%%                      CONCATENATE POWER FEATURES
if any(PowerFeatures)
    for b = 1:1:size(phenotypelistraw,1)
        for numfeats2 = 1:1:size(PowerFeatures,1)
            powertype = PowerFeatures(numfeats2,1);
            task = PowerFeatures(numfeats2,2);
            meas = PowerFeatures(numfeats2,3);
            TaskIDs = SubjectIDs.(phenotypelistraw{b}).(tasklist{task}); %ids for selected task
            for i = 1:1:size(allmeasures.(conditionfields{b}).(taskfields{task}),2) %# subject
                if powertype == 1
                    subject = strmatch(TaskIDs{i},temp_data{b}(:,1));
                    if any(subject)
                        temp_data{b}{subject,x+numfeats2} = [rel_power.(conditionfields{b}).(taskfields{task})(i,meas)];
                        temp_names(1,x+numfeats2) = strcat('Relative Power,','Task-',taskfields(task),',Freq-',PowerFeatureNames{meas});
                    end
                else
                    subject = strmatch(TaskIDs{i},temp_data{b}(:,1));
                    if any(subject)
                        temp_data{b}{subject,x+numfeats2} = [abs_power.(conditionfields{b}).(taskfields{task})(i,meas)];
                        temp_names(1,x+numfeats2) = strcat('Absolute Power,','Task-',taskfields(task),',Freq-',PowerFeatureNames{meas});
                    end
                end
            end
        end
    end
end

%REMOVE SUBJECTS WITH MISSING DATA/FEATURES
%for condition = 1:1:length(phenotypelistraw)
%    temp_data{1,condition} = temp_data{1,condition}(all(temp_data{1,condition},2),:);  
%end
for b = 1:1:length(phenotypelistraw)
    temp_data{b} = temp_data{b}(~any(cellfun('isempty',temp_data{b}),2),:);
    TopFeatures.(phenotypelistraw{b}) = temp_data{1,b};
end

TopFeatures.Names = temp_names(2:end);
FeatureNames = temp_names;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LEFT OFF HERE
%%%MAKE FEATURECLASS, WHERE IS THIS?
for a = 1:1:length(phenotypelistraw)
    if a == 1
        featureclass(1:size(TopFeatures.(phenotypelistraw{a}),1),1) = 1;
    else
        featureclass(classindex(a-1)+1:classindex(a-1)+size(TopFeatures.(phenotypelistraw{a}),1)) = a;
    end
    classindex(a) = size(featureclass,1);
    classnum{a} = size(TopFeatures.(phenotypelistraw{a}),1);
end

