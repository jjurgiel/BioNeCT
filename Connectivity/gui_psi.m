function [status]=gui_psi(EEG,file_name, working_folder, analysisfile, percent_data,freq_bin, vol_cond,prestim, time_bin_avg,batch_timebin,method)
% updtaed 08/28/2015
%% 
status=0;
%elec_map=[4 12 20 1 5 9 13 17 21 25 2 6 10 14 18 22 26 3 7 11 15 19 23 27 8 16 24]; % basedhe on the scalp segmentation and the order of appearence 
switch method
    case 'source'
        chn_no = size(EEG.icaact,1);
        elec_map = 1:size(EEG.icaact,1);
        X_loc=[];Y_loc=[];Z_loc=[]; e_label=[];
        for i=1:chn_no
            X_loc=[X_loc; EEG.dipfit.model(1,i).posxyz(1)];
            Y_loc=[Y_loc; EEG.dipfit.model(1,i).posxyz(2)];
            Z_loc=[Z_loc; EEG.dipfit.model(1,i).posxyz(3)];
            e_label=[e_label {i}];
            
        end
        e_label = e_label(1:size(X_loc));
        
        mydata = EEG.icaact;
    case 'channel'
        elec_map=1:EEG.nbchan;
        chn_no = EEG.nbchan;
        X_loc=[];Y_loc=[];Z_loc=[]; e_label=[];
        for i=1:EEG.nbchan
            X_loc=[X_loc; EEG.chanlocs(i).X];
            Y_loc=[Y_loc; EEG.chanlocs(i).Y];
            Z_loc=[Z_loc; EEG.chanlocs(i).Z];
            e_label=[e_label {EEG.chanlocs(i).labels}];
            
        end
        e_label = e_label(1:size(X_loc));
        
        mydata=EEG.data;
        [e_label,dist_elec]=elec_distance(e_label,X_loc,Y_loc,Z_loc,0,0,0.0359); % (0,0,0.359) is the center of head inthe besa head model with radius 85mm

        
        %%
        %======================================
        % Calculating inter-electrode distannce
        
        %Convert to cm
        % Will need to change if situations with only region of electrode used
        if max(max(dist_elec)) < 1 %if its in meters
            dist_elec=dist_elec*100;
        elseif max(max(dist_elec)) > 1 && max(max(dist_elec)) < 10 %decimeters
            dist_elec=dist_elec*10;
        elseif max(max(dist_elec)) > 100%if its in mm
            dist_elec=dist_elec/10;
        end
        
end
Fs=EEG.srate;

data = reshape( mydata, size(mydata,1), size(mydata,2)*size(mydata,3));
data = data';
freq_bin_no=size(freq_bin,1); % no of freq bins
segleng = Fs;
epleng = Fs;
for a=1:freq_bin_no
    freqs = freq_bin(a,1):freq_bin(a,2);
    [psi, stdpsi, psisum, stdpsisum]=data2psi(data,segleng,epleng,freqs);
    raster_mat(:,:,1,a) = psi./(stdpsi+eps);
    raster_mat(isnan(raster_mat))=0;
end


%%
%============================================================

mkdir(strcat(working_folder,'\',analysisfile));
matfile=strcat(working_folder,'\',analysisfile,'\',file_name,'_PSIValueCS.mat');
save(matfile, 'freq_bin','raster_mat');
%close all;
status=1;
%end