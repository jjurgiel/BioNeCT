%function reduced_matrix = gui_2regionconnectivity(BNCT,matrix)
matrix = BNCT.alldata(:,:,1,1,1);
%List channels you want to keep in new matrix here
region1 = {'F9','P9','F7'};
region2 = {'A1','FP1','O1'};


%% 

    try
    chlist = BNCT.chanord.(BNCT.chanord.method).labels;

    for i = 1:1:size(region1,2)
        IndexC = strfind(chlist, region1{i});
        Index1(i) = find(not(cellfun('isempty', IndexC)));
    end
    for i = 1:1:size(region2,2)
        IndexC = strfind(chlist, region2{i});
        Index2(i) = find(not(cellfun('isempty', IndexC)));
    end
    reduced_matrix = matrix(Index2,Index1);
    catch
        1;
    end
