function gui_batch_spec_coh_plot_partial_elec(xlsfile,analysisfile,freq_bin,batch_timebin,cohtype,method)
%%
[num,txt1,txt2]=xlsread(xlsfile);
subject_no=size(txt1,1);
h = waitbar(0,'Performing Coherence Analysis...');
for i=2:subject_no
    to_be_process_flag=cell2mat(txt1(i,3));
        if strcmp(to_be_process_flag,'yes')==1
            %Load Data
            working_folder=cell2mat(txt1(i,1));
            EEG_datasetname=cell2mat(txt1(i,2));
            tmpEEG=pop_loadset(EEG_datasetname,working_folder);
            warning off;
            
            %Resample
            if tmpEEG.srate~=512
                tmpEEG = pop_resample( tmpEEG, 512);
            end
            file_name=strcat(EEG_datasetname(1:end-4));
            
          %  [status] = coherence_bionect2(tmpEEG,file_name, working_folder, analysisfile,freq_bin,batch_timebin,method,cohtype);
            
            switch cohtype
                case 'magcoh'
                    [status] = coherence_bionect2(tmpEEG,file_name, working_folder, analysisfile,freq_bin,batch_timebin,method,cohtype);
              %  [status] = coherence_bionect3_imandriving(tmpEEG,file_name, working_folder, analysisfile,freq_bin,batch_timebin,method,cohtype);
            
                case 'imagcoh'
                    [status]=coherence_bionect2(tmpEEG,file_name, working_folder, analysisfile,freq_bin,batch_timebin,method,cohtype);
                case 'phasecoh'
                    [status]=coherence_phase(tmpEEG,file_name, working_folder, analysisfile,freq_bin,batch_timebin,method);
                case 'magcoh_cluster'
                    BNCT = evalin('base','BNCT');
                    if ~isfield(BNCT,'clustering');
                        gui_defineclusters;
                        uiwait;
                        BNCT = evalin('base','BNCT');
                        clusters = BNCT.clustering.clusters;
                        clusternames = BNCT.clustering.clusternames;
                    else
                        clusters = BNCT.clustering.clusters;
                        clusternames = BNCT.clustering.clusternames;
                    end
                    [status]=coherence_cluster(tmpEEG,file_name, working_folder, analysisfile,freq_bin,batch_timebin,clusters,clusternames);
                case 'psi'
                    gui_psi(tmpEEG,file_name, working_folder, analysisfile,freq_bin,batch_timebin,method);
            end
            waitbar(i/subject_no,h);
            %% Process Done
            
            range_xls=sprintf('J%i',i);
            xlswrite(xlsfile,num2str(tmpEEG.trials),1,range_xls);
            
            range_xls=sprintf('D%i',i);
            xlswrite(xlsfile,'1',1,range_xls);
            
            prog=strcat(num2str(i),'/',num2str(size(txt1,1)),'  has/have been plotted');
            sprintf('%s',prog)
            
            
        end
        
end
close(h)
end