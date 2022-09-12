function gui_gephiconvert(m,ids,NODEFILE,EDGEFILE)
%Take in:
%Matrix, channel labels, file output, whether to write both node/edge file
%load('C:\Users\Joseph\Documents\ADHD SDRT\Coherence_Processed\Affected\986301\epoched\986301-3dotsMATCHNOMATCH-Correct3_CohValue.mat')
matrix = m;%raster_mat(:,:,1,1);
write_node = 1;
write_edge = 1;
%NODEFILE = 'C:\Users\Joseph\Dropbox\SDRT\Excel files\ASD_node.csv';
%EDGEFILE = 'C:\Users\Joseph\Dropbox\SDRT\Excel files\ASD_edge.csv';
n=size(matrix,1); %# of subjects/size of matrix
source = [];
target = [];
weight = [];
label = [];
type = [];
%matrix(matrix<0.89) = 0;


nodedata = cell([n+1 2]);
nodedata{1,1} = 'Label'; nodedata{1,2} = 'ID';
for h = 1:n
    nodedata{h+1,2} = h;
    nodedata{h+1,1} = ids{h,1};%FU{h,1};%strcat('Subject',num2str(h));%BNCT.chanord.(BNCT.chanord.method).labels{h}; %OR SUBJECT
end
cell2csv(NODEFILE,nodedata);
%

for i = 1:n-1
    for j = i+1:n
        weight = [weight;matrix(i,j)];
        source = [source;i];
        target = [target;j];
        label = [label;{strcat(strcat('Node',num2str(i)),strcat('to',num2str(j)))}];%{strcat(BNCT.chanord.(BNCT.chanord.method).labels{i},'-',BNCT.chanord.(BNCT.chanord.method).labels{j})}]; %OR SUBJECT-SUBJECT
        type = [type;{'undirected'}];
    end
end
edgedata = cell([1 5]);
edgedata{1,1} = 'Source'; edgedata{1,2} = 'Target'; edgedata{1,3} = 'Weight'; edgedata{1,4} = 'Label'; edgedata{1,5} = 'Type';
for k=2:size(weight,1)+1
    edgedata{k,1} = source(k-1);
    edgedata{k,2} = target(k-1);
    edgedata{k,3} = weight(k-1);
    edgedata{k,4} = label{k-1};
    edgedata{k,5} = type{k-1};
end
cell2csv(EDGEFILE,edgedata);
%}
