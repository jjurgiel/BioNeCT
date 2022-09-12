function gui_matlab2weka(name,filename,data,featureNames)
javaaddpath('C:\program files\Weka-3-6\weka.jar')
%name = 'ADHD';

%featureNames = BNCT.TopFeatures.Names.dot1{1,1};
%featureNames{end+1} = 'Phenotype';
%featureNames = {'1','2','3','4','5','6','7','8','9','10','target'};
%data = [BNCT.TopFeatures.Affected.dot1{1,1};BNCT.TopFeatures.Controls.dot1{1,1}]; 
%data = [data BNCT.featureclass{1,1}];

wekaOBJ = matlab2weka(name, featureNames, data);
saveARFF(filename,wekaOBJ);
%{
%3. Using Weka Classifier
javaaddpath('C:\program files\Weka-3-6\weka.jar')
 name = 'ADHD';
 numrowcol = size(all_7dot);
 numcol = numrowcol(2);
%  for i = 1:1:numcol
%      featurelist(i) = i;
%  end
all_7dot = num2cell(all_7dot);
all_5dot = num2cell(all_5dot);
all_3dot = num2cell(all_3dot);
all_1dot = num2cell(all_1dot);
all_dot = num2cell(all_dot);
 featureNames = {'cc1' 'ge1' 'pl1' 'mod1' 'mean1'   ...
                 'cc2' 'ge2' 'mod2' 'pl2' 'mean2' ...
                 'cc3' 'ge3' 'mod3' 'pl3' 'mean3'...
                 'cc4' 'ge4' 'mod4' 'pl4' 'mean4'...
                 'cc5' 'ge5' 'mod5' 'pl5' 'mean5'...
                 'cc6' 'ge6' 'mod6' 'pl6' 'mean6' ...
                 'cc7' 'ge7' 'mod7' 'pl7' 'mean7'...
                 'cc8' 'ge8' 'mod8' 'pl8' 'mean8' 'target'};
featureclass = cell(numrowcol(1),1);
for i = 1:1:asize7(1)+csize7(1)%91%186
%for i = 1:1:asize1(1)+asize3(1)+asize5(1)+asize7(1)+csize1(1)+csize3(1)+csize5(1)+csize7(1)
    if i < asize7(1)+1%asize1(1)+asize3(1)+asize5(1)+asize7(1)+1 %111
      featureclass{i,1} = 'Affected';
 %   elseif  i > 26 && i < 46
%      featureclass{i,1} = 'Control';  
 %   elseif i > 45 && i < 75
 %     featureclass{i,1} = 'Affected';
    else
      featureclass{i,1} = 'Control';  
    end
end
%all_7dot(:,numcol+1) = featureclass;
all_7dot(:,numcol+1) = featureclass;
wekaOBJ = matlab2weka(name, featureNames, all_7dot);
saveARFF('c:\Users\Joseph\Documents\UCLA\Research Lab\mydata.arff',wekaOBJ);
%}