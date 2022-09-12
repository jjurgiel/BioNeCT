function gui_brodmann(BNCT,labels, all_labels, all_locs, cohmat, cohmat_full, colorVec, thrlow, thrhigh, sensitivity, viewpoint)
%y = 1, x = 2, z = 3
%%%ADJUST ELECTRODES TO SOME UNIFORM DIRECTIONS (I.E. NOSE +X, RIGHT SIDE
%%%+Y OR WHATEVER. Could do this by checking if certain electrode positions
%%%are negative/positive

try
    matched_channels = BNCT.matched_channels;%evalin('base','matched_channels');
catch
    gui_brodmann_chmatch(all_labels,labels);
    uiwait
    BNCT = evalin('base','BNCT');
    matched_channels = BNCT.matched_channels;%evalin('base','matched_channels');
end


%% remove electrodes and values from coh matrix based on view angle
all_locs(:,3) = all_locs(:,3)*(-1);
switch viewpoint
    case 'left'
        rgb = imread('brainareas_left.png');
        axis1 = 2;
        axis2 = 3;
        all_locs(:,2) = all_locs(:,2)*(-1);
        %Remove locs beyond hemisphere
        all_locs(all_locs(:,1)>0,:) = NaN;
        %Also remove locs of channels that weren't matched
        all_locs(cellfun(@isempty,matched_channels(:,3))==1,:) = NaN;
    case 'right'
        rgb = imread('brainareas_right.png');
        axis1 = 2;
        axis2 = 3;
        all_locs(all_locs(:,1)<0,:) = NaN;
        all_locs(cellfun(@isempty,matched_channels(:,3))==1,:) = NaN;
end

%{
all_locs(:,3) = all_locs(:,3)*(-1);
switch viewpoint
    case 'left'
        rgb = imread('brainareas_left.png');
        %Set coord system to use for image
        axis1 = 2; %x
        axis2 = 3; %z
        %Flip x axis for picture orientation
        all_locs(:,2) = all_locs(:,2)*(-1);
        
        %Find electrodes which aren't in selected hemisphere & remove
        for i = size(all_locs,1):-1:1   
            if all_locs(i,1) < 0
                index = find(cellfun('length',regexp(labels,all_labels{i})) == 1);
                if any(index)
                    cohmat(i,:) = 0;
                    cohmat(:,i) = 0;
                end
                all_locs(i,:) = NaN;
                all_labels{i} = 0;                
            end
        end
        
    case 'right'
        rgb = imread('brainareas_right.png');
        %Set coord system to use for image
        axis1 = 2; %x
        axis2 = 3; %z
        
        %Find electrodes which aren't in selected hemisphere & remove
        for i = size(all_locs,1):-1:1
            if all_locs(i,1) > 0
                index = find(cellfun('length',regexp(labels,all_labels{i})) == 1);
                if any(index)
                    cohmat(i,:) = 0;
                    cohmat(:,i) = 0;
                end    
                all_locs(i,:) = NaN;
                all_labels{i} = 0;
            end
        end
    case 'top'
        
end
%}
%%
brodmannplot = image(rgb);
hold on;
axis off;
%set(gca,'color','white');
%set(gcf,'color','white');
%% Scale electrodes to image size
max_x = max(abs(all_locs(:,2)));
max_z = max(abs(all_locs(:,3)));

scale_x = size(rgb,2)/max_x;
scale_z = size(rgb,1)/max_z;

all_locs = all_locs*scale_z*.8;

meanvals = mean(all_locs(~isnan(all_locs(:,1)),:));

xdiff = 1000-meanvals(2);
zdiff = 714-meanvals(3);
all_locs(:,2) = all_locs(:,2)+xdiff;
all_locs(:,3) = all_locs(:,3)+zdiff;

%% Adjust cohmat labels
for n = 1:1:size(labels,1)
    labelloc = find(strcmp(matched_channels(:,3),labels{n}));
    if ~isempty(labelloc)
        cohmat_locs{n,1} = all_locs(labelloc,1);
        cohmat_locs{n,2} = all_locs(labelloc,2);
        cohmat_locs{n,3} = all_locs(labelloc,3);
    else
        cohmat_locs{n,1} = NaN;
        cohmat_locs{n,2} = NaN;
        cohmat_locs{n,3} = NaN;        
    end
end
cohmat_locs = cell2mat(cohmat_locs);
%% plot electrode map
scatter(all_locs(:,axis1),all_locs(:,axis2),'MarkerEdgeColor',[0 .5 .5],...
                                            'MarkerFaceColor',[0 .7 .7],...
                                            'LineWidth',7)

%% add labels
for i = 1:1:size(matched_channels,1)
    if any(matched_channels{i,3})
        text(all_locs(i,axis1)-0.01*max(max(all_locs)),all_locs(i,axis2)...
            -0.025*max(max(all_locs)),matched_channels{i,3},'color','black','FontWeight','bold','FontSize',8);
    end
end

%% create colormap values
%colorVec = jet(length(find(cohmat)));
if round(sum(sum(cohmat))) ~= sum(sum(cohmat))
    diff_flag = 0;
else
    diff_flag = 1;
end
if diff_flag == 0
    list = sort(cohmat_full(:),'ascend');
    list = list(list~=0);
else
    list = sort(cohmat(:),'ascend');
    list = list(list~=0);
end

%% plot lines
n = size(cohmat,1);
%Threshold
%cohmat(abs(((cohmat>thrhigh)-(cohmat<thrlow)))<1)=0;
for i = 1:1:n
    for j = i+1:1:n
        if cohmat(i,j) ~= 0
            colorVecloc = find(list == cohmat(i,j));
            if length(colorVecloc) > 1
                colorVecloc = colorVecloc(1);
            end
        if diff_flag == 1
            if cohmat(i,j) == -1
                        line([cohmat_locs(i,2) cohmat_locs(j,2)],[cohmat_locs(i,3) cohmat_locs(j,3)],...
            'Color',colorVec(1,:),'Marker','.','LineStyle','-','LineWidth',(cohmat(i,j)^2)*sensitivity*10);
            elseif cohmat(i,j) == 1
                        line([cohmat_locs(i,2) cohmat_locs(j,2)],[cohmat_locs(i,3) cohmat_locs(j,3)],...
            'Color',colorVec(end,:),'Marker','.','LineStyle','-','LineWidth',(cohmat(i,j)^2)*sensitivity*10);
            end
        else
        line([cohmat_locs(i,2) cohmat_locs(j,2)],[cohmat_locs(i,3) cohmat_locs(j,3)],...
            'Color',colorVec(colorVecloc,:),'Marker','.','LineStyle','-','LineWidth',(cohmat(i,j)^2)*sensitivity*10);
        end
        end
    end

end
