%function newchanord = gui_definechanorder(EEG,method)

figure
[x_elec,y_elec] = topoplot2([],EEG.chanlocs,'electrodes','ptslabels');
hold on
plot(y_elec,x_elec,'rd','MarkerSize',10)
newchanord = {};
selflag=0;
while ~selflag
[y1,x1] = ginput(1);

diffx = abs(x_elec - x1);
diffy = abs(y_elec - y1);

diffsum = diffx+diffy;

[minDiff, indexAtMin] = min(diffsum);

%Chosen electrode
x_sel = x_elec(indexAtMin);
y_sel = y_elec(indexAtMin);

hold on
if strmatch(EEG.chanlocs(indexAtMin).labels,newchanord)
    plot(y_elec(indexAtMin),x_elec(indexAtMin),'rd','MarkerSize',10)
    [m,indexLabel]=ismember(EEG.chanlocs(indexAtMin).labels, newchanord);
    newchanord(indexLabel) = [];
else
    plot(y_elec(indexAtMin),x_elec(indexAtMin),'gd','MarkerSize',10)
    newchanord = [newchanord;EEG.chanlocs(indexAtMin).labels];
end

if x==1
    selflag = 1;
end
end
