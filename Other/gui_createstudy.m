[num1,txt1,raw1] = xlsread('C:\Users\Joseph\Dropbox\SDRT\Excel files\ADHD_SDRT_BatchCoh_LOWvsHIGHload');
c=1;
for i = 2:size(raw1,1)
    if raw1{i,4} == 1
        %studyfiles{c} = { 'index' 1 'load' strcat(raw1{2,1},'\',raw1{2,2}) 'subject' raw1{i,8} 'condition' raw1{i,9} 'group' raw1{i,7} };
        
        [STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'commands', { ...
            { 'index', c, 'load', strcat(raw1{i,1},'\',raw1{i,2}), 'subject', raw1{i,8}, 'condition', raw1{i,9}, 'group', raw1{i,7} }});
         c=c+1;   
    end
end
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name','ADHD', 'task', 'SDRT'); 
%{
[STUDY ALLEEG] = std_editset( STUDY, [], 'commands', { ...
	{ 'index' 1 'load' 'S02/syn02-S253-clean.set' 'subject' 'S02' 'condition' raw{i, 'group' raw{i,7} }, ...
	{ 'index' 2 'load' 'S05/syn05-S253-clean.set' 'subject' 'S05' 'condition' 'synonyms' }, ...
	{ 'index' 3 'load' 'S07/syn07-S253-clean.set' 'subject' 'S07' 'condition' 'synonyms' }, ...
	{ 'index' 4 'load' 'S08/syn08-S253-clean.set' 'subject' 'S08' 'condition' 'synonyms' }, ...
	{ 'index' 5 'load' 'S10/syn10-S253-clean.set' 'subject' 'S10' 'condition' 'synonyms' }, ...
	{ 'index' 6 'load' 'S02/syn02-S254-clean.set' 'subject' 'S02' 'condition' 'non-synonyms' }, ...	
        { 'index' 7 'load' 'S05/syn05-S254-clean.set' 'subject' 'S05' 'condition' 'non-synonyms' }, ...	
        { 'index' 8 'load' 'S07/syn07-S254-clean.set' 'subject' 'S07' 'condition' 'non-synonyms' }, ...	
        { 'index' 9 'load' 'S08/syn08-S254-clean.set' 'subject' 'S08' 'condition' 'non-synonyms' }, ...	
        { 'index' 10 'load' 'S10/syn10-S254-clean.set' 'subject' 'S10' 'condition' 'non-synonyms' }, ...	
	{ 'dipselect' 0.15 } });
%}