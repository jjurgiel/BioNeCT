function raster_new = gui_reorderchans(EEG,raster_mat,chanord)


for f = 1:size(raster_mat,4);
    for t = 1:size(raster_mat,3);
        
        for i = 1:size(raster_mat,1)
            for j = 1:size(raster_mat,1)
                ch1_label = EEG.chanlocs(i).labels;
                ch2_label = EEG.chanlocs(j).labels;
                ch1_ind = strmatch(EEG.chanlocs(i).labels,chanord.new.labels);
                ch2_ind = strmatch(EEG.chanlocs(j).labels,chanord.new.labels);
                if isempty(ch1_ind)
                    msgbox(sprintf('Unable to find electrode %s in reference list.',EEG.chanlocs(i).labels));
                elseif isempty(ch2_ind)
                    msgbox(sprintf('Unable to find electrode %s in reference list.',EEG.chanlocs(i).labels));
                else
                    raster_new(ch1_ind,ch2_ind,t,f) = raster_mat(i,j,t,f);
          %          raster_compare(ch1_ind,:,t,f) = raster_mat(i,:,t,f);
          %          raster_compare(:,ch1_ind,t,f) = raster_mat(:,i,t,f);
                end
            end    
        end
        
    end
end
