%xlsfile = strcat(BNCT.batchfile.path,BNCT.batchfile.file);
xlsfile = 'C:\Users\Joseph\Documents\UCLA\Loo Lab\p16_Dis\driving_batch.xlsx';
[num,txt1,txt2]=xlsread(xlsfile);
subject_no=size(txt1,1);
for i=1:subject_no
    try
        to_be_process_flag=cell2mat(txt1(i,3));
        if strcmp(to_be_process_flag,'yes')==1
            working_folder=cell2mat(txt1(i,1));
            EEG_datasetname=cell2mat(txt1(i,2));
            tmpEEG=pop_loadset(EEG_datasetname,working_folder);
            %{
            maxTime = tmpEEG.xmax - mod(tmpEEG.xmax,epochlen);
            m = size(tmpEEG.event,2);
            for h = 1:m
                if strcmp(tmpEEG.event(h).type,'boundary')
                    tmpEEG.event(h).type   = 'x';
                end
            end
            
            for j = 1:maxTime/epochlen
                tmpEEG.event(m+j).type     = 'start';
                tmpEEG.event(m+j).latency  = epochlen * (j-1) * tmpEEG.srate + 1;
                tmpEEG.event(m+j).category = 'QEEG Segment';
            end   
            tmpEEG2 = pop_epoch(tmpEEG, {'start'}, [0 epochlen]);
            
            %}
            %{
            epochlen=3; %seconds 
            time = 0;
            n=0;
            extra = mod(tmpEEG.xmax,epochlen);%tmpEEG.xmax
            while time < tmpEEG.xmax - extra
                tmpEEG.event(1,n+1).type = 'test';
                tmpEEG.event(1,n+1).latency = n*epochlen*tmpEEG.srate+1;
                tmpEEG.event(1,n+1).urevent = 'fake';
         %       tmpEEG.event(1,n+1).category = 'fake_event';
                time = time+epochlen;
                n = n+1;
            end
            tmpEEG2 = pop_epoch( tmpEEG, {'test'}, [0 epochlen]);
            %}
            tmpEEG2 = eeg_regepochs(tmpEEG);
            pop_saveset(tmpEEG2,'filename',horzcat(EEG_datasetname(1:end-4),'_epochs.set'),'filepath',working_folder);
            filenames{i,1} = horzcat(EEG_datasetname(1:end-4),'_epochs.set');
            n_list{i,1} = n;
            disp(horzcat('==========File number ',num2str(i),' of ',num2str(subject_no),' complete============='));

        end
    catch
        z=1;
    end
end