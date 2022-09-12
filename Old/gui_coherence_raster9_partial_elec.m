function [status]=gui_coherence_raster9_partial_elec(EEG,file_name, working_folder, analysisfile, percent_data,freq_bin, vol_cond,prestim, time_bin_avg, batch_timebin)%time_bin_size, time_start)
% updtaed 01/27/2012

status=0;
%elec_map=[4 12 20 1 5 9 13 17 21 25 2 6 10 14 18 22 26 3 7 11 15 19 23 27 8 16 24]; % basedhe on the scalp segmentation and the order of appearence 
elec_map=1:EEG.nbchan;
%======================================
% Calculating inter-electrode distannce
X_loc=[];Y_loc=[];Z_loc=[]; e_label=[];
for i=1:EEG.nbchan
   X_loc=[X_loc; EEG.chanlocs(i).X];
   Y_loc=[Y_loc; EEG.chanlocs(i).Y];
   Z_loc=[Z_loc; EEG.chanlocs(i).Z];
   e_label=[e_label {EEG.chanlocs(i).labels}];
end
[e_label,dist_elec]=elec_distance(e_label,X_loc,Y_loc,Z_loc,0,0,0.0359); % (0,0,0.359) is the center of head inthe besa head model with radius 85mm
dist_elec=dist_elec*100; % coverting to cm
%=======================================

elec_map_rev=(1:27);
mydata=EEG.data;
chn_no=EEG.nbchan;
Fs=EEG.srate; 
F=1:1:Fs/2; % standard Frequency Spectrum
k=strcat(' The total number of trials is : ',num2str(EEG.trials),' . How many percentage of the trails do you want to use for the coherence analysis [0 = Zero Percent...100= 100%]> ');
disp(k);
%percent_data=input(k);

%if epoch_no = 0?
%   OUTEEG = pop_epoch(EEG)
%   epoch_no=(EEG.trials)*percent_data/100; epoch_no=round(epoch_no);
%else
epoch_no=(EEG.trials)*percent_data/100; epoch_no=round(epoch_no);

if epoch_no < 5
%    epoch_no = 5;
end
%end

% you can modify the time resolution here
%Stimulus present at 500ms
%time_bin=[500 1500; 1500 2500; 2500 3500; 3500 4500; 4500 5500; 5500 6500 ; 6500 7500; 7500 8500;7500 8500 ]* (Fs/1000); % start and end of each epoch bin
%time_bin=[500 600; 600 700; 700 800; 800 900;900 1000; 1100 1200; 1200 1300; 1300 1400; 1400 1500 ]* (Fs/1000); % start and end of each epoch bin
time_bin=[ 500 1500; 1500 2500; 2500 3500;3500 4500; 4500 5500; 5500 6500; 6500 7500;7500 8500;7500 8500]* (Fs/1000); % each epoch bin
time_start = 500;
time_bin_size = 1000;
tb = [time_start:time_bin_size:9*time_bin_size];
%time_bin = [time_start tb(2);tb(2) tb(3);tb(3) tb(4);tb(4) tb(5);tb(5) tb(6);tb(6) tb(7);tb(7) tb(8);tb(8) tb(9);tb(8) tb(9)] * (Fs/1000);
%time_bin=[600 800; 800 1000; 1000 1200; 1200 1400; 1400 1600; 1600 1800; 1800 2000; 2000 2200; 2200 2400; ]* (Fs/1000); % start and end of each epoch bin
%time_bin=[400 600; 600 800; 800 1000; 1000 1200;1200 1400;]* (Fs/1000); % start and end of each epoch bin
%time_bin=[ 0 500; 500 1000; 1000 1500;1500 2000; 2000 2500; 2500 3000; 3000 3500;3500 4000;4000 4500]* (Fs/1000); 


prestim=prestim *(Fs/1000);
time_bin_no=size(time_bin);time_bin_no=time_bin_no(1); % no of bins
clc
%freq_bin=input('Enter  Freq Bin (i.e. [6 8; 8 10; 10 12; 6 12; 35 45] ) you want to continue proceed with that:> ');

if isempty(freq_bin) ==1
   freq_bin=[8  12]; % start and end of each freq bin ( does not einclude the end point) 
end

freq_bin_no=size(freq_bin);freq_bin_no=freq_bin_no(1); % no of freq bins
avg_coh=zeros(1,Fs/2);

raster_mat=[];
raster_mat_induced=[];
raster_signal=[]; counter=0;
raster_mat_avg_coh=[]; % for thresholding 
raster_mat_avg_coh_induced=[];
seg_length=(time_bin(2)-time_bin(1))*1000/Fs; 
total_data_length=time_bin_avg(2)-time_bin_avg(1);time_bin_avg=time_bin_avg*Fs/1000;
%=====================================================================
% Computing Averages Per Time Bins
avg_chn=zeros(chn_no,time_bin_no,seg_length*Fs/1000); tmp_signal=zeros(1,seg_length*Fs/1000);
for i=1:chn_no-1
  for tb=1:time_bin_no  
    tmp_signal=zeros(1,seg_length*Fs/1000);
    for k=1:epoch_no
        x=mydata(i,:,k);
        x_bin=x(time_bin(tb,1)+1:time_bin(tb,2));
        tmp_signal=tmp_signal+x_bin;               
    end
        avg_chn(i,tb,:)=tmp_signal/epoch_no;
  end
end

% Computing Averages PEr total time interval

%time_bin_avg=[100 1000]*Fs/1000;

avg_chn_thr=zeros(chn_no,total_data_length*Fs/1000); tmp_signal=zeros(1,seg_length*Fs/1000);
for i=1:chn_no-1
    for tb=1:1  
    tmp_signal=zeros(1,total_data_length*Fs/1000);
    for k=1:epoch_no
        x=mydata(i,:,k);
        x_bin=x(time_bin_avg(tb,1)+1:time_bin_avg(tb,2));
        tmp_signal=tmp_signal+x_bin;               
    end
        avg_chn_thr(i,:)=tmp_signal/epoch_no;
    end  
end
%====================================================================
for i=1:chn_no-1
     k=strcat('Calculating Evoked and Induced Coherences for Channel Number ....', num2str(i));
     disp(k)
     for j=i+1:chn_no
        if (i~=j)
         for tb=1:time_bin_no          
           avg_coh=zeros(1,length(F));   
           avg_coh_induced=zeros(1,length(F));   

           for k=1:epoch_no
         
                 x=mydata(i,:,k);
                 y=mydata(j,:,k);
                 x_bin=x(time_bin(tb,1)+1:time_bin(tb,2));
                 y_bin=y(time_bin(tb,1)+1:time_bin(tb,2));
                 
                 avg_x_bin=squeeze(avg_chn(i,tb,:))';
                 avg_y_bin=squeeze(avg_chn(j,tb,:))';

                 x_bin_induced=x_bin-avg_x_bin;
                 y_bin_induced=y_bin-avg_y_bin;
                 
                 
                 [Cxy,f] = mscohere(x_bin,y_bin,[],[],[],Fs);
                 [Cxy_induced,f] = mscohere(x_bin_induced,y_bin_induced,[],[],[],Fs);

                 Cxy_new=spline(f,Cxy,F); % for having the same length of coherence for all loops
                 ind_chk=find(Cxy_new>1); 
                 if isempty(ind_chk)==0 
                     Cxy_new(ind_chk)=1;
                 end
                 
                 Cxy_new_induced=spline(f,Cxy_induced,F); % for having the same length of coherence for all loops
                 ind_chk_induced=find(Cxy_new_induced>1); 
                 if isempty(ind_chk_induced)==0 
                     Cxy_new_induced(ind_chk)=1;
                 end
                 
                 
                 % reduced coherence based on Paul L. Nunez paper
                 % P.L. Nunez et al. / Electroencephalography and clinical Neurophysiology 103 (1997) 499–515
               if vol_cond(1)==1  
                 a=vol_cond(2); 
                 reduced_coh=exp((1-dist_elec(i,j))/a);
                 Cxy_new=Cxy_new-reduced_coh;
                 ind_chk=find(Cxy_new<0); 
                 if isempty(ind_chk)==0 
                     Cxy_new(ind_chk)=0;
                 end
                 
                 Cxy_new_induced=Cxy_new_induced-reduced_coh;
                 ind_chk=find(Cxy_new_induced<0); 
                 if isempty(ind_chk)==0 
                     Cxy_new_induced(ind_chk)=0;
                 end
               
%                 
               end
                 
                 
                                 
                 avg_coh=avg_coh+Cxy_new; % this is the sum for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq 
                 avg_coh_induced=avg_coh_induced+Cxy_new_induced; % this is the sum for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq 

                        
           end
                 avg_coh=avg_coh./epoch_no; % % this is the average for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq
                 avg_coh_induced=avg_coh_induced./epoch_no; % % this is the average for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq

                 
                 for fb=1:freq_bin_no
                     ind=find(F>= freq_bin(fb,1) & F<=freq_bin(fb,2)); % finding indices for each frequecny bin 
                     new_i=find(elec_map==i);new_j=find(elec_map==j); % new_i and new_j are indices of the electrodes based on their apperance in the raster plot
                     mm= mean(avg_coh(ind));       % averaging the coherence values in frquecny bin =fb  
                     mm_induced=mean(avg_coh_induced(ind));
                     
                     if mm>1
                         disp('wrong')
                     end
                     raster_mat(new_i,new_j,tb,fb)=mm;
                     raster_mat(new_j,new_i,tb,fb)=raster_mat(new_i,new_j,tb,fb);       % averaging the coherence values in frquecny bin =fb  
                     raster_mat(new_i,new_i,tb,fb)=1;
                     
                     raster_mat_induced(new_i,new_j,tb,fb)=mm_induced;
                     raster_mat_induced(new_j,new_i,tb,fb)=raster_mat_induced(new_i,new_j,tb,fb);       % averaging the coherence values in frquecny bin =fb  
                     raster_mat_induced(new_i,new_i,tb,fb)=1;
                 end
                  
         end
        end
        
     end
end
%  Auto-Coherence values are set to 1
for i=1:chn_no
  new_i=find(elec_map==i);new_j=find(elec_map==i);
  raster_mat(new_i,new_j,:,:)=1; % exp((1-dist_elec(chn_no,chn_no))/a);
  raster_mat_induced(new_i,new_j,:,:)=1; % exp((1-dist_elec(chn_no,chn_no))/a);

end




%file_name=strrep(EEG.filename,'.set','');
savefile=strcat(working_folder,'\',file_name,'.pdf'); % creating PDF flile 

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


%========================== thresholding 
% thereshold for coherence based on Ding paper

%time_bin_avg=[100 1000]*Fs/1000; % start and end of each epoch bin
time_bin_no_avg=size(time_bin_avg);time_bin_no_avg=time_bin_no_avg(1); % no of bins

for i=1:chn_no-1
     k=strcat('Calculating Threshold for Evoked Coherence....', num2str(i));
     disp(k)
     for j=i+1:chn_no
        if (i~=j)
         for tb=1:time_bin_no_avg          
           avg_coh=zeros(1,length(F));   
           for k=1:epoch_no
         
                 x=mydata(i,:,k);
                 y=mydata(j,:,k);
                 x_bin=x(time_bin_avg(tb,1)+1:time_bin_avg(tb,2));
                 y_bin=y(time_bin_avg(tb,1)+1:time_bin_avg(tb,2));
                 [Cxy,f] = mscohere(x_bin,y_bin,[],[],[],Fs);
                 Cxy_new=spline(f,Cxy,F); % for having the same length of coherence for all loops
                 ind_chk=find(Cxy_new>1); 
                 if isempty(ind_chk)==0 
                     Cxy_new(ind_chk)=1;
                 end
                 
                 % reduced coherence based on Paul L. Nunez paper
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
                                  
                 avg_coh=avg_coh+Cxy_new; % this is the sum for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq 
                        
           end
                 avg_coh=avg_coh./epoch_no; % % this is the average for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq
                 for fb=1:freq_bin_no
                     ind=find(F>= freq_bin(fb,1) & F<freq_bin(fb,2)); % finding indices for each frequecny bin 
                     new_i=find(elec_map==i);new_j=find(elec_map==j);
                     mm= mean(avg_coh(ind));       % averaging the coherence values in frquecny bin =fb  
                     if mm>1
                         disp('wrong')
                     end
                     raster_mat_avg_coh(new_i,new_j,tb,fb)=mm;
                     raster_mat_avg_coh(new_j,new_i,tb,fb)=raster_mat(new_i,new_j,tb,fb);       % averaging the coherence values in frquecny bin =fb  
                     raster_mat_avg_coh(new_i,new_i,tb,fb)=1;
                 end
                  
         end
        end
        
     end
end
% Removing Auto-Coherence values 
for i=1:chn_no
  new_i=find(elec_map==i);new_j=find(elec_map==i);
  raster_mat_avg_coh(new_i,new_j,:,:)=0; % exp((1-dist_elec(chn_no,chn_no))/a);
end


% threshold is achieved by averaging all over the coherence values for the one freq_bin and all time_bins 
mean_thr=[];std_thr=0; coh_avg_value=[];
for fb=1:freq_bin_no
    for i=1:chn_no-1
     for j=i+1:chn_no
         coh_avg_value=[coh_avg_value,raster_mat_avg_coh(i,j,1,fb)];
         
     end
    end
      
     mean_thr(fb)=mean(coh_avg_value);
     std_thr(fb)=std(coh_avg_value);
end      


%=========THRESHOLDING FOR INDUCED COHERENCE  ==============
%========================== thresholding 
% thereshold for coherence based on Ding paper

%time_bin_avg=[100 1000]*Fs/1000; % start and end of each epoch bin
time_bin_no_avg=size(time_bin_avg);time_bin_no_avg=time_bin_no_avg(1); % no of bins

for i=1:chn_no-1
     k=strcat('Calculating Threshold for Induced Coherence.....', num2str(i));
     disp(k)
     for j=i+1:chn_no
        if (i~=j)
         for tb=1:time_bin_no_avg          
           avg_coh=zeros(1,length(F));   
           for k=1:epoch_no
         
                 x=mydata(i,:,k);
                 y=mydata(j,:,k);
                 avg_x=avg_chn_thr(i,:);
                 avg_y=avg_chn_thr(j,:);
                 
                 x_bin=x(time_bin_avg(tb,1)+1:time_bin_avg(tb,2))-avg_x;
                 y_bin=y(time_bin_avg(tb,1)+1:time_bin_avg(tb,2))-avg_y;
                 [Cxy,f] = mscohere(x_bin,y_bin,[],[],[],Fs);
                 Cxy_new=spline(f,Cxy,F); % for having the same length of coherence for all loops
                 ind_chk=find(Cxy_new>1); 
                 if isempty(ind_chk)==0 
                     Cxy_new(ind_chk)=1;
                 end
                 
                 % reduced coherence based on Paul L. Nunez paper
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
                                  
                 avg_coh=avg_coh+Cxy_new; % this is the sum for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq 
                        
           end
                 avg_coh=avg_coh./epoch_no; % % this is the average for coherence btw channel i and j for all epochs in the time bin (tb) and for all freq
                 for fb=1:freq_bin_no
                     ind=find(F>= freq_bin(fb,1) & F<freq_bin(fb,2)); % finding indices for each frequecny bin 
                     new_i=find(elec_map==i);new_j=find(elec_map==j);
                     mm= mean(avg_coh(ind));       % averaging the coherence values in frquecny bin =fb  
                     if mm>1
                         disp('wrong')
                     end
                     raster_mat_avg_coh_induced(new_i,new_j,tb,fb)=mm;
                     raster_mat_avg_coh_induced(new_j,new_i,tb,fb)=raster_mat(new_i,new_j,tb,fb);       % averaging the coherence values in frquecny bin =fb  
                     raster_mat_avg_coh_induced(new_i,new_i,tb,fb)=1;
                 end
                  
         end
        end
        
     end
end
% Removing Auto-Coherence values 
for i=1:chn_no
  new_i=find(elec_map==i);new_j=find(elec_map==i);
  raster_mat_avg_coh_induced(new_i,new_j,:,:)=0; % exp((1-dist_elec(chn_no,chn_no))/a);
end


% threshold is achieved by averaging all over the coherence values for the one freq_bin and all time_bins 
mean_thr_induced=[];std_thr_induced=0; coh_avg_value=[];
for fb=1:freq_bin_no
    for i=1:chn_no-1
     for j=i+1:chn_no
         coh_avg_value=[coh_avg_value,raster_mat_avg_coh_induced(i,j,1,fb)];
         
     end
    end
      
     mean_thr_induced(fb)=mean(coh_avg_value);
     std_thr_induced(fb)=std(coh_avg_value);
end  

%============================================================


 
%==============================================
%Raster Plot
%{
for j=1:freq_bin_no
    figure;
    scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);
    %m=0;s=0;
    clf
    %im=imread('C:\Iman Work\CMB Projects\Yukari Project\Electrodes Map\electrode map 150 dpi flattened.tif');
    %axes('position',[0,.6,.1,0.63])
    %imshow(im)
    %hold on;
    for i=1:time_bin_no
       
       subplot(3,3,i);
       %suptitle('Raster plot of Coherence Elevation During Experiment');
       k=strcat('Freq: ', num2str(freq_bin(j,1)), '->', num2str(freq_bin(j,2)), 'Hz. TF:', num2str((time_bin(i,1)-prestim)*1000/Fs), '->' ,num2str((time_bin(i,2)-prestim)*1000/Fs), 'msec' ); 
       imagesc(raster_mat(:,:,i,j));
       set(gca,'YTick',[1:length(elec_map)],'YTickLabel',elec_label_x)
       set(gca,'XTick',[1:length(elec_map)],'XTickLabel',elec_label_x)
       title(k)
       colorbar('EastOutside')
     %  m=m+mean(mean(raster_mat(:,:,i,j)));
      % s=s+mean(std(raster_mat(:,:,i,j)));
   end;
   %mean_thr(j)=m/time_bin_no;std_thr(j)=s/time_bin_no;
     %export_fig (savefile,'-append', '-transparent')
 
end
%}
%=================================================
%Raster Plot for induced 
%{
for j=1:freq_bin_no
    figure;
    scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);
    %m=0;s=0;
    clf
%     im=imread('C:\Iman Work\CMB Projects\Yukari Project\Electrodes Map\electrode map 150 dpi flattened.tif');
%     axes('position',[0,.6,.1,0.63])
%     imshow(im)
%     hold on;
    for i=1:time_bin_no
       
       subplot(3,3,i);
       %suptitle('Raster plot of Coherence Elevation During Experiment');
       k=strcat('INDUCED Freq: ', num2str(freq_bin(j,1)), '->', num2str(freq_bin(j,2)), 'Hz. TF:', num2str((time_bin(i,1)-prestim)*1000/Fs), '->' ,num2str((time_bin(i,2)-prestim)*1000/Fs), 'msec' ); 
       imagesc(raster_mat_induced(:,:,i,j));
       set(gca,'YTick',[1:length(elec_map)],'YTickLabel',elec_label_x)
       set(gca,'XTick',[1:length(elec_map)],'XTickLabel',elec_label_x)
       title(k)
       colorbar('EastOutside')
     %  m=m+mean(mean(raster_mat(:,:,i,j)));
      % s=s+mean(std(raster_mat(:,:,i,j)));
   end;
   %mean_thr(j)=m/time_bin_no;std_thr(j)=s/time_bin_no;
     %export_fig (savefile,'-append', '-transparent')

     
end
%}
%==================================================
% Drawing Coherence map

%{
% desired_freq_bin=input('Enter Freq Bin Number (ie. 1 or 2 ,...) you want to continue proceed with that:> ');
high_node_weight=zeros(time_bin_no,freq_bin_no,chn_no);
low_node_weight=zeros(time_bin_no,freq_bin_no,chn_no);
for j=1:freq_bin_no
    figure;
    scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);

    for i=1:time_bin_no
        thr1=mean_thr(j)+(2*std_thr(j)); % thereshold for coherence based on Ding paper
        thr2=mean_thr(j)-(2*std_thr(j)); % for finding desync regions 
        
       % k=strcat('the connectivity plot based on the original raster plot using thershold value :>  ',num2str(thr1));
        %title(k);
        ras=raster_mat(:,:,i,j);
        
        subplot(3,3,i);
%         suptitle('Topography of Coherence Elevation During Experiment(Blue lines: High Significant Connections. Red lines : Low Significant Connections)');
        k=strcat('Freq: ', num2str(freq_bin(j,1)), '->', num2str(freq_bin(j,2)), ' TF:', num2str((time_bin(i,1)-prestim)*1000/Fs), '->' ,num2str((time_bin(i,2)-prestim)*1000/Fs), 'ms thr:  ',num2str(thr1) ); 
        title(k);
        [x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','numbers');z_elec = ones(size(x_elec))*2.1;
        hold on; plot3(y_elec,x_elec,z_elec,'.r');
        for ii=1:chn_no-1
                
               for jj=i+1:chn_no
                  if ii~=jj
                    new_ii=elec_map(ii);new_jj=elec_map(jj);
                    Wid1=  abs(ras(ii,jj));
                    
                    if (Wid1<=0) 
                       Wid1=0.0001;
                    end
                    
                    if Wid1>=thr1
%           
                         line([y_elec(new_ii) y_elec(new_jj)],[x_elec(new_ii) x_elec(new_jj)],[z_elec(new_ii) z_elec(new_jj)],'Color','r','Marker','.','LineStyle','-','LineWidth',Wid1*4),
                         high_node_weight(i,j,ii)=  high_node_weight(i,j,ii)+1;
                         high_node_weight(i,j,jj)=  high_node_weight(i,j,jj)+1;

                       
                    end
                    
                    if Wid1<=thr2
%           
                         line([y_elec(new_ii) y_elec(new_jj)],[x_elec(new_ii) x_elec(new_jj)],[z_elec(new_ii) z_elec(new_jj)],'Color','b','Marker','.','LineStyle','-','LineWidth',Wid1*4),
                         low_node_weight(i,j,ii)=  low_node_weight(i,j,ii)+1; %tb fb elecnum
                         low_node_weight(i,j,jj)=  low_node_weight(i,j,jj)+1;
                    end
                  end 
                    
                    

                end
        end

    end
     %export_fig (savefile,'-append', '-transparent')
end
%}

%======INDUCED COHERENCE MAP=========================
%{
high_node_weight_induced=zeros(time_bin_no,freq_bin_no,chn_no);
low_node_weight_induced=zeros(time_bin_no,freq_bin_no,chn_no);
for j=1:freq_bin_no
    figure;
    scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);

    for i=1:time_bin_no
        thr1_induced=mean_thr_induced(j)+(2*std_thr_induced(j)); % thereshold for coherence based on Ding paper
        thr2_induced=mean_thr_induced(j)-(2*std_thr_induced(j)); % for finding desync regions 
        
       % k=strcat('the connectivity plot based on the original raster plot using thershold value :>  ',num2str(thr1));
        %title(k);
        ras=raster_mat_induced(:,:,i,j);
        
        subplot(3,3,i);
%         suptitle('Topography of Coherence Elevation During Experiment(Blue lines: High Significant Connections. Red lines : Low Significant Connections)');
        k=strcat('Induced Freq: ', num2str(freq_bin(j,1)), '->', num2str(freq_bin(j,2)), ' TF:', num2str((time_bin(i,1)-prestim)*1000/Fs), '->' ,num2str((time_bin(i,2)-prestim)*1000/Fs), 'ms thr:  ',num2str(thr1_induced) ); 
        title(k);
        [x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','numbers');z_elec = ones(size(x_elec))*2.1;
        hold on; plot3(y_elec,x_elec,z_elec,'.r');
        for ii=1:chn_no-1
                
               for jj=i+1:chn_no
                  if ii~=jj
                    new_ii=elec_map(ii);new_jj=elec_map(jj);
                    Wid1=  abs(ras(ii,jj));
                    
                    if (Wid1<=0) 
                       Wid1=0.0001;
                    end
                    
                    if Wid1>=thr1_induced
%           
                         line([y_elec(new_ii) y_elec(new_jj)],[x_elec(new_ii) x_elec(new_jj)],[z_elec(new_ii) z_elec(new_jj)],'Color','r','Marker','.','LineStyle','-','LineWidth',Wid1*4),
                         high_node_weight_induced(i,j,ii)=  high_node_weight_induced(i,j,ii)+1;
                         high_node_weight_induced(i,j,jj)=  high_node_weight_induced(i,j,jj)+1;

                       
                    end
                    
                    if Wid1<=thr2_induced
                        kkk= [y_elec(new_ii) y_elec(new_jj) x_elec(new_ii) x_elec(new_jj) z_elec(new_ii) z_elec(new_jj) Wid1*4];   
                         line([y_elec(new_ii) y_elec(new_jj)],[x_elec(new_ii) x_elec(new_jj)],[z_elec(new_ii) z_elec(new_jj)],'Color','b','Marker','.','LineStyle','-','LineWidth',Wid1*4),
                         low_node_weight_induced(i,j,ii)=  low_node_weight_induced(i,j,ii)+1; %tb fb elecnum
                         low_node_weight_induced(i,j,jj)=  low_node_weight_induced(i,j,jj)+1;
                    end
                  end 
                    
                    

                end
        end

    end
     %export_fig (savefile,'-append', '-transparent')
end
%}
%========================================================
%Binary Raster Plot
%{
accu_raster_mat=raster_mat>thr1;
for j=1:freq_bin_no
    figure;
    scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);
    %m=0;s=0;
    clf
%     im=imread('C:\Iman Work\CMB Projects\Yukari Project\Electrodes Map\electrode map 150 dpi flattened.tif');
%     axes('position',[0,.6,.1,0.63])
%     imshow(im)
%     hold on;
    for i=1:time_bin_no
       
       subplot(3,3,i);
       %suptitle('Raster plot of Coherence Elevation During Experiment');
       k=strcat('ACCU Freq: ', num2str(freq_bin(j,1)), '->', num2str(freq_bin(j,2)), 'Hz. TF:', num2str((time_bin(i,1)-prestim)*1000/Fs), '->' ,num2str((time_bin(i,2)-prestim)*1000/Fs), 'msec, ' ); 
       imagesc(accu_raster_mat(:,:,i,j));
       set(gca,'YTick',[1:length(elec_map)],'YTickLabel',elec_label_x)
       set(gca,'XTick',[1:length(elec_map)],'XTickLabel',elec_label_x)
       title(k)
       colorbar('EastOutside')
     %  m=m+mean(mean(raster_mat(:,:,i,j)));
      % s=s+mean(std(raster_mat(:,:,i,j)));
   end;
   %mean_thr(j)=m/time_bin_no;std_thr(j)=s/time_bin_no;
   %  export_fig (savefile,'-append', '-transparent')
  
end
%}
%================================================================

% Induced Binary Raster Plot
%{
accu_raster_mat_induced=raster_mat_induced>thr1_induced;
for j=1:freq_bin_no
    figure;
    scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);
    %m=0;s=0;
    clf
%     im=imread('C:\Iman Work\CMB Projects\Yukari Project\Electrodes Map\electrode map 150 dpi flattened.tif');
%     axes('position',[0,.6,.1,0.63])
%     imshow(im)
%     hold on;
    for i=1:time_bin_no
       
       subplot(3,3,i);
       %suptitle('Raster plot of Coherence Elevation During Experiment');
       k=strcat('IND ACCU Freq: ', num2str(freq_bin(j,1)), '->', num2str(freq_bin(j,2)), 'Hz. TF:', num2str((time_bin(i,1)-prestim)*1000/Fs), '->' ,num2str((time_bin(i,2)-prestim)*1000/Fs), 'msec, ' ); 
       imagesc(accu_raster_mat_induced(:,:,i,j));
       set(gca,'YTick',[1:length(elec_map)],'YTickLabel',elec_label_x)
       set(gca,'XTick',[1:length(elec_map)],'XTickLabel',elec_label_x)
       title(k)
       colorbar('EastOutside')
     %  m=m+mean(mean(raster_mat(:,:,i,j)));
      % s=s+mean(std(raster_mat(:,:,i,j)));
   end;
   %mean_thr(j)=m/time_bin_no;std_thr(j)=s/time_bin_no;
    % export_fig (savefile,'-append', '-transparent')
  
end
%}
%======================================================
% Electrode distance Probablity 
%{
max_dist=max(max(dist_elec));
bin_connection=20;
dist_bin=max_dist/bin_connection; 
connection_dist_mat=zeros(bin_connection,time_bin_no,freq_bin_no);
for j=1:freq_bin_no
    figure;
    scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);
    suptitle(strcat('Percentage of Connections per inter-electrode distance '));

    for i=1:time_bin_no
        ras=accu_raster_mat(:,:,i,j);
            
        subplot(3,3,i);
%       
        connection_no=zeros(1,bin_connection);
        for ii=1:chn_no-1
               
               for jj=i+1:chn_no 
                  if ii~=jj
                   new_i=find(elec_map==ii);new_j=find(elec_map==jj); % new_i and new_j are indices of the electrodes based on their apperance in the raster plot
   
                    if ras(ii,jj)>0                    
                     if (dist_elec(new_i,new_j)>0 && dist_elec(new_i,new_j)<=dist_bin)
                        connection_no (1)=connection_no (1)+1;
                     
                     elseif (dist_elec(new_i,new_j)>dist_bin && dist_elec(new_i,new_j)<= 2*dist_bin)
                         
                         connection_no (2)=connection_no (2)+1;
                     elseif (dist_elec(new_i,new_j)>2*dist_bin && dist_elec(new_i,new_j)<= 3*dist_bin)
                         connection_no (3)=connection_no (3)+1;
                     elseif (dist_elec(new_i,new_j)>3*dist_bin && dist_elec(new_i,new_j)<= 4*dist_bin)
                         connection_no (4)=connection_no (4)+1;
                     elseif (dist_elec(new_i,new_j)>4*dist_bin && dist_elec(new_i,new_j)<= 5*dist_bin)
                         connection_no (5)=connection_no (5)+1;
         
                     elseif (dist_elec(new_i,new_j)>5*dist_bin && dist_elec(new_i,new_j)<= 6*dist_bin)
                         connection_no (6)=connection_no (6)+1;
                     elseif (dist_elec(new_i,new_j)>6*dist_bin && dist_elec(new_i,new_j)<= 7*dist_bin)
                         connection_no (7)=connection_no (7)+1;
                         
                      elseif (dist_elec(new_i,new_j)>7*dist_bin && dist_elec(new_i,new_j)<= 8*dist_bin)
                         connection_no (8)=connection_no (8)+1; 

                      elseif (dist_elec(new_i,new_j)>8*dist_bin && dist_elec(new_i,new_j)<= 9*dist_bin)
                         connection_no (9)=connection_no (9)+1; 
                          
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 10*dist_bin)
                         connection_no (10)=connection_no (10)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 11*dist_bin)
                         connection_no (11)=connection_no (11)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 12*dist_bin)
                         connection_no (12)=connection_no (12)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 13*dist_bin)
                         connection_no (13)=connection_no (13)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 14*dist_bin)
                         connection_no (14)=connection_no (14)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 15*dist_bin)
                         connection_no (15)=connection_no (15)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 16 *dist_bin)
                         connection_no (16)=connection_no (16)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 17*dist_bin)
                         connection_no (17)=connection_no (17)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 18*dist_bin)
                         connection_no (18)=connection_no (18)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 19*dist_bin)
                         connection_no (19)=connection_no (19)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 20*dist_bin)
                         connection_no (20)=connection_no (20)+1;
                         
                         
                         
                         
                         
                         
                         
                     end
                    end
                      
                  end 
                    
                     

                end
        end
      %  cs=spline(1:10,connection_no,1:.25:10); plot(cs) 
          x_bin=dist_bin:dist_bin:bin_connection*dist_bin;
          connection_no=cumsum(connection_no);
          connection_no=connection_no/max(connection_no);
          plot(x_bin,connection_no); 
          ylabel('Percentage of Connections ');
          xlabel('Inter Electrode Distance (cm) ')
          k=strcat('Connections Freq: ', num2str(freq_bin(j,1)), '->', num2str(freq_bin(j,2)), ' TF:', num2str((time_bin(i,1)-prestim)*1000/Fs), '->' ,num2str((time_bin(i,2)-prestim)*1000/Fs), ', ' ); 
          title(k);
          
    connection_dist_mat(:,i,j)=connection_no;
    end
   %  export_fig (savefile,'-append', '-transparent')
end
%}
%=============================================================
% Electrode Distance Prob fro Induced 
%{
max_dist=max(max(dist_elec));
bin_connection=20;
dist_bin=max_dist/bin_connection; 
connection_dist_mat_induced=zeros(bin_connection,time_bin_no,freq_bin_no);
for j=1:freq_bin_no
    figure;
    scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);
    suptitle(strcat('Induced Percentage of Connections per inter-electrode distance '));

    for i=1:time_bin_no
        ras=accu_raster_mat_induced(:,:,i,j);
            
        subplot(3,3,i);
%       
        connection_no_induced=zeros(1,bin_connection);
        for ii=1:chn_no-1
               
               for jj=i+1:chn_no 
                  if ii~=jj
                   new_i=find(elec_map==ii);new_j=find(elec_map==jj); % new_i and new_j are indices of the electrodes based on their apperance in the raster plot
   
                    if ras(ii,jj)>0                    
                     if (dist_elec(new_i,new_j)>0 && dist_elec(new_i,new_j)<=dist_bin)
                        connection_no_induced (1)=connection_no_induced (1)+1;
                     
                     elseif (dist_elec(new_i,new_j)>dist_bin && dist_elec(new_i,new_j)<= 2*dist_bin)
                         
                         connection_no_induced (2)=connection_no_induced (2)+1;
                     elseif (dist_elec(new_i,new_j)>2*dist_bin && dist_elec(new_i,new_j)<= 3*dist_bin)
                         connection_no_induced (3)=connection_no_induced (3)+1;
                     elseif (dist_elec(new_i,new_j)>3*dist_bin && dist_elec(new_i,new_j)<= 4*dist_bin)
                         connection_no_induced (4)=connection_no_induced (4)+1;
                     elseif (dist_elec(new_i,new_j)>4*dist_bin && dist_elec(new_i,new_j)<= 5*dist_bin)
                         connection_no_induced (5)=connection_no_induced (5)+1;
         
                     elseif (dist_elec(new_i,new_j)>5*dist_bin && dist_elec(new_i,new_j)<= 6*dist_bin)
                         connection_no_induced (6)=connection_no_induced (6)+1;
                     elseif (dist_elec(new_i,new_j)>6*dist_bin && dist_elec(new_i,new_j)<= 7*dist_bin)
                         connection_no_induced (7)=connection_no_induced (7)+1;
                         
                      elseif (dist_elec(new_i,new_j)>7*dist_bin && dist_elec(new_i,new_j)<= 8*dist_bin)
                         connection_no_induced (8)=connection_no_induced (8)+1; 

                      elseif (dist_elec(new_i,new_j)>8*dist_bin && dist_elec(new_i,new_j)<= 9*dist_bin)
                         connection_no_induced (9)=connection_no_induced (9)+1; 
                          
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 10*dist_bin)
                         connection_no_induced (10)=connection_no_induced (10)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 11*dist_bin)
                         connection_no_induced (11)=connection_no_induced (11)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 12*dist_bin)
                         connection_no_induced (12)=connection_no_induced (12)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 13*dist_bin)
                         connection_no_induced (13)=connection_no_induced (13)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 14*dist_bin)
                         connection_no_induced (14)=connection_no_induced (14)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 15*dist_bin)
                         connection_no_induced (15)=connection_no_induced (15)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 16 *dist_bin)
                         connection_no_induced (16)=connection_no_induced (16)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 17*dist_bin)
                         connection_no_induced (17)=connection_no_induced (17)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 18*dist_bin)
                         connection_no_induced (18)=connection_no_induced (18)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 19*dist_bin)
                         connection_no_induced (19)=connection_no_induced (19)+1;
                      elseif (dist_elec(new_i,new_j)>9*dist_bin && dist_elec(new_i,new_j)<= 20*dist_bin)
                         connection_no_induced (20)=connection_no_induced (20)+1;
                         
                         
                         
                         
                         
                         
                         
                     end
                    end
                      
                  end 
                    
                     

                end
        end
      %  cs=spline(1:10,connection_no,1:.25:10); plot(cs) 
          x_bin=dist_bin:dist_bin:bin_connection*dist_bin;
          connection_no_induced=cumsum(connection_no_induced);
          connection_no_induced=connection_no_induced/max(connection_no_induced);
          plot(x_bin,connection_no_induced); 
          ylabel('Percentage of Connections ');
          xlabel('Inter Electrode Distance (cm) ')
          k=strcat('Induced Connections Freq: ', num2str(freq_bin(j,1)), '->', num2str(freq_bin(j,2)), ' TF:', num2str((time_bin(i,1)-prestim)*1000/Fs), '->' ,num2str((time_bin(i,2)-prestim)*1000/Fs), ', ' ); 
          title(k);
          
    connection_dist_mat_induced(:,i,j)=connection_no_induced;
    end
     %export_fig (savefile,'-append', '-transparent')
end
%}



%========================================================
% Connection Per Time
%{
figure;
scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);
suptitle('Number of Connections for each Electrode During Experment');
for fb=1:freq_bin_no
    strength_mat1=[];
    strength_mat2=[];

    for tb=1:time_bin_no
        tmp1=high_node_weight(tb,fb,:);tmp1=tmp1(:)';
        tmp2=low_node_weight(tb,fb,:);tmp2=tmp2(:)';
        strength_mat1(tb,:)=tmp1;
        strength_mat2(tb,:)=tmp2;
    end
       subplot(freq_bin_no,2,2*fb-1)
       imagesc(strength_mat1');xlabel('Time Bins'); ylabel('Channel Label');k=strcat('Freq: ', num2str(freq_bin(fb,1)), '->', num2str(freq_bin(j,2)), ' Hi. Coh.'); title(k);
       set(gca,'YTick',[1:length(elec_map)],'YTickLabel',elec_label_x);
       set(gca,'XTick',[1:time_bin_no],'XTickLabel',time_bin(:,1)-prestim);
       colorbar('EastOutside')

       subplot(freq_bin_no,2,2*fb); 
       imagesc(strength_mat2');xlabel('Time Bins'); ylabel('Channel Label.');k=strcat('Freq: ', num2str(freq_bin(fb,1)), '->', num2str(freq_bin(j,2)), ' Lo. Coh.'); title(k);
       set(gca,'YTick',[1:length(elec_map)],'YTickLabel',elec_label_x);
       set(gca,'XTick',[1:time_bin_no],'XTickLabel',time_bin(:,1)-prestim);
       colorbar('EastOutside')

end
%}
     %export_fig (savefile,'-append', '-transparent')
%=================================================
% Induced Connection Per Time 
  % Connection Per Time
  %{
figure;
scrsz = get(0,'ScreenSize'); figure('Position',[1 1 2000 2000]);
suptitle('Number of INDUCED Connections for each Electrode During Experment');
for fb=1:freq_bin_no
    strength_mat1_induced=[];
    strength_mat2_induced=[];

    for tb=1:time_bin_no
        tmp1=high_node_weight_induced(tb,fb,:);tmp1=tmp1(:)';
        tmp2=low_node_weight_induced(tb,fb,:);tmp2=tmp2(:)';
        strength_mat1_induced(tb,:)=tmp1;
        strength_mat2_induced(tb,:)=tmp2;
    end
       subplot(freq_bin_no,2,2*fb-1)
       imagesc(strength_mat1');xlabel('Time Bins'); ylabel('Channel Label');k=strcat('Freq: ', num2str(freq_bin(fb,1)), '->', num2str(freq_bin(j,2)), ' Hi. Coh.'); title(k);
       set(gca,'YTick',[1:length(elec_map)],'YTickLabel',elec_label_x);
       set(gca,'XTick',[1:time_bin_no],'XTickLabel',time_bin(:,1)-prestim);
       colorbar('EastOutside')

       subplot(freq_bin_no,2,2*fb); 
       imagesc(strength_mat2');xlabel('Time Bins'); ylabel('Channel Label.');k=strcat('Freq: ', num2str(freq_bin(fb,1)), '->', num2str(freq_bin(j,2)), ' Lo. Coh.'); title(k);
       set(gca,'YTick',[1:length(elec_map)],'YTickLabel',elec_label_x);
       set(gca,'XTick',[1:time_bin_no],'XTickLabel',time_bin(:,1)-prestim);
       colorbar('EastOutside')

end
     %export_fig (savefile,'-append', '-transparent')   
    %} 
     
%==============================writing log and mat files
%{
logfile=strcat(working_folder,'\',file_name,'.log1');
fid = fopen(logfile,'w');
star_txt='*****************************************************************************************************************************';
if fid == -1
   fprintf(1,'Error creating New Event File  \n');
end
fprintf(fid,'%s\t%s\n', 'Dataset File Name:', file_name);
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'PDF File Name for all coherence maps:', savefile);
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'Frequency Bin(s):', mat2str(freq_bin));
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'Time Bin(s):', mat2str(time_bin));
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains Means of Threshold For Different Frequencies Bin(s):', 'mean_thr');
fprintf(fid,'%s\t%s\n', 'mean_thr=:', mat2str(mean_thr));
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains Std of Threshold For Different Frequencies Bin(s):', 'std_thr');
fprintf(fid,'%s\t%s\n', 'std_thr=:', mat2str(std_thr));
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'Note: Threshold for significant connection ( Evoked Coherence) for each frequency bin is Calculated as  :', 'thr1=mean_thr+(2*std_thr) and thr2=mean_thr-(2*std_thr)');
fprintf(fid,'%s\t%s\n', 'thr1=', mat2str(thr1));
fprintf(fid,'%s\t%s\n', 'thr2=', mat2str(thr2));
fprintf(fid,'%s\t%s\n', 'Note: Threshold for significant connection ( Induced Coherence) for each frequency bin is Calculated as  :', 'thr1=mean_thr+(2*std_thr) and thr2=mean_thr-(2*std_thr)');
fprintf(fid,'%s\t%s\n', 'thr1_induced=', mat2str(thr1_induced));
fprintf(fid,'%s\t%s\n', 'thr2_induced=', mat2str(thr2_induced));
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains number of lines with HIGH coherence (above thr1) connected to each electrode during the experiment time: ', 'high_node_weight');
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains number of lines with LOW coherence (below thr1) connected to each electrode during the experiment time: ', 'low_node_weight');
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains number of lines with HIGH coherence (above thr1_induced) connected to each electrode during the experiment time: ', 'high_node_weight_induced');
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains number of lines with LOW coherence (belowe thr1) connected to each electrode during the experiment time: ', 'low_node_weight_induced');
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains Raster Plots information for EVOKED COHERENCE:', 'raster_mat');
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains Raster Plots information for INDUCED COHERENCE:', 'raster_mat_induced');
fprintf(fid,'%s\t%s\n', 'raster_mat is a 4 dimensional matrix: raster_mat(i,j,tb,fb) ', 'i= elec_num j=elec_num tb=time_bin_num tf=freq_bin_num');
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'Actual Numeber of Trials=', num2str(EEG.trials));
fprintf(fid,'%s\t%s\n', 'Percentage of the Trials used in this analysis=', num2str(percent_data));
fprintf(fid,'%s\n', star_txt);
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains EVOKED Connection Probality Per Electrode Distance:', 'connection_dist_mat');
fprintf(fid,'%s\t%s\n', 'Variable Name which Contains INDUCED Connection Probality Per Electrode Distance:', 'connection_dist_mat_induced');
fprintf(fid,'%s\t%s\n', 'it is two dim matrix , (i,j) ---- i is the interelectrode distance and j is the cummulative probablity');
fclose(fid);
%}
mkdir(strcat(working_folder,'\',analysisfile));
matfile=strcat(working_folder,'\',analysisfile,'\',file_name,'_CohValue.mat');
%matfile=strcat(working_folder,'\',file_name,'.mat');
save(matfile, 'freq_bin', 'time_bin','raster_mat','raster_mat_induced');%,'accu_raster_mat','accu_raster_mat_induced','file_name','mean_thr','std_thr','mean_thr_induced','std_thr_induced','thr1','thr2','thr1_induced', 'thr2_induced','high_node_weight','low_node_weight', 'connection_dist_mat','thr2_induced','high_node_weight_induced','low_node_weight_induced', 'connection_dist_mat_induced');
%close all;
status=1;
end