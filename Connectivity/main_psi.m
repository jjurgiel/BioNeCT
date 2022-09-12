% demonstrates the use of phase slope index (PSI) as formulated in the paper:
%    Nolte G, Ziehe A, Nikulin VV, Schl\"ogl A, Kr\"amer N, Brismar T,
%    M\"uller KR. 
%    Robustly estimating the flow direction of information in complex
%    physical systems. 
%    Physical Review Letters. To appear. 
%    (for further information see    http://doc.ml.tu-berlin.de/causality/
%    )
%

% License
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see http://www.gnu.org/licenses/.







% trivial example for flow from channel 1 to channel 2. 
%n=1000;x=randn(n+1,1);data=[x(2:n+1),x(1:n)]; 
%

 t = [0:1/500:5];
 A1 = 1;
 A2 = 2;
 f1 = 10;
 f2 = 15;
 y = A1*sin(2*pi*f1*t)-.5*sin(2*pi*25*t)+1*sin(2*pi*40*t);
 z = A2*sin(2*pi*f2*t);
 x = 2*z;
  plot(t,y)
  hold on
  plot(t,z)
  data = [y' z' x'];
  segleng=500;epleng=500;
% parameters for PSI-calculation 
%}
%{
x=EEG.data(1,:,:);
y=EEG.data(2,:,:);
x_data_sq=squeeze(x);                                 %squeeze all data at frames in trial 1
y_data_sq=squeeze(y);
x_bin = reshape( x_data_sq, 1, size(x_data_sq,1)*size(x_data_sq,2));
y_bin = reshape( y_data_sq, 1, size(y_data_sq,1)*size(y_data_sq,2));
segleng=EEG.srate;epleng=EEG.srate;
data = [x_bin(1:end-1)', x_bin(2:end)'];
%}
% calculation of PSI. The last argument is empty - meaning that 
% PSI is calculated over all frequencies
[psi, stdpsi, psisum, stdpsisum]=data2psi(data,segleng,epleng,[]);
%[psi, stdpsi, psisum, stdpsisum]
%psi
% note, psi, as calculated by data2psi corresponds to \hat{\PSI} 
% in the paper, i.e., it is not normalized. The final is 
% the normalized version given by: 
psi./(stdpsi+eps)


% For psisum and stdpsisum refer to the paper


% To calculate psi in a band set, e.g., 
freqs=[5:10];
[psi2, stdpsi2, psisum2, stdpsisum2]=data2psi(data,segleng,epleng,freqs);
%[psi2, stdpsi2, psisum2, stdpsisum2]
%psi2
%with result:
psi2./(stdpsi2+eps)
% In this example, the flow is estimated to go from channel 
% 1 to channel 2 because the matrix element psi(1,2) is positive. 

% You can also calculate many bands at once, e.g. 
freqs={[5:10];[6:11];[7:13]};
[psi3, stdpsi3, psisum3, stdpsisum3]=data2psi(data,segleng,epleng,freqs);
%psi3
%and psi has then 3 indices with the last one refering to the row in freqs: 
psi3./(stdpsi3+eps)