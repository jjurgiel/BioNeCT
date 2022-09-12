 function [TopFeatures AllFeatures FeatureNames featureclass2] = gui_fisher2(allmeasures,tasklistraw,SubjectIDs,numtimebins,numfreqs,graph_features,power_features,abs_power,rel_power,numfeat,selectedfreqs,selectedtasks,phenotypelistraw,CalcPowerFeatures,PowerFeatureNames,freqrangelistraw,batch_timerange)

tasklist = tasklistraw;
for a = 1:1:length(phenotypelistraw)
    sub.(phenotypelistraw{a})(1:length(tasklist)) = 1;
end

%% CREATE TASK VARIABLES/CHECK IF USER HAS INPUT APPROPRIATE VARIABLE NAMES
[tasklist] = gui_tasklist(tasklistraw);
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
                %POWER FEATURE NAMES MESSED UP, WHY ADDED A 2ND ONE?
                %ADD IN ABSOLUTE POWERS TO WHATEVER FREQS WERE CALCULATED
                if power_features{2,1} == 1
                    for n = 1:1:size(CalcPowerFeatures,1)
                        if CalcPowerFeatures{n}(1) == f%(n,1) == f
                            temp_data = [temp_data abs_power.(conditionfields{condition}).(taskfields{task})(i,n)];
                            temp_names = [temp_names strcat('abs_power,','Task-',taskfields(task),',',PowerFeatureNames{n,1})];
                        end
                    end
                end
                %ADD IN RELATIVE POWERS
                if power_features{1,1} == 1
                    for n = 1:1:size(CalcPowerFeatures,1)
                        if CalcPowerFeatures{n}(1) == f%(n,1) == f
                            temp_data = [temp_data rel_power.(conditionfields{condition}).(taskfields{task})(i,n)];
                            temp_names = [temp_names strcat('rel_power,','Task-',taskfields(task),',',PowerFeatureNames{n,1})];
                        end
                    end
                end
                
                %STORE DATA FOR SUBJECT&FREQ IN RESPECTIVE CONDITION STRUCT
                AllFeatures.(conditionfields{condition}).(taskfields{task}){f}(i,:) = temp_data;
                FeatureNamesTemp.(taskfields{task}){f}(1,:) = temp_names;
            end
        end
    end
end

%%                        FOR MULTIPLE TASKS & FREQUENCIES
   % CREATING COMBINED FEATURE SET FOR SELECTED TASKS/FREQS
   % STRUCTURE: FEAT FOR F1/TASK1 | F2/TASK1 | F3/TASK1 | F1/TASK2 | F2/TASK2 |
   
   %SET UP ARRAYS
   FeatureNames = [];
   for a = 1:1:length(phenotypelistraw)
       Features.(phenotypelistraw{a}) = [];
   end
   
%GO THROUGH CHOSEN FEATURES AND PLACE THEM INTO A SET MATRIX WITH
%ALL SUBJECTS SO THAT ANY SUBJECTS WITH MISSING TASK DATA CAN BE LATER
%REMOVED
   for b = 1:1:length(phenotypelistraw)
       Features.(phenotypelistraw{b}) = [SubjectIDs.All.(phenotypelistraw{b})];
       FeatureNames = [];
       for r = 1:1:length(selectedtasks)
           for q = 1:1:length(selectedfreqs)               
               featsetsize(r) = size(Features.(phenotypelistraw{b}),2);
               newmat = AllFeatures.(phenotypelistraw{b}).(tasklist{selectedtasks(r)}){1,selectedfreqs(q)};
               tempmat = [SubjectIDs.(phenotypelistraw{b}).(tasklist{selectedtasks(r)}) num2cell(newmat)];
               %GO THROUGH ALL SUBJECTS AND PLACE DATA INDIVIDUALLY
               for n = 1:1:size(tempmat,1)
                   subject = strmatch(tempmat(n,1),Features.(phenotypelistraw{b})(:,1));
                   if any(subject)
                       Features.(phenotypelistraw{b})(subject,featsetsize(r)+1:featsetsize(r)+size(newmat,2)) = [num2cell(newmat(n,:))];%[Features.(phenotypelistraw{b}){subject,:} num2cell(newmat(n,:))];
                   end
               end
               FeatureNames = [FeatureNames FeatureNamesTemp.(taskfields{selectedtasks(r)}){1,selectedfreqs(q)}];
           end
           
       end

       Features.(phenotypelistraw{b}) = Features.(phenotypelistraw{b})(~any(cellfun('isempty',Features.(phenotypelistraw{b})),2),:);
   end
   

%for b = 1:1:length(phenotypelistraw)
%    Features.(phenotypelistraw{b})(any(Features.(phenotypelistraw{b})==0,2),:) = [];
%end

%%                  ASSIGN CLASS/GROUP LABEL TO EACH INSTANCE
for a = 1:1:length(phenotypelistraw)
    if a == 1
        featureclass2(1:size(Features.(phenotypelistraw{a}),1),1) = 1;
    else
        featureclass2(classindex(a-1)+1:classindex(a-1)+size(Features.(phenotypelistraw{a}),1)) = a;
    end
    classindex(a) = size(featureclass2,1);
    classnum{a} = size(Features.(phenotypelistraw{a}),1);
end

%%                      COMBINE PHENOTYPE FEATURE SETS
CombinedFeatures = [];
for a = 1:1:length(phenotypelistraw)
    CombinedFeatures = [CombinedFeatures;Features.(phenotypelistraw{a})(:,2:end)];
end

CombinedFeatures = cell2mat(CombinedFeatures);
%%                      FISHER SCORE ANALYSIS 
        out = fsFisher(CombinedFeatures,featureclass2);   
    %SORT RANKINGS IN ORDER FROM HIGHEST TO LOWEST MERIT
        locs = sort(out.W,'descend');
    %DUMMY VARIABLE FOR TOP MERIT FEATURES
        temp2 = [];

%%                   FINDING TOP MERIT FEATURES

    %FIND COLUMN LOCATIONS OF HIGHEST MERIT FEATURES AND PLACE INTO
    %COLUMN DATA INTO ARRAY
    for i = 1:1:numfeat             
            [l,m] = find(out.W == locs(i));
            temp2.feature(:,i) = CombinedFeatures(:,m);
            temp2.featloc(1,i) = m;
            temp2.featname(1,i) = FeatureNames(m);
    end
    
    for b = 1:1:length(phenotypelistraw)
        if b == 1
            TopFeatures.(phenotypelistraw{b}) = temp2.feature(1:classindex(b),:);
        else 
            TopFeatures.(phenotypelistraw{b}) = temp2.feature(classindex(b-1)+1:classindex(b),:);
        end
        TopFeatures.(phenotypelistraw{b}) = [Features.(phenotypelistraw{b})(:,1) num2cell(TopFeatures.(phenotypelistraw{b}))];
    end 
     
    TopFeatures.Locs = temp2.featloc;
    TopFeatures.Names = temp2.featname;
    AllFeatures = CombinedFeatures;
    
  prog = strcat('Top (', num2str(numfeat),') features extracted via Fisher score to TopFeatures.');
   disp(prog);