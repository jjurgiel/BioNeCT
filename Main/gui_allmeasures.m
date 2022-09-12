function allmeasures = gui_allmeasures(BNCT,alldata,raw,tasklistraw,numfreqs,numtimebins,method,thrhighx,thrlow,phenotypelistraw)

%%THRESHOLD VALUES SAVED ARE ONLY FROM THE LAST SUBJECT, SINCE
%%THERES A SEPARATE THRESHOLDING AND MEASURE CALCULATING LOOP
%alldata = ch x ch x time x freq x subject
numtimebins = size(BNCT.alldata,3);

switch BNCT.connmethod
    case 'channel'
        n=size(alldata,1);
    case 'source'
        n=size(alldata{1},1);
end

tasklist = tasklistraw;
for a = 1:1:length(phenotypelistraw)
    sub.(phenotypelistraw{a})(1:length(tasklist)) = 1;
end
%% CREATE TASK VARIABLES/CHECK IF USER HAS INPUT APPROPRIATE VARIABLE NAMES
[tasklist] = gui_tasklist(tasklistraw);

%%                                Z-Score
if BNCT.threshold.settings.zscore_thr_val == 1
    h = waitbar(0,'Z-scoring data...');
    disp('Z-scoring data...');
    for subject = 1:1:size(alldata,5)
        for f = 1:1:numfreqs
 
                if BNCT.threshold.settings.thr_avg_val == 1
                    [zscore_matrix normalized_matrix] = gui_zscore(alldata(:,:,1:numtimebins,f,subject));
                    z_data(:,:,1:numtimebins,f,subject)= normalized_matrix;
                else
                    for t = 1:1:numtimebins
                    [zscore_matrix normalized_matrix] = gui_zscore(alldata(:,:,t,f,subject));
                    z_data(:,:,t,f,subject)= normalized_matrix;
                    end
                end
        end
                               
                    %mat2gray    
        waitbar(subject/size(alldata,5),h);
    end
    alldata = z_data;
    disp('Z-scoring complete.');
    close(h)
end
%}

%%                          GROUP THRESHOLD AVG
%Do we want to do for each task & freq, or just
%combine all subjects in a given phenotype?
%This may end up cutting off a large amount of values for any given subject,
%need to z-score or something over subjects?
if method == 3
    %Calculate mean+stdev for group average of a given phenotype, freq, and
    %task
    for b = 1:1:length(phenotypelistraw)
        for k = 1:1:length(tasklistraw)
            for f = 1:1:numfreqs
                temp_mat = zeros(size(alldata,1));
                count = 0;
                for subject = 1:1:size(alldata,5)
                    
                    if strfind(raw{subject,9},(tasklistraw{k})) > 0
                        if strfind(raw{subject,7},phenotypelistraw{b}) > 0
                            
                            for times=1:1:numtimebins
                                temp_mat = temp_mat + alldata(:,:,times,f);
                                count = count+1;
                            end
                            
                        end
                    end
                    
                end
                tempmat = temp_mat/count;
               % threshold_means.(phenotypelistraw{b})(f,k) = mean2(temp_mat/count);
                threshold_means.(phenotypelistraw{b})(f,k) = sum(sum(triu(tempmat,1)))/nnz(triu(tempmat,1));
                
                tempstd = triu(tempmat,1);
                tempstd = sort(tempstd(:),'descend');
                tempstd = tempstd(any(tempstd,2));
                threshold_std.(phenotypelistraw{b})(f,k) = tempstd(any(tempstd,2)); %why do this twice?
                %threshold_std.(phenotypelistraw{b})(f,k) = std2(temp_mat/count);
            end
        end
    end
     
end
h = waitbar(0,'Computing Graph Measures...');
disp('Calculating graph measures...');

                            %% THRESHOLDING
for subject = 1:1:size(alldata,5)
    switch BNCT.connmethod
        case 'channel'
            subjectdata = alldata(:,:,:,:,subject);
        case 'source'
            subjectdata = alldata{subject};
    end
    
    %SET THRESHOLD VALUES
    if method == 1
        for a=1:1:size(BNCT.config.freqlabellistraw,1)
          tempmat = zeros(n);%size(alldata,1));
          
            if BNCT.threshold.settings.thr_indiv_val == 1 %THRESHOLD INDIVIDUAL MATRICES
                for t = 1:1:numtimebins
                    tempmat = subjectdata(:,:,t,a);
                    thr_mean(t,a) = sum(sum(triu(tempmat,1)))/nnz(triu(tempmat,1));
                    tempstd = triu(tempmat,1);
                    tempstd = sort(tempstd(:),'descend');
                    tempstd = tempstd(any(tempstd,2));
                    std_mean(t,a) = std(tempstd);
                    thrhigh(t,a) = thr_mean(t,a) + thrhighx*std_mean(t,a);
                    thrlow(t,a) = thr_mean(t,a) - thrhighx*std_mean(t,a);
                end
            else %THRESHOLD BY AVERAGING ALL TIMEBINS TOGETHER
                for t = 1:1:numtimebins
                    tempmat = tempmat + subjectdata(:,:,t,a);
                end
                tempmat = tempmat/numtimebins;
                thr_mean(a) = sum(sum(triu(tempmat,1)))/nnz(triu(tempmat,1));
                tempstd = triu(tempmat,1);
                tempstd = sort(tempstd(:),'descend');
                tempstd = tempstd(any(tempstd,2));
                std_mean(a) = std(tempstd);
                thrhigh(a) = thr_mean(a) + thrhighx*std_mean(a);
                thrlow(a) = thr_mean(a) - thrhighx*std_mean(a);
            end

        end
    elseif method == 2
        thrhigh = thrhighx;
        thrlow = thrlow;    
    elseif method == 4
        thrhigh = thrhighx;
    end    
    
    %% APPLY THRESHOLDING
    for freq=1:1:numfreqs        
        for time=1:1:numtimebins
            matrix = subjectdata(:,:,time,freq);
                
            %matrix = gui_subconnmatrix(BNCT,matrix); %FOR REDUCING MATRIX
            
            nonthreshmatrix_temp = subjectdata(:,:,time,freq);
            nonthreshmatrix_temp(1:n+1:end)=0;
            nonthreshmatrix(:,:,time,freq,subject)=nonthreshmatrix_temp;
           % %NOT USED?
            %ZERO THE DIAGONAL
            
            matrix(1:n+1:end)=0; 
            numvals = nnz(triu(matrix,1));
            cohsum = sum(sum(triu(matrix,1)));
            meancoherence(time,freq,subject) = cohsum/numvals;  


            %%            THRESHOLD THE CONNECTIVITY MATRIX
            % MEAN +/- STDEV
            if method == 1
                if BNCT.threshold.settings.thr_indiv_val == 1 %Threshold by indiv matrices
                    if BNCT.threshold.settings.binarize_val == 1 %Binarize option
                        matrix(matrix<thrhigh(time,freq)) = 0;
                        matrix(matrix>thrhigh(time,freq)) = 1;
                    else
                        matrix(abs(((matrix>thrhigh(time,freq))-(matrix<thrlow(time,freq))))<1)=0;
                    %    matrix(matrix<thrhigh(time,freq)) = 0;
                    end
                else
                    if BNCT.threshold.settings.binarize_val == 1
                        matrix(matrix<thrhigh(freq)) = 0;
                        matrix(matrix>thrhigh(freq)) = 1;
                    else
                        matrix(abs(((matrix>thrhigh(freq))-(matrix<thrlow(freq))))<1)=0;
                     %   matrix(matrix<thrhigh(freq)) = 0;
                    end
                end
            % SET VALUES   
            elseif method == 2
                if BNCT.threshold.settings.binarize_val == 1
                    matrix(matrix<thrhigh) = 0;
                    matrix(matrix>thrhigh) = 1;
                else
                    matrix(abs(((matrix>thrhigh)-(matrix<thrlow)))<1)=0;   
                end
            % GROUP AVG   
            elseif method == 3
                thrflag = 0;
                while thrflag == 0
                for b = 1:1:length(phenotypelistraw)
                    if strfind(raw{subject,7},phenotypelistraw{b}) > 0
                        for k = 1:1:length(tasklist)
                            if strfind(raw{subject,9},(tasklistraw{k})) > 0
                                thrhigh = threshold_means.(phenotypelistraw{b})(freq,k) + thrhighx*threshold_std.(phenotypelistraw{b})(freq,k);
                                thrlow = threshold_means.(phenotypelistraw{b})(freq,k) - thrhighx*threshold_std.(phenotypelistraw{b})(freq,k);
                                thrflag = 1;
                            end
                        end
                    end
                end
                end
                if BNCT.threshold.settings.binarize_val == 1
                    matrix(matrix<thrhigh) = 0;
                    matrix(matrix>thrhigh) = 1;
                else
                    matrix(abs(((matrix>thrhigh)-(matrix<thrlow)))<1)=0; 
                end
            elseif method == 4 %Percentile
                if BNCT.threshold.settings.binarize_val == 1
                    msgbox('Invalid thresholding for binary graph')
                else
                    matrix2 = triu(matrix);
                    m = sort(matrix2(:),'descend');
                    m = m(m~=0);
                        p1 = prctile(m,thrlow);
                        p2 = prctile(m,thrhighx);
                        matrix(matrix<p1)=0; %threshold
                        matrix(matrix>p2)=0;
                        
                end
            end
            threshmatrix_temp(:,:,time,freq,subject) = matrix;
        end
                     %% Z-score after thresholding
        if BNCT.threshold.settings.thr_zscore_val == 1            
             %   if BNCT.threshold.settings.thr_avg_val == 1
                    [zscore_matrix normalized_matrix] = gui_zscore(threshmatrix_temp(:,:,1:numtimebins,freq,subject));
                    threshmatrix(:,:,1:numtimebins,f,subject)= normalized_matrix;
            %    else
             %       for t = 1:1:numtimebins
            %        [zscore_matrix normalized_matrix] = gui_zscore(alldata(:,:,t,freq,subject));
            %        z_data(:,:,t,f,subject)= normalized_matrix;
            %        end
            %    end
        else
            threshmatrix = threshmatrix_temp;
        end          
        
    end
    disp(horzcat('Thresholding file ',num2str(subject),' of ',num2str(size(alldata,5))));
end
 
            %%             GRAPH THEORY MEASURES

for subject = 1:1:size(alldata,5)
    %LOOP THROUGH FREQ & TIME FOR EACH SUBJECT/SAMPLE AND CALCULATE GRAPH
    %THEORY MEASURES
    for freq = 1:1:numfreqs
        for time = 1:1:numtimebins
            matrix = threshmatrix(:,:,time,freq,subject);
            measures.matrix = matrix;
            measures.meancoherence = meancoherence(time,freq,subject);
            measures.threshmatrix = threshmatrix(:,:,time,freq,subject);
            measures.nonthreshmatrix = nonthreshmatrix(:,:,time,freq,subject);%subjectdata(:,:,time,freq);;
            try
                %BINARIZE IF SELECTED
                if BNCT.threshold.settings.binarize_val == 1
                    
                    %measures.nonthreshmatrix = nonthreshmatrix;
                    %measures.matrix=matrix;
                    measures.thrlow =thrlow(time,freq);
                    measures.thrhigh=thrhigh(time,freq);
                    
                    measures.assortativity = assortativity_bin(matrix,0);
                    measures.nodeclusteringcoeff = clustering_coef_bu(matrix);
                    measures.clustering_coeff = mean(measures.nodeclusteringcoeff);
                    [measures.degree] = degrees_und(matrix)';
                    [measures.density,N,K] = density_und(matrix); 
                    
                    [D]=distance_bin(matrix);
                    [measures.avgpath,measures.efficglobal,measures.eccentricity,measures.radius,measures.diameter] = charpath(D);
                    [measures.edgebetweenness measures.nodebetweenness]=edge_betweenness_bin(matrix);
                    measures.nodebetweenness = measures.nodebetweenness / [(n-1)*(n-2)]; 
                    measures.efficlocal = efficiency_bin(matrix,1);
                    [measures.commstructureclassical measures.modularityclassical]=modularity_und(matrix, 1);
                    [measures.commstructurelouvain measures.modularitylouvain] = community_louvain(matrix,1);
                    measures.commstructurelouvain = measures.commstructurelouvain';      
                    measures.zscore=module_degree_zscore(matrix,measures.commstructurelouvain,0);
                    [measures.richclub] = rich_club_bu(matrix)';
                    [measures.strength] = strengths_und(matrix)';
                    measures.transitivity = transitivity_bu(matrix);
                    measures.connections = gui_shortlongconnections(BNCT,matrix);
                    
                else
                    %{
                    %Signed Networks
                    matrix(matrix<0)=0;
                    measures.thrlow = thrlow;
                    measures.thrhigh=thrhigh;
                    L = weight_conversion(matrix,'lengths');
                    measures.assortativity = assortativity_wei(matrix,4);%4?
                    measures.nodeclusteringcoeff = clustering_coef_wd(matrix);
                    measures.clusteringcoeff = mean(measures.nodeclusteringcoeff);
                    [measures.degree] = degrees_dir(matrix)';
                    [measures.density,N,K] = density_dir(matrix);
                    [D B]=distance_wei(L);
                    [measures.avgpath,measures.efficglobal,measures.eccentricity,measures.radius,measures.diameter] = charpath(D);
                    [measures.edgebetweenness measures.nodebetweenness]=edge_betweenness_wei(L);
                    measures.nodebetweenness = measures.nodebetweenness / [(n-1)*(n-2)];
                    measures.efficlocal = efficiency_wei(matrix,1);
                    [measures.commstructureclassical measures.modularityclassical]=modularity_dir(matrix, 1);
                    [measures.commstructurelouvain measures.modularitylouvain] = community_louvain(matrix,1);
                    measures.commstructurelouvain = measures.commstructurelouvain';   
                     measures.zscore=module_degree_zscore(matrix,measures.commstructurelouvain,0);
                    measures.participationcoeff=participation_coef(matrix,measures.commstructurelouvain,0);
                    [measures.richclub] = rich_club_wd(matrix)';
                    [measures.strength] = strengths_dir(matrix)';
                    measures.transitivity = transitivity_wd(matrix);
                    %}
                    %
                    %Undirected Networks
                    %measures.nonthreshmatrix = nonthreshmatrix;
                    %measures.matrix=matrix;
                    measures.thrlow =thrlow;
                    measures.thrhigh=thrhigh;
                    L = weight_conversion(matrix, 'lengths');
                    %Calculates Connection-Length matrix L. Higher weights are associated with shorter lengths. W = inverse of x
                    measures.assortativity = assortativity_wei(matrix,0);
                    %Measure correlation r (-1 for total neg correlation 0 for no correlation, and +1 for total pos
                    %correlation) of a node to other nodes with similar strengths. Uses Pearson Correlation Coefficient. 
                    measures.nodeclusteringcoeff = clustering_coef_wu(matrix);
                    measures.clusteringcoeff = mean(measures.nodeclusteringcoeff);
                    %Computes proportion C of completed triangles to possible ones (ie those with 2 edges to a node)
                    [measures.degree] = degrees_und(matrix)';
                    % # of edges for indiv nodes (deg)
                    [measures.density,N,K] = density_und(matrix);
                    %Outputs % of edges to possible edges in kden, with N vertices and K edges
                    [D B]=distance_wei(L);
                    %Outputs matrix D of shortest weighted path between every node. Outputs matrix B of # of edges between each node in
                    %shortest path. Utilizes Dijkstra's Algorithm -- Need metric (Euclidean?)
                    [measures.avgpath,measures.efficglobal,measures.eccentricity,measures.radius,measures.diameter] = charpath(D);
                    %lambda: avg path length from any node to another | effic: % effic as compared to complete graph
                    %ecc: max distance from node u to any node v | radius: ecc minimum | diam: ecc maximum
                    [measures.edgebetweenness measures.nodebetweenness]=edge_betweenness_wei(L);
                    measures.nodebetweenness = measures.nodebetweenness / [(n-1)*(n-2)];
                    %BC normalized from 0 to 1. Number of shortests paths that contain a given edge (EBC) or node (BC)
                    measures.efficlocal = efficiency_wei(matrix,1);
                    %Determines how well neighbors of node communicate without it. Can be related to clust coeff
                    [measures.commstructureclassical measures.modularityclassical]=modularity_und(matrix, 1);
                    %Alternative to community_louvain
                    [measures.commstructurelouvain measures.modularitylouvain] = community_louvain(matrix,1);
                    %Outputs community structure M (ie which module each node is in), and optimized node order Q                   
                    measures.commstructurelouvain = measures.commstructurelouvain';                 
                    measures.zscore=module_degree_zscore(matrix,measures.commstructurelouvain,0);
                    %Provides centrality of node within its module. Values < 0 and > 1?....Shows how well node is connected to those within its module. Useful to detect hubs
                    measures.participationcoeff=participation_coef(matrix,measures.commstructurelouvain,0);
                    %Measures interconnectivity, ie, how a node is connected to its own module in relation to other modules
                    %A value of 0 implies only within module connections, while 1 implies uniform connectivity over all modules
                    [measures.richclub] = rich_club_wu(matrix)';
                    %Computes plot Rw of averaged connection strength for nodes of degree k or higher
                    %Determines how connected high degree networks are to each other
                    [measures.strength] = strengths_und(matrix)';
                    % avgd strength of each node
                    [measures.score,sn] = score_wu(matrix,8);
                    %Largest subnetwork of strength > s
                    measures.transitivity = transitivity_wu(matrix);
                    [measures.avgcoh_O,measures.avgcoh_F] = gui_withinregionconn(BNCT,matrix);
                   % measures.connections = gui_shortlongconnections(BNCT,matrix);
                    %Alternative to CC
                   % try
                   %     Oz_loc = find(strcmp(BNCT.chanord.(BNCT.chanord.method).labels,'Oz'));
                   %     measures.Oz_degree = sum(double(matrix(:,Oz_loc)~=0));
                   %     measures.Oz_strength = 
                   % catch
                   % end
                   %}
                    %Local connectivity
                  %  clustcheck = BNCT.clustering.method == 1 || ~isfield(BNCT,'clustering');
                    %Cluster averaging of local measures 
                    if isfield(BNCT,'clustering')
                        if BNCT.clustering.method == 2
                        for i = 1:size(BNCT.clustering.clusters,1)
                            r1 = BNCT.clustering.clusters{i};
                            r1_n = [];
                            for y = 1:size(BNCT.clustering.clusters{i},2)
                                r1_n(y) = strmatch(r1{y},BNCT.chanord.orig.labels);
                            end
                        measures.clusters.degree(i) = mean(measures.degree(r1_n));
                        measures.clusters.eccentricity(i) = mean(measures.eccentricity(r1_n));
                        measures.clusters.nodebetweenness(i) = mean(measures.nodebetweenness(r1_n));
                        measures.clusters.efficlocal(i) = mean(measures.efficlocal(r1_n));
                        measures.clusters.nodeclusteringcoeff(i) = mean(measures.nodeclusteringcoeff(r1_n));
                        measures.clusters.strength(i) = mean(measures.strength(r1_n));
                        measures.clusters.participationcoeff(i) =  mean(measures.participationcoeff(r1_n));
                        cmatrix1 = matrix(r1_n,r1_n);
                        cmatrix1 = triu(cmatrix1);
                        measures.clusters.intraconn(i) = nnz(cmatrix1);
                        %cmatrix2 = triu(matrix);
                        %cmatrix2 = cmatrix2(r1_n,:);
                        %cmatrix2(:,r1_n) = 0;
                        
                        measures.clusters.interconn(i) = nnz(matrix(r1_n,:));
                        measures.clusters.clusternames{i} = BNCT.clustering.clusternames{i};
                        end
                        end
                    end
                    
                    %Random matrix measures
                    if sum(sum(measures.threshmatrix))/sum(sum(measures.nonthreshmatrix)) > 0.95 
                      %  [w0, r] = null_model_dir_sign(matrix,10,.1);%Directed
                        R = randmio_und_jj(matrix,5); %WU
                        L2 = weight_conversion(R, 'lengths');%R, w0
                        [D2 B]=distance_wei(L2);
                        [measures.avgpath_random,measures.efficglobal_random,measures.eccentricity_random,measures.radius_random,measures.diameter_random] = charpath(D2);
                        measures.clusteringcoeff_random = clustering_coef_wu(R);%R,w0
                        measures.clusteringcoeff_random = mean(measures.clusteringcoeff_random);
                        measures.smallworldness = (measures.clusteringcoeff/measures.clusteringcoeff_random)/(measures.avgpath/measures.avgpath_random);
                    end
                end
                
                
            catch
                bad_thresh=1;
                break
            end
            
            MeasuresPerTime(time) = measures;
        end
        %% Check if error running any measures
        if exist('bad_thresh','var');
            break
        end
            
        MeasuresPerFreq(freq,1:numtimebins) = MeasuresPerTime; %NUM TIME BINS


    end
        if exist('bad_thresh','var');
            break
        end
    %  allmeasures{subject} = MeasuresPerFreq;
    %%                           STORE DATA
    
    %Data goes into allmeasures.(Condition).(task).(subject#) cell matrix
    %Inside this is a 4 frequency rows by num time bins columns array, where all
    %graph theory measures are stored

    for b = 1:1:length(phenotypelistraw)
        if strfind(raw{subject,7},phenotypelistraw{b}) > 0
            for k = 1:1:length(tasklist)
                if strfind(raw{subject,9},(tasklistraw{k})) > 0
                    allmeasures.(phenotypelistraw{b}).(tasklist{k}){sub.(phenotypelistraw{b})(k)} = MeasuresPerFreq;
                    
                    sub.(phenotypelistraw{b})(k) = sub.(phenotypelistraw{b})(k)+1;
                end
            end
        end
    end
    waitbar(subject/length(raw),h);
    prog = strcat(num2str(subject),'/',num2str(size(raw,1)),' graph measures complete');
    disp(prog);
end
        if exist('bad_thresh','var');
            msgbox('Threshold too high to calculate graph measures');
            return
        end
close(h)