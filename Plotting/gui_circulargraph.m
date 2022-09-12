h=figure(1);clf(h);

%{
matrix = allmeasures.Affected.dot1{1,1}(1,1).matrix;
[ind1, ind2] = ind2sub(size(matrix),find(matrix(:)));
theta=linspace(0,2*pi,size(matrix,1)+1);theta=theta(1:end-1);
[x,y]=pol2cart(theta,1);
xy = [ind1';ind2'];
h=figure(1);clf(h);
plot(x,y,'om','markersize',12,'LineWidth',3);hold on
fnplt(cscvn(xy),'r',2)
%arrayfun(@(p,q)line([x(p),x(q)],[y(p),y(q)]),ind1,ind2);
axis equal off
%}
       x=linspace(0,2*pi,21); f = spapi(4,x,sin(x));
       fnplt(f,'r',3,[1 3])