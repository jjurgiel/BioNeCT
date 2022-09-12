function [raster_mat, raw_coh, e_label, timelist, time_bin, freqlist, freq_bin] = coherence(EEG,file_name, working_folder, analysisfile,freq_bin,batch_timebin,method,cohtype)
%% (Put this into own script?)
status=0;
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
               
        %Convert inter-electrode distance to cm
        if max(max(dist_elec)) < 1 %if its in meters
            dist_elec=dist_elec*100;
        elseif max(max(dist_elec)) > 1 && max(max(dist_elec)) < 10 %decimeters
            dist_elec=dist_elec*10;
        elseif max(max(dist_elec)) > 100%if its in mm
            dist_elec=dist_elec/10;
        end
        
end
%% 
time_bin = batch_timebin;
time_bin_no=size(time_bin,1); % no of bins
freq_bin_no=size(freq_bin,1); % no of freq bins
raster_mat=[];


%% Coherence Calculation (Put this into it''s own script?)
for i=1:chn_no-1
    k=strcat('Calculating Evoked and Induced Coherences for Channel Number ....', num2str(i));
    disp(k)
    for j=i+1:chn_no
        if (i~=j)
            
            x=mydata(i,:,:);
            y=mydata(j,:,:);
            
            x_data_sq=squeeze(x);                                 %squeeze all data at frames in trial 1
            y_data_sq=squeeze(y);                                 %squeeze all data at frames in trial 1
            
            x_bin = reshape( x_data_sq, 1, size(x_data_sq,1)*size(x_data_sq,2));
            y_bin = reshape( y_data_sq, 1, size(y_data_sq,1)*size(y_data_sq,2));
            
            %Add switch here for coherence type w/ concat file name
            [Ctxy,mcoh,timesout,f,cohboot,cohangles,allcoher,alltfX,alltfY] = newcrossf(x_bin,y_bin, EEG.pnts, [EEG.xmin EEG.xmax]*1000 ,EEG.srate,0,...
                'newfig','on','plotamp','off','plotphase','off','type','coher','winsize',256);
            
            switch cohtype
                case 'magcoh'
                    Cxy_new=Ctxy; %mean(Ctxy,2);
                case  'imagcoh'
                    Cxy_new = Ctxy.*abs(sin(cohangles)); %|Ctxy| * sin(Theta)
                    vol_cond(1) = 0;
            end
            
            %Remove any connections > 1
            ind_chk=find(Cxy_new>1);
            if isempty(ind_chk)==0
                Cxy_new(ind_chk)=1;
            end
            
            % reduced coherence based on Paul L. Nunez paper
            % P.L. Nunez et al. / Electroencephalography and clinical Neurophysiology 103 (1997) 499–515
            switch method
                case 'source'
                case 'channel'
                    vol_cond=[1 3];
                    if vol_cond(1)==1
                        a=vol_cond(2);
                        reduced_coh=exp((1-dist_elec(i,j))/a);
                        Cxy_new=Cxy_new-reduced_coh;
                        ind_chk=find(Cxy_new<0);
                        if isempty(ind_chk)==0
                            Cxy_new(ind_chk)=0;
                        end
                    end
            end
            
            avg_coh=Cxy_new;
            
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
    raster_mat(new_i,new_j,:,:)=1;  
end
raster_mat(isnan(raster_mat))=0;

%% Save data


mkdir(strcat(working_folder,'\',analysisfile));
matfile=strcat(working_folder,'\',analysisfile,'\',file_name,'_CohValueCS.mat');
save(matfile, 'freq_bin', 'time_bin','raster_mat','raw_coh','timelist','freqlist','e_label');
status=1;
end