function [numsubjects, cohmatrix_avg, cohmat_full, colorVec, list, n] = gui_cohmatrix(alldata,raw,tasklistraw,coh_viewoption,coh_subjectnum,topofreq,topocond,topotime,topotask,thr1,thr2,phenotypelistraw)
    condition = phenotypelistraw{topocond};

tasklist = tasklistraw ;
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
task = tasklist{topotask};
%%          SORT COHERENCE DATA INTO CONDITION/TASK
for i = 1:1:size(alldata,5)-1%length(raw)%size(raw,1)

    for b = 1:1:length(phenotypelistraw)
        if strfind(raw{i,7},phenotypelistraw{b}) > 0
            for k = 1:1:length(tasklist)
                if strfind(raw{i,9},(tasklistraw{k})) > 0

                    allcoh.(phenotypelistraw{b}).(tasklist{k}){sub.(phenotypelistraw{b})(k)} = alldata(:,:,:,:,i);

                     
                    sub.(phenotypelistraw{b})(k) = sub.(phenotypelistraw{b})(k)+1;
                end
            end
        end
    end
end

%%  CALCULATE MEAN MATRIX FOR A SPECIFIED CONDITION/TASK/FREQ/TIME
%AVERAGE OF ALL SUBJECTS IN GIVEN CONDITION/TASK
if coh_viewoption == 1
for i = 1:1:length(allcoh.(condition).(task))
    cohmatrix(:,:,i) = allcoh.(condition).(task){1,i}(:,:,topotime,topofreq);
end
numsubjects = length(allcoh.(condition).(task));
cohmatrix_avg = mean(cohmatrix,3);
%INDIVIDUAL SUBJECTS
elseif coh_viewoption == 2
    numsubjects = length(allcoh.(condition).(task));
    %USED TO DEAL WITH DIFFERENT # OF SUBJECTS IN DIFF CONDS/TASKS
    if coh_subjectnum > numsubjects
        coh_subjectnum = numsubjects;
        cohmatrix_avg(:,:) = allcoh.(condition).(task){1,coh_subjectnum}(:,:,topotime,topofreq);
    else
        cohmatrix_avg(:,:) = allcoh.(condition).(task){1,coh_subjectnum}(:,:,topotime,topofreq);
    end   
end
%%                  CREATE COLORMAP BASED ON DATASET
colorVec = jet(length(find(cohmatrix_avg)));
list = sort(cohmatrix_avg(:),'ascend');
list = list(list~=0);

%%                  ZERO DIAGONAL FOR SELF CONNECTIONS
n = length(cohmatrix_avg);
cohmatrix_avg(1:n+1:end)=0;

cohmat_full = cohmatrix_avg;
%%                          THRESHOLD DATA
if thr1 > thr2
    thrhigh = thr1;
    thrlow = thr2;
elseif thr2 >= thr1
    thrhigh = thr2;
    thrlow = thr1;
end

for i=1:1:n
    for j=1:1:n
        if cohmatrix_avg(j,i)>thrlow && cohmatrix_avg(j,i)<thrhigh
            cohmatrix_avg(j,i)=0;
        end
    end
end
