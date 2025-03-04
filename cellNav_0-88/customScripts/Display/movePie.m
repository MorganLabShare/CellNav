function[] = movePie(h,scale,x,y,z)

%%Moves a pie chart and text. h = plot handle, scale = scaling factor, x,y,z =
%%distance moved in respective dimension

if ~exist('x','var'),x = 0;,end
if ~exist('y','var'),y = 0;,end
if ~exist('z','var'),z = 0;,end

for k = 1:length(h) % Walk the vector of text and patch handles
      if strcmp(get(h(k),'Type'),'patch') % Patch graphics
          XData = get(h(k),'XData');  % Extract current data
          YData = get(h(k),'YData');
          ZData = get(h(k),'ZData');
          set(h(k),'XData',XData*scale + x); % Insert modified data
          set(h(k),'YData',YData*scale + y);
          set(h(k),'ZData',ZData*scale + z);
          
      elseif strcmp(get(h(k),'Type'),'surface') % Patch graphics
           XData = get(h(k),'XData');  % Extract current data
          YData = get(h(k),'YData');
          ZData = get(h(k),'ZData');
          set(h(k),'XData',XData*scale + x); % Insert modified data
          set(h(k),'YData',YData*scale + y);
          set(h(k),'ZData',ZData*scale + z);
         
          
      else    % Text labels
          try
              Pos = get(h(k),'Position'); % Extract
              set(h(k),'Position',Pos*scale + [x y z]); % Insert
              set(h(k),'FontSize',8);
          end
      end
end