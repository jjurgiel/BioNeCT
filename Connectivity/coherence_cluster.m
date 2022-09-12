function [status]=coherence_cluster(EEG,file_name, working_folder, analysisfile,freq_bin, batch_timebin,clusters,clusternames)
% updtaed 08/28/2015
%% 

status=0;
%elec_map=[4 12 20 1 5 9 13 17 21 25 2 6 10 14 18 22 26 3 7 11 15 19 23 27 8 16 24]; % basedhe on the scalp segmentation and the order of appearence 
elec_map=1:EEG.nbchan;
numclust = size(clusters,1);
%%
%======================================
% Calculating inter-electrode distannce
X_loc=[];Y_loc=[];Z_loc=[]; e_label=[]; phi_loc = [];theta_loc = [];r_loc=[]; clust_e_label = [];
for i=1:EEG.nbchan
   X_loc=[X_loc; EEG.chanlocs(i).X];
   Y_loc=[Y_loc; EEG.chanlocs(i).Y];
   Z_loc=[Z_loc; EEG.chanlocs(i).Z];
   e_label=[e_label {EEG.chanlocs(i).labels}];
  % [phi, theta, r] = cart2sph(EEG.chanlocs(i).X,EEG.chanlocs(i).Y,EEG.chanlocs(i).Z)
  % phi_loc = [phi_loc; phi];
  % theta_loc = [theta_loc;theta];
  % r_loc = [r_loc;r];
end
e_label = e_label(1:size(X_loc));
e_label2 = e_label;
for cnum = 1:size(clusters,1)
    for enum = 1:size(clusters{cnum},2)
        eindex{cnum}(enum) = find(strcmp(e_label2,clusters{cnum}(enum)));
    end
    clust_X_loc(cnum,1) = mean(X_loc(eindex{cnum}));
    clust_Y_loc(cnum,1) = mean(Y_loc(eindex{cnum}));
    clust_Z_loc(cnum,1) = mean(Z_loc(eindex{cnum}));
    %cluster_data
end
clust_e_label = clusternames';e_label(1:cnum);
[clust_e_label,dist_elec]=elec_distance(clust_e_label,clust_X_loc,clust_Y_loc,clust_Z_loc,0,0,0.0359); % (0,0,0.359) is the center of head inthe besa head model with radius 85mm
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
%elec_map_rev=(1:27); % it is not necessary 
mydata=EEG.data;
chn_no=EEG.nbchan;
Fs=EEG.srate;
F=1:1:Fs/2; % standard Frequency Spectrum

%if epoch_no < 10
%    epoch_no = 10;
%end
% tb from the beginging of the epoch
%{
tb = [time_start:time_bin_size:(no_time_bins*time_bin_size)+time_start];  % how many time bins in msec

time_bin=[];
for k=1:no_time_bins
  %   time_bin=[time_bin tb(k)];
     time_bin(k,1:2) = [tb(k) tb(k+1)];
end
%}
%% Defining/averaging clusters
%for cnum = 1:size(clusters,1)
%    for enum = 1:size(clusters{cnum},2)
%        eindex{cnum}(enum) = find(strcmp(e_label2,clusters{cnum}(enum)));
%    end
    %cluster_data
%end

%Cluster locations

%%
time_bin = batch_timebin;
%time_bin=time_bin*Fs/1000;
%time_bin=reshape(time_bin,no_time_bins,2);
%time_bin = [0 prestim;time_bin];
time_bin_no=size(time_bin,1); % no of bins
clc;
if isempty(freq_bin) ==1
   freq_bin=[8  12]; % start and end of each freq bin ( does not einclude the end point) 
end

freq_bin_no=size(freq_bin,1); % no of freq bins

avg_coh=zeros(1,Fs/2);
raster_mat=[];
raster_mat_induced=[];
raster_signal=[]; counter=0;
raster_mat_avg_coh=[]; % for thresholding 
raster_mat_avg_coh_induced=[];
seg_length=(time_bin(2)-time_bin(1))*1000/Fs; 


%%

% Computing Averages Per Time Bins
%avg_chn=zeros(chn_no,time_bin_no,seg_length*Fs/1000); tmp_signal=zeros(1,seg_length*Fs/1000);
% for i=1:chn_no-1
%   for tb=1:time_bin_no  
%     tmp_signal=zeros(1,seg_length*Fs/1000);
%     for k=1:epoch_no
%         x=mydata(i,:,k);
%         x_bin=x(time_bin(tb,1)+1:time_bin(tb,2));
%         tmp_signal=tmp_signal+x_bin;               
%     end
%         avg_chn(i,tb,:)=tmp_signal/epoch_no;
%   end
% end

%% Computing Averages Per total time interval


%avg_chn_thr=zeros(chn_no,total_data_length*Fs/1000); tmp_signal=zeros(1,seg_length*Fs/1000);
% for i=1:chn_no-1
%     for tb=1:1  
%     tmp_signal=zeros(1,total_data_length*Fs/1000);
%     for k=1:epoch_no
%         x=mydata(i,:,k);
%         x_bin=x(time_bin_avg(tb,1)+1:time_bin_avg(tb,2));
%         tmp_signal=tmp_signal+x_bin;               
%     end
%         avg_chn_thr(i,:)=tmp_signal/epoch_no;
%     end  
% end


%% Coherence Calculation
%====================================================================
for i=1:size(clusters,1)-1
     k=strcat('Calculating Evoked and Induced Coherences for Channel Number ....', num2str(i));
     disp(k)
     for j=i+1:size(clusters,1)
        if (i~=j)
         %for tb=1:time_bin_no

           avg_coh=zeros(1,length(F));   
           avg_coh_induced=zeros(1,length(F));   
             x = mean(mydata(eindex{i},:,:));
             y = mean(mydata(eindex{j},:,:));
            % x=mydata(i,:,:);
            % y=mydata(j,:,:);
             
             x_data_sq=squeeze(x);                                 %squeeze all data at frames in trial 1                        
             y_data_sq=squeeze(y);                                 %squeeze all data at frames in trial 1                        
           
             x_bin = reshape( x_data_sq, 1, size(x_data_sq,1)*size(x_data_sq,2));
             y_bin = reshape( y_data_sq, 1, size(y_data_sq,1)*size(y_data_sq,2));
   

             x_bin_induced=x_bin-mean(x_bin);
             y_bin_induced=y_bin-mean(y_bin);
             
             
             
           %  no_f=min(pow2(nextpow2(Fs/2)-1),time_bin(tb,2) - time_bin(tb,1));
        %     [Ctxy,mcoh,timesout,f,cohboot,cohangles,allcoher,alltfX,alltfY] = newcrossf(x_bin,y_bin, time_bin(tb,2)-time_bin(tb,1), [time_bin(tb,1) time_bin(tb,2)] ,Fs,0,'newfig','off','plotamp','off','plotphase','off','type','coher','nfreqs',no_f,'freqs',[0 Fs/2]);  
         %    [Ctxy_induced,mcoh_induced,timesout_induced,f,cohboot_induced,cohangles_induced,allcoher_induced,alltfX_induced,alltfY_induced] = newcrossf(x_bin_induced,y_bin_induced, time_bin(tb,2)-time_bin(tb,1), [time_bin(tb,1) time_bin(tb,2)] ,Fs,0,'newfig','off','plotamp','off','plotphase','off','type','coher','nfreqs',no_f,'freqs',[0 Fs/2]);  
              
              [Ctxy,mcoh,timesout,f,cohboot,cohangles,allcoher,alltfX,alltfY] = newcrossf(x_bin,y_bin, EEG.pnts, [EEG.xmin EEG.xmax]*1000 ,EEG.srate,0,...
                  'newfig','off','plotamp','off','plotphase','off','type','coher','winsize',256);  
             
              
             % average accross time points ; Ctxy (freq x time)
             Cxy=Ctxy; %mean(Ctxy,2);
     
                   
           %  Cxy_new=spline(f,Cxy,F); % for having the same length of coherence for all loops
           Cxy_new=Cxy;
           
             ind_chk=find(Cxy_new>1); 
             
             
             
                 if isempty(ind_chk)==0 
                     Cxy_new(ind_chk)=1;
                 end
                 
          %   Cxy_new_induced=spline(f,Cxy_induced,F); % for having the same length of coherence for all loops
 
    
             
                 
                 % reduced coherence based on Paul L. Nunez paper
                 % P.L. Nunez et al. / Electroencephalography and clinical Neurophysiology 103 (1997) 499–515
                 %
                 vol_cond=[1 3];
             if vol_cond(1)==1  
                 a=vol_cond(2); 
                 reduced_coh=exp((1-dist_elec(i,j))/a);
                 Cxy_new=Cxy_new-reduced_coh;
                 ind_chk=find(Cxy_new<0); 
                 if isempty(ind_chk)==0 
                     Cxy_new(ind_chk)=0;
                 end
                 
    
               
%                 
             end
                 %}
                 
                                 
             avg_coh=Cxy_new; % this is the sum for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq 
        % this is the sum for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq 

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
         %freqlist = 
        end
        %if j == 66
        %    x=5;
        %end
        end
        
     
end

%%  Auto-Coherence values are set to 1
%for i=1:chn_no
%  new_i=find(elec_map==i);new_j=find(elec_map==i);
  raster_mat(new_j,new_j,:,:)=1; % exp((1-dist_elec(chn_no,chn_no))/a);


%end
raster_mat(isnan(raster_mat))=0;


%%  Electrode Relabeling 
elec_label_y={};
for l=chn_no:-1:1
   tmp=EEG.chanlocs(elec_map(l)).labels;
   tmp=strrep(tmp,'_RFR','');
   elec_label_y=[elec_label_y {EEG.chanlocs(elec_map(l)).labels}];
end

elec_label_x={};
for l=1:chn_no
   tmp=EEG.chanlocs(elec_map(l)).labels;
   tmp=strrep(tmp,'_RFR','');
   elec_label_x=[elec_label_x {tmp}];
end


%%
%============================================================

mkdir(strcat(working_folder,'\',analysisfile));
matfile=strcat(working_folder,'\',analysisfile,'\',file_name,'_CohValue_Cluster.mat');
save(matfile, 'freq_bin', 'time_bin','raster_mat','raw_coh','timelist','freqlist','e_label','clusters');
%close all;
status=1;
end