function [status]=coherence_phase(EEG,file_name, working_folder, analysisfile, percent_data,freq_bin, vol_cond,prestim, time_bin_avg,batch_timebin,method)
% updtaed 08/28/2015
%%

status=0;
elec_map=1:EEG.nbchan;
%%
%======================================
% Calculating inter-electrode distannce
X_loc=[];Y_loc=[];Z_loc=[]; e_label=[];
for i=1:EEG.nbchan
    X_loc=[X_loc; EEG.chanlocs(i).X];
    Y_loc=[Y_loc; EEG.chanlocs(i).Y];
    Z_loc=[Z_loc; EEG.chanlocs(i).Z];
    e_label=[e_label {EEG.chanlocs(i).labels}];
    
end
e_label = e_label(1:size(X_loc));
[e_label,dist_elec]=elec_distance(e_label,X_loc,Y_loc,Z_loc,0,0,0.0359); % (0,0,0.359) is the center of head inthe besa head model with radius 85mm
%Convert to cm
%% Will need to change if situations with only region of electrode used
if max(max(dist_elec)) < 1 %if its in meters
    dist_elec=dist_elec*100;
elseif max(max(dist_elec)) > 1 && max(max(dist_elec)) < 10 %decimeters
    dist_elec=dist_elec*10;
elseif max(max(dist_elec)) > 100%if its in mm
    dist_elec=dist_elec/10;
end

%%
mydata=EEG.data;
chn_no=EEG.nbchan;
Fs=EEG.srate;
F=1:1:Fs/2; % standard Frequency Spectrum

epoch_no=(EEG.trials)*percent_data/100; epoch_no=round(epoch_no);
time_bin = batch_timebin;
prestim=prestim *(Fs/1000); % converting to sample
time_bin_no=size(time_bin,1); % no of bins
clc;
if isempty(freq_bin) ==1
    freq_bin=[8  12]; % start and end of each freq bin ( does not einclude the end point)
end

freq_bin_no=size(freq_bin,1); % no of freq bins

avg_coh=zeros(1,Fs/2);
raster_mat=[];
raster_signal=[]; counter=0;
raster_mat_avg_coh=[]; % for thresholding
seg_length=(time_bin(2)-time_bin(1))*1000/Fs;


total_data_length=time_bin_avg(2)-time_bin_avg(1);time_bin_avg=time_bin_avg*Fs/1000;

%% Coherence Calculation
%====================================================================
for i=1:chn_no-1
    k=strcat('Calculating Coherences for Channel Number ....', num2str(i));
    disp(k)
    for j=i+1:chn_no
        if (i~=j)
            %for tb=1:time_bin_no
            
            avg_coh=zeros(1,length(F));
            x=mydata(i,:,:);
            y=mydata(j,:,:);
            x_data_sq=squeeze(x);                                 %squeeze all data at frames in trial 1
            y_data_sq=squeeze(y);                                 %squeeze all data at frames in trial 1
            x_bin = reshape( x_data_sq, 1, size(x_data_sq,1)*size(x_data_sq,2));
            y_bin = reshape( y_data_sq, 1, size(y_data_sq,1)*size(y_data_sq,2));
            
            [Ctxy,mcoh,timesout,f,cohboot,cohangles,allcoher,alltfX,alltfY] = newcrossf(x_bin,y_bin, EEG.pnts, [EEG.xmin EEG.xmax]*1000 ,EEG.srate,0,...
                'newfig','off','plotamp','off','plotphase','off','type','phasecoher','winsize',256);
 
            imagcoh = 1; %GIORGIA EDIT THIS to 0 or 1
            if imagcoh==1
                Cxy = abs(Ctxy.*sin(cohangles)); %|Ctxy| * sin(Theta)
                vol_cond(1) = 0;
            else
                Cxy=Ctxy; 
            end
            
            Cxy_new=Cxy;
            ind_chk=find(Cxy_new>1);
            if isempty(ind_chk)==0
                Cxy_new(ind_chk)=1;
            end
            
            % reduced coherence based on Paul L. Nunez paper
            % P.L. Nunez et al. / Electroencephalography and clinical Neurophysiology 103 (1997) 499–515
            %
            if vol_cond(1)==1
                a=vol_cond(2);
                reduced_coh=exp((1-dist_elec(i,j))/a);
                Cxy_new=Cxy_new-reduced_coh;
                ind_chk=find(Cxy_new<0);
                if isempty(ind_chk)==0
                    Cxy_new(ind_chk)=0;
                end
            end

            avg_coh=Cxy_new; % this is the sum for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq

            for tb=1:time_bin_no
                ind_time=find(timesout>=time_bin(tb,1) & timesout<=time_bin(tb,2));
                for fb=1:freq_bin_no
                    ind=find(f>= freq_bin(fb,1) & f<=freq_bin(fb,2)); % finding indices for each frequecny bin
                    new_i=find(elec_map==i);new_j=find(elec_map==j); % new_i and new_j are indices of the electrodes based on their apperance in the raster plot
                    mm= mean(mean(avg_coh(ind,ind_time)));       % averaging the coherence values in frquecny bin =fb
                    
                    if mm>1
                        disp('wrong')
                    end
                    raster_mat(new_i,new_j,tb,fb)=mm;
                    raster_mat(new_j,new_i,tb,fb)=raster_mat(new_i,new_j,tb,fb);       % averaging the coherence values in frquecny bin =fb
                    raster_mat(new_i,new_i,tb,fb)=1;
                    
                end
                
            end
            
            raw_coh{i,j} = avg_coh;
            timelist = timesout;
            freqlist = f;
        end
    end
    
    
end

%%  Auto-Coherence values are set to 1
for i=1:chn_no
    new_i=find(elec_map==i);new_j=find(elec_map==i);
    raster_mat(new_i,new_j,:,:)=1; % exp((1-dist_elec(chn_no,chn_no))/a);
end
raster_mat(isnan(raster_mat))=0;


%%
%============================================================

mkdir(strcat(working_folder,'\',analysisfile));
if imagcoh == 1
    matfile=strcat(working_folder,'\',analysisfile,'\',file_name,'_ImagCohValueCS.mat');
    save(matfile, 'freq_bin', 'time_bin','raster_mat','raw_coh','timelist','freqlist','e_label');
else
    matfile=strcat(working_folder,'\',analysisfile,'\',file_name,'_PhaseCohValueCS.mat');
    save(matfile, 'freq_bin', 'time_bin','raster_mat','raw_coh','timelist','freqlist','e_label');
end
%close all;
status=1;
end