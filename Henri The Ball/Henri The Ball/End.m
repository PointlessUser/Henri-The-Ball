clear; clc; close all
%-----------------------Setup-----------------------------%

%Obtain screen resolution
set(0,'units','pixels')
res = get(0,'screensize');
%fraction of screen resoluton vs expected screen size
x=res(3)/1920;
y=res(4)/1080;

%figure
platformFigure = figure('color',[.4,.3,.4],'KeyPressFcn',@keyboard,'WindowState', 'maximized');

%Provide user with message
annotation('textbox', [.225, .6,.9,0], 'string', 'CONGRATULATIONS YOU WON!!!','EdgeColor','none','FontSize',50*(x+y)/2,'color','black')

%axes
platformAxis = axes('color',[.9,.9,.9],...
    'XLim',[0,100],'XTickLabels',[],'XTick',[],...
    'YLim',[0,100],'YTickLabels',[],'YTick',[]);

%player
global playerVel
global playerPos
playerVel = [0,0]; %Player velocity
playerPos = [1,2]; %players position
player = line(playerPos(1),playerPos(2),'marker','.','markersize',70*(x+y)/2,'color',[.7,.2,.2]);

%-----------------------loop----------------------------%
while true
    
    %check if player hit a solid block
    if (playerPos(1)<=1 && sign(playerVel(1))==-1) ||(playerPos(1)>=99 && sign(playerVel(1))==1)
        playerVel(1)=0;
    end
    %check if player hit the roof or is on the floor
    if (playerPos(2)<=2 && sign(playerVel(2))==-1)
        playerVel(2)=0;
        playerPos(2)=2;
    elseif (playerPos(2)>=98 && sign(playerVel(2))==1)
        playerVel(2)=0;
        playerPos(2)=98;
    end
    
    %gravity
    if playerPos(2)>2
        playerVel(2)=playerVel(2)-.1;
    end
    
    %move player
    playerPos=playerPos+playerVel;
    set(player,'XData',playerPos(1),'YData',playerPos(2))
    pause(.015)
end
%-----------------------Functions---------------------%
function keyboard(~,event)
global playerVel
global playerPos
switch event.Key
    %sets player velocity(left or right)
    case {'leftarrow','a'}
        playerVel(1)=-0.5; %Move left
    case {'rightarrow','d'}
        playerVel(1)=0.5; %Move Right
    case 'r' %restart
        playerVel=[0,0];
        playerPos=[3,2];
end


%jump condition
if ((event.Key == "space")||(event.Key == "w")||(event.Key == "uparrow")) &&(playerVel(2)==0)
    playerVel(2)=5; %Jump up
elseif ((event.Key == "s")||(event.Key == "downarrow")) && (playerVel(2)~=0)
    playerVel(2)=-5; %Accelerate downwards
elseif ((event.Key == "s")||(event.Key == "downarrow")) && (playerVel(2)==0)&& (playerPos(2)>2) && (playerPos(1)<97) && (playerVel(1)==0)
    playerPos(2)=playerPos(2)-8.01; %Go through block
end
if (event.Key=="downarrow")||(event.Key=="s")
    playerVel(1)=0; %stop moving horizontaly
end
end