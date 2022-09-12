function gui_graphmeasures2


   geometry = { [2 1 .5] [2 1 0.5] [2 1.5] [2 1 0.5] };
   uilist = { { 'style' 'text'       'string' 'Thresholding Method' } ...
              { 'style' 'edit'       'string' '' 'tag' 'events' } ...
              { 'style' 'pushbutton' 'string' '...' } ...
              { 'style' 'text'       'string' 'Epoch limits [start, end] in seconds' } ...
              { 'style' 'edit'       'string' '-1 2' } ...
              { } ...
              { 'style' 'text'       'string' 'Name for the new dataset' } ...
              { 'style' 'edit'       'string'  'text' } ...
              { 'style' 'text'       'string' 'Out-of-bounds EEG limits if any [min max]' } ...
              { 'style' 'edit'       'string' '' } { } };
              
   result = inputgui( geometry, uilist, 'Extract data epochs - pop_epoch()');