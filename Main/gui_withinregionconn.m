function [avgcoh_O,avgcoh_F] = gui_withinregionconn(BNCT,matrix)
%matrix = BNCT.alldata(:,:,1,2,1);
%List channels you want to keep in new matrix here
region = {'O1','Oz','O2'};
region2 = {'F3','Fz','F4'};
%region2 = {'A1','FP1','O1'};

    chlist = BNCT.chanord.(BNCT.chanord.method).labels;

    for i = 1:1:size(region,2)
        IndexC = strfind(chlist, region{i});
        Index1(i) = find(not(cellfun('isempty', IndexC)));
    end
    for i = 1:1:size(region2,2)
        IndexC = strfind(chlist, region2{i});
        Index2(i) = find(not(cellfun('isempty', IndexC)));
    end
    reduced_matrix = matrix(Index1,Index1);
    reduced_matrix2 = matrix(Index2,Index2);
  avgcoh_O = mean(reduced_matrix(find(triu(reduced_matrix,1))));
  avgcoh_F = mean(reduced_matrix2(find(triu(reduced_matrix2,1))));