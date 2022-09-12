function reduced_matrix = gui_subconnmatrix(BNCT,matrix)

%1 = reduce matrix size to channels below, 0 = keep same
reduce_flag = 1; 
%List channels you want to keep in new matrix here
my_chs = {'F9','P9','F7','P7','F3','P3'};


%% 
if reduce_flag == 1
    try
    chlist = BNCT.chanord.(BNCT.chanord.method).labels;

    for i = 1:1:size(my_chs,2)
        IndexC = strfind(chlist, my_chs{i});
        Index(i) = find(not(cellfun('isempty', IndexC)));
    end
    reduced_matrix = matrix(Index,Index);
    catch
        1;
    end
else
    reduced_matrix = matrix;
end