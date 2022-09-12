function connections = gui_shortlongconnections(BNCT,matrix)

%matrix = BNCT.allmeasures.Affected.dot1{1,1}(1,1).threshmatrix;
n = size(matrix,1);
clusters = BNCT.clustering.clusters;


for a = 1:size(clusters,1)
    connections.longrange{a} = 0;
    connections.shortrange{a} = 0;
end

for i = 1:n   
    for j = 1:n
        i_label = BNCT.chanord.(BNCT.chanord.method).labels{i};
        j_label = BNCT.chanord.(BNCT.chanord.method).labels{j};
        if matrix(i,j) > 0 
            count = 1;
            clust_num = [];
            %Find which cluster electrode i is in
            while isempty(clust_num)
                clust_num = find(strcmp(BNCT.clustering.clusters{count},i_label));
                clust = count;
                count = count + 1;
            end
            %See if electrode j is in same cluster or not
            if isempty(find(strcmp(BNCT.clustering.clusters{clust},j_label)))
                connections.longrange{clust} = connections.longrange{clust} + 1;
            else
                connections.shortrange{clust} = connections.shortrange{clust} + .5; 
                %.5 to account for i to j and j to i within same module
                %counting twice
            end
        end
    end
end
