
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
annotation('textbox', [.14, 0.875,.1,.1], 'string', 'Press down to go down. Red blocks kill you','EdgeColor','none','FontSize',25*(x+y)/2,'color',[1,.99,1])

%axes
platformAxis = axes('color',[.9,.9,.9],...
    'XLim',[0,100],'XTickLabels',[],'XTick',[],...
    'YLim',[0,100],'YTickLabels',[],'YTick',[]);

%player
global playerVel
global playerPos
playerVel = [0,0]; %Player velocity
playerPos = [1,77]; %players position
player = line(playerPos(1),playerPos(2),'marker','.','markersize',70*(x+y)/2,'color',[.7,.2,.2]);

%drawing environment
rectangle('Position',[0,0,2,75],'FaceColor',[.3,.3,.3])
rectangle('Position',[2,70,36,5])
rectangle('Position',[2,50,16,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[23,50,16,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[18,30,5,5])
rectangle('Position',[14,10,86,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[2,10,8,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[98,15,2,100],'FaceColor',[.3,.3,.3])
rectangle('Position',[38,15,70,90],'FaceColor',[.3,.3,.3])

%Environment x and y values
blocks=[0,2,23,2,17,14,2;... %min x value
    2,38,41,19,24,100,11;... %max x value
    0,70,50,50,30,10,10;... %min y values
    75.5,75.5,55.5,55.5,35.5,15.5,15.5]; %max y values

%-----------------------loop----------------------------%
while true
    
    %check if player hit a solid block
    if (playerPos(1)<=1 && sign(playerVel(1))==-1) ||(playerPos(1)>=100 && sign(playerVel(1))==1)...
            || ((playerPos(1)>=37 && playerPos(2)>=10) && sign(playerVel(1))==1)...
            || ((playerPos(1)<=3 && sign(playerVel(1))==-1)&&playerPos(2)<=76)
        playerVel(1)=0;
    end
    %check if player hit the roof or is on the floor
    if (playerPos(2)<=2 && sign(playerVel(2))==-1) || playerPos(1)>=98
        playerVel(2)=0;
        playerPos(2)=2;
    elseif (playerPos(2)>=98 && sign(playerVel(2))==1)
        playerVel(2)=0;
        playerPos(2)=98;
    end
    
    
    %gravity
    if playerPos(2)>5
        playerVel(2)=playerVel(2)-.1;
    end
    
    %check if ball hits any block
    underBlock=(find(((playerPos(1)+1)>=blocks(1,:)) == ((playerPos(1))<=blocks(2,:))));
    besideBlock=(find(((playerPos(2)+1)>=blocks(3,:)) == ((playerPos(2)-1.5)<=blocks(4,:))));
    for beside=besideBlock
        for under=underBlock
            if max(under==besideBlock)
                if (playerVel(2)<=0)
                    playerVel=[playerVel(1);0];
                    playerPos(2)=blocks(4,under)+1.5;
                end
                %check if ball hits red block
                if max(under==[3,4,6,7])
                    playerVel=[0,0];
                    playerPos=[1,77];
                end
            end
        end
    end
    
    %If you reach the end, go to the next level
    if playerPos(1)==100 && playerPos(2)<=10
        lvl3
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
        playerPos=[1,77];
end

%jump condition
if ((event.Key == "space")||(event.Key == "w")||(event.Key == "uparrow")) &&(playerVel(2)==0)
    playerVel(2)=2; %Jump up
elseif ((event.Key == "s")||(event.Key == "downarrow")) && (playerVel(2)~=0)
    playerVel(2)=-5; %Accelerate downwards
elseif ((event.Key == "s")||(event.Key == "downarrow")) && (playerVel(2)==0)&& (playerPos(2)>2) && (playerPos(1)<97) && (playerVel(1)==0)
    playerPos(2)=playerPos(2)-8.01; %Go through block
end
if (event.Key=="downarrow")||(event.Key=="s")
    playerVel(1)=0; %stop moving horizontaly
end
end