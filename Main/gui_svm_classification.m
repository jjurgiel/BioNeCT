function [svm_ratio, conMat, sens, spec]=gui_svm_classification(BNCT,removesubs,method,data_grp1,data_grp2,folds,method_reduction,holdout_percentage,train_pct)

%COMBINE ADHD+TD GROUPS
Subjects=[data_grp1;data_grp2];

%PERFORM REDUCTION METHOD IF SPECIFIED
if strcmp(method_reduction,'none')==0
   [vv,Map_Subjects] = compute_mapping([Subjects'], method_reduction, 10);
else
   Map_Subjects=Subjects;
end

%REMAP ARRAY DEPENDING ON METHOD (.M WORKS FOR PCA, OTHER METHODS MAY BE
%DIFFERENT)
if strcmp(method_reduction,'none')==1
    Mapsubjects = Map_Subjects;
elseif strcmp(method_reduced,'PCA')==1
   Mapsubjects = Map_Subjects.M; 
end
conMat = zeros(2);%ONLY FOR 2 GROUPS
%CLASSIFICATION METHOD
switch method
            
    case 'Holdout Method'
        %CLASSIFICATION VIA HOLDOUT METHOD
        Phenotype=[ones(size(data_grp1,1),1)*1;ones(size(data_grp2,1),1)*2]; % ASD=1; TD=2;
        P = cvpartition(Phenotype,'Holdout',holdout_percentage/100); % 80% for training
        svmStruct = svmtrain(Mapsubjects(P.training,:),Phenotype(P.training),'showplot',false);
        C = svmclassify(svmStruct,Mapsubjects(P.test,:),'showplot',true);
        err_rate = sum(Phenotype(P.test)~= C)/P.TestSize;
        svm_ratio=100-err_rate*100;
        conMat = confusionmat(Phenotype(P.test),C);
% Matlab Confusion matrix
%                             Predicted Condition
%                   True Group 1 (TP)          G1 seleced as G2 (FN)
% True Condition
%                   G2 selected as G1 (FP)      True Group 2 (TN)
%
%
        if str2num(BNCT.config.condpositive) == 1
            sens = conMat(1,1)/(conMat(1,1)+conMat(1,2)); %TP/(TP+FN)
            spec = conMat(2,2)/(conMat(2,2)+conMat(2,1)); %TN/(TN+TP)
        else
            spec = conMat(1,1)/(conMat(1,1)+conMat(1,2)); %TP/(TP+FN)
            sens = conMat(2,2)/(conMat(2,2)+conMat(2,1)); %TN/(TN+TP)            
        end
        
            if isnan(spec)
                x=1;
            end
        x=1;
        
    case 'K-Fold Cross Validation'
        %CLASSIFICATION VIA K-FOLD CROSS VALIDATION

        Phenotype=[ones(size(data_grp1,1),1)*1;ones(size(data_grp2,1),1)*2]; % ASD=1; TD=2;
        CVO = cvpartition(Phenotype,'k',folds); % 10-fold
        for i=1:CVO.NumTestSets
            svmStruct = svmtrain(Mapsubjects(CVO.training(i),:),Phenotype(CVO.training(i)),'showplot',false);
            C_tmp = svmclassify(svmStruct,Mapsubjects(CVO.test(i),:),'showplot',false);
            err_rate_tmp(i) = sum(Phenotype(CVO.test(i))~= C_tmp);
            conMat = conMat + confusionmat(Phenotype(CVO.test(i)),C_tmp);
        end
        
        if str2num(BNCT.config.condpositive) == 1
            sens = conMat(1,1)/(conMat(1,1)+conMat(1,2)); %TP/(TP+FN)
            spec =conMat(2,2)/(conMat(2,2)+conMat(2,1)); %TN/(TN+TP)
        else
            spec = conMat(1,1)/(conMat(1,1)+conMat(1,2)); %TP/(TP+FN)
            sens =conMat(2,2)/(conMat(2,2)+conMat(2,1)); %TN/(TN+TP)            
        end
           
        
        err_rate_10_fold=sum(err_rate_tmp)/sum(CVO.TestSize);
        svm_ratio=100-err_rate_10_fold*100;
    case 'Train + Test Set'
        %CLASSIFICATION VIA TRAINING SET & TESTING SET
                             %%%%Train Classifier%%%%
        group1 = data_grp1(randperm(end),:);
        group2 = data_grp2(randperm(end),:);
        
        group1_train = group1(1:round(train_pct*size(group1,1)),:);
        group2_train = group2(1:round(train_pct*size(group2,1)),:);
        
        group1_test = group1(1+round(train_pct*size(group1,1)):end,:);
        group2_test = group2(1+round(train_pct*size(group2,1)):end,:);
        
        %Set Phenotype array for training data
        Phenotype=[ones(size(group1_train,1),1)*1;ones(size(group2_train,1),1)*2]; % ASD=1; TD=2;
        %Create partition (the partition includes all the training data in this case)
        P = cvpartition(Phenotype,'Resubstitution');
        %Train the classifier
        svmStruct = svmtrain(Map_Subjects(P.training,:),Phenotype(P.training),'showplot',false);
        
                             %%%%Test classifier%%%% 
        %Set phenotype array for ASD test data
        Phenotype_test=[ones(size(group1_test,1),1)*1;ones(size(group2_test,1),1)*2];
        %Create partition (no actual partitions in this test case, just testing a
        %set of test data
        P_test = cvpartition(Phenotype_test,'Resubstitution');
        %Classify ASDtest data using classifier structure svmStruct created above
        Test_Group = [group1_test;group2_test];
        C_tmp = svmclassify(svmStruct,Test_Group(P_test.test(1),:),'showplot',false);
        %Calculate error rate, etc...
        err_rate = sum(Phenotype_test(P_test.test)~= C_tmp)/P_test.TestSize;
        svm_ratio = 100-err_rate*100;
        conMat = confusionmat(Phenotype_test(P_test.test),C_tmp);
        if str2num(BNCT.config.condpositive) == 1
            sens = conMat(1,1)/(conMat(1,1)+conMat(1,2)); %TP/(TP+FN)
            spec =conMat(2,2)/(conMat(2,2)+conMat(2,1)); %TN/(TN+TP)
        else
            spec = conMat(1,1)/(conMat(1,1)+conMat(1,2)); %TP/(TP+FN)
            sens =conMat(2,2)/(conMat(2,2)+conMat(2,1)); %TN/(TN+TP)           
        end

end
%svm_ratio=100- err_rate *100;
%svm_10fold_ratio=100-err_rate_10_fold*100;
clustering_ratio=0; %100-err_rate_map_clust_kmeans(1)*100;
kmean_ratio=0;%100-err_rate_map_clust_kmeans(2)*100;

%{
if disp_opt==1
disp('============================================================================')
disp(strcat(num2str(100-holdout_percentage*100),' % of the whole data has been used to trained the AI'));
disp(strcat('The data dimention reduction method is:' , method_reduction));
disp(strcat(' Correct Classification Ratio using SVM : ',num2str(100-err_rate*100)));
disp('The confusion matrix:');
disp(conMat);
disp(strcat(' Correct Classification Ratio using 10-fold SVM : ',num2str(100-err_rate_10_fold*100)));
% disp(strcat(' Correct Classification Ratio using Clustering : ',num2str(100-err_rate_map_clust_kmeans(1)*100)));
% disp(strcat(' Correct Classification Ratio using K-Means : ',num2str(100-err_rate_map_clust_kmeans(2)*100)));
% disp('============================================================================')
% end 
end
%}