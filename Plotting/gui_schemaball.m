function gui_schemaball(BNCT,cohmatrix_avg,chanord)
r = cohmatrix_avg;
%% Parameters
% Tweak these only

% Number of color shades/buckets (large N simply creates many perceptually indifferent color shades)
N      = 20;
% Points in [0, 1] for bezier curves: leave space at the extremes to detach a bit the nodes. 
% Smaller step will use more points to plot the curves.
t      = (0.025: 0.05 :1)';
% Nodes edge color
ecolor = [.25 .103922 .012745];
% Text color
tcolor = [.7 .7 .7];

%% Checks

% Ninput
%narginchk(0,4)

% Some defaults
%if nargin < 1 || isempty(r);        r      = (rand(50)*2-1).^29;                                  end
sz = size(r);
%if nargin < 2 || isempty(lbls);  
%BNCT = evalin('base','BNCT');
EEG = BNCT.EEG;%evalin('base','EEG');
switch chanord.method
    case 'orig'
    for i = 1:1:EEG.nbchan
        lbls{i} = EEG.chanlocs(1,i).labels;
    end
    lbls = lbls';
    case 'new'
        lbls = chanord.new.labels;
end
 %   lbls   = cellstr(reshape(sprintf('%-4d',1:sz(1)),4,sz(1))'); % end
%if nargin < 4 || isempty(ncolor);   
    ncolor = [0 0 1];                   %                          end

% R
%if ~isnumeric(r) || any(abs(r(:)) > 1) || sz(1) ~= sz(2) || numel(sz) > 2 || sz(1) == 1
%    error('schemaball:validR','R should be a square numeric matrix with values in [0, 1].')
%end

% Lbls
%if (~ischar(lbls) || size(lbls,1) ~= sz(1)) && (~iscellstr(lbls) || ~isvector(lbls) || length(lbls) ~= sz(1))
%    error('schemaball:validLbls','LBLS should either be an M by N char array or a cellstring of length M, where M is size(R,1).')
%end
%if ischar(lbls)
%    lbls = cellstr(lbls);
%end

% Ccolor
%if nargin < 3 || isempty(ccolor);
    ccolor = hsv2rgb([[linspace(.8333, .95, N); ones(1, N); linspace(1,0,N)],...
                      [linspace(.03, .1666, N); ones(1, N); linspace(0,1,N)]]');
%{
                  else
    szC = size(ccolor);
    if ~isnumeric(ccolor) || szC(2) ~= 3  || szC(1) > 2
        error('schemaball:validCcolor','CCOLOR should be a 1 by 3 or 2 by 3 numeric matrix with RGB colors.')
    elseif szC(1) == 1
        ccolor = [ccolor; ccolor];
    end
    ccolor = rgb2hsv(ccolor);
    ccolor = hsv2rgb([repmat(ccolor(1,1:2),N,1), linspace(ccolor(1,end),0,N)';
                      repmat(ccolor(2,1:2),N,1), linspace(0,ccolor(2,end),N)']);
end
%}
% Ncolor
szN = size(ncolor);
if ~isnumeric(ncolor) || szN(2) ~= 3  || szN(1) > 1
    error('schemaball:validNcolor','NCOLOR should be a single RGB color, i.e. a numeric row triplet.')
end
ncolor = rgb2hsv(ncolor);
%% Engine

% Create figure
%figure(4)
%hold on
%set('figure 4','renderer','zbuffer','visible','off')
%if ishandle(5)
%cla
%end
f = figure(5);
hold off
set(5,'renderer','zbuffer','visible','off','position', [0, 0, 500, 500],'name','Schemaball','NumberTitle','off');
axis off
%f = figure('renderer','zbuffer','visible','off')

%axes(handles.axes3);
%set(handles.axes3,'renderer','zbuffer','visible','off')
axes('NextPlot','add')
%cla;
%axes(handles.axes3);

% Index only low triangular matrix without main diag
tf        = tril(true(sz),-1);

% Index correlations into bucketed colormap to determine plotting order (darkest to brightest)
N2        = 2*N;
[n, isrt] = histc(r(tf), linspace(-1,1 + eps(100),N2 + 1));
plotorder = reshape([N:-1:1; N+1:N2],N2,1);

% Retrieve pairings of nodes
[row,col] = find(tf);

% Use tau http://tauday.com/tau-manifesto
tau   = 2*pi;
% Positions of nodes on the circle starting from (0,-1), useful later for label orientation
step  = tau/sz(1);
theta = -.25*tau : step : .75*tau - step;
% Get cartesian x-y coordinates of the nodes
x     = cos(theta);
y     = sin(theta);

% PLOT BEZIER CURVES 
% Calculate Bx and By positions of quadratic Bezier curves with P1 at (0,0)
% B(t) = (1-t)^2*P0 + t^2*P2 where t is a vector of points in [0, 1] and determines, i.e.
% how many points are used for each curve, and P0-P2 is the node pair with (x,y) coordinates.
t2  = [1-t, t].^2;
s.l = NaN(N2,1);
% LOOP per color bucket
for c = 1:N2
    pos = plotorder(c);
    idx = isrt == pos;
    if nnz(idx)
        Bx     = [t2*[x(col(idx)); x(row(idx))]; NaN(1,n(pos))];
        By     = [t2*[y(col(idx)); y(row(idx))]; NaN(1,n(pos))];
        s.l(c) = plot(Bx(:),By(:),'Color',ccolor(pos,:),'LineWidth',1);
    end
end

% PLOT NODES
% Do not rely that r is symmetric and base the mean on lower triangular part only
[row,col]  = find(tf(end:-1:1,end:-1:1) | tf);
subs       = col;
iswap      = row < col;
tmp        = row(iswap);
row(iswap) = col(iswap);
col(iswap) = tmp;
% Plot in brighter color those nodes which on average are more absolutely correlated
[Z,isrt]   = sort(accumarray(subs,abs(r( row + (col-1)*sz(1) )),[],@mean));
Z          = (Z-min(Z)+0.01)/(max(Z)-min(Z)+0.01);
ncolor     = hsv2rgb([repmat(ncolor(1:2), sz(1),1) Z*ncolor(3)]);
s.s        = scatter(x(isrt),y(isrt),[], ncolor,'fill','MarkerEdgeColor',ecolor,'LineWidth',1);

% PLACE TEXT LABELS such that you always read 'left to right'
ipos       = x > 0;
s.t        = zeros(sz(1),1);
s.t( ipos) = text(x( ipos)*1.1, y( ipos)*1.1, lbls( ipos),'Color',tcolor);
set(s.t( ipos),{'Rotation'}, num2cell(theta(ipos)'/tau*360))
s.t(~ipos) = text(x(~ipos)*1.1, y(~ipos)*1.1, lbls(~ipos),'Color',tcolor);
set(s.t(~ipos),{'Rotation'}, num2cell(theta(~ipos)'/tau*360 - 180),'Horiz','right')

% ADJUST FIGURE height width to fit text labels
xtn        = cell2mat(get(s.t,'extent'));
post       = cell2mat(get(s.t,'pos'));
sg         = sign(post(:,2));
posfa      = cell2mat(get([gcf gca],'pos'));
% Calculate xlim and ylim in data units as x (y) position + extension along x (y)
ylims      = post(:,2) + xtn(:,4).*sg;
ylims      = [min(ylims), max(ylims)];
xlims      = post(:,1) + xtn(:,3).*sg;
xlims      = [min(xlims), max(xlims)];
% Stretch figure
posfa(1,3) = (( diff(xlims)/2 - 1)*posfa(2,3) + 1) * posfa(1,3);
posfa(1,4) = (( diff(ylims)/2 - 1)*posfa(2,4) + 1) * posfa(1,4);
% Position it a bit lower (movegui slow)
posfa(1,2) = 100;

% Axis settings
set(gca, 'Xlim',xlims,'Ylim',ylims, 'color', 'k', 'layer','bottom', 'Xtick',[],'Ytick',[])
set(gcf, 'pos' ,posfa(1,:),'Visible','on')
axis equal

if nargout == 1
    h = s;
end