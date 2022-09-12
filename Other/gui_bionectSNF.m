%function gui_bionectSNF(BNCT,pheno,task,freq)

pheno = 2;
task = 2;
freq = 2;
NODEFILE = 'C:\Users\Joseph\Dropbox\SDRT\Excel files\TD_Node.csv';
EDGEFILE = 'C:\Users\Joseph\Dropbox\SDRT\Excel files\TD_Edge.csv';
count=1;
W_matrix = []; weight = []; source = []; time_start = [];
target = []; time_end = []; label=[]; type=[]; time_interval = [];
start_time = 0;
end_time = 2;
for i=1:size(BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task}),2)
    data = BNCT.allmeasures.(BNCT.config.phenotypelistraw{pheno}).(BNCT.config.tasklist{task});
    for j = 1:size(data{1},2)
        if i==1
            W_matrix{j}=data{i}(freq,j).matrix;
        else
            W_matrix{j}=data{i}(freq,j).matrix + W_matrix{j};
        end
            

    end
end
    for j = 1:size(data{1},2)
        W_matrix{j} = W_matrix{j}/i;
    end
    
t1 = 0;
t2=2;
n= size(BNCT.config.batch_chnlist,2);
nodedata = cell([n+1 3]);
nodedata{1,1} = 'Label'; nodedata{1,2} = 'ID'; nodedata{1,3} = 'Time Interval';
for h = 1:n
    nodedata{h+1,1} = BNCT.chanord.(BNCT.chanord.method).labels{h}; %OR SUBJECT
    nodedata{h+1,2} = h;
    nodedata{h+1,3} = horzcat('<[',num2str(t1),'|',num2str(t2),']>');
end
cell2csv(NODEFILE,nodedata);

for m = 1:j
for k = 1:n-1
    for l = k+1:n
        weight = [weight;W_matrix{m}(k,l)];
        source = [source;k];
        target = [target;l];
        time_interval = [time_interval;{horzcat('<[',num2str(t1),'|',num2str(t2),']>');}];
        time_start = [time_start; (m)*(t2/j)];
        time_end = [time_end; (m+1)*(t2/j)];
        label = [label;{strcat(strcat('Node',num2str(k)),strcat('to',num2str(l)))}];%{strcat(BNCT.chanord.(BNCT.chanord.method).labels{k},'-',BNCT.chanord.(BNCT.chanord.method).labels{l})}]; %OR SUBJECT-SUBJECT
        type = [type;{'undirected'}];
    end
end
end

edgedata = cell([1 7]);
edgedata{1,1} = 'Source'; edgedata{1,2} = 'Target'; edgedata{1,3} = 'Weight'; edgedata{1,4} = 'Label'; edgedata{1,5} = 'Type'; edgedata{1,6} = 'Start'; edgedata{1,7} = 'End'; edgedata{1,8} = 'Time Interval';
for k=2:size(weight,1)+1
    edgedata{k,1} = source(k-1);
    edgedata{k,2} = target(k-1);
    edgedata{k,3} = weight(k-1);
    edgedata{k,4} = label{k-1};
    edgedata{k,5} = type{k-1};
    edgedata{k,6} = time_start(k-1);
    edgedata{k,7} = time_end(k-1);
    edgedata{k,8} = time_interval{k-1};
end
cell2csv(EDGEFILE,edgedata);
x=1
