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
annotation('textbox', [.35, 0.89,.1,.1], 'string', "'It's not a bug, it's a feature' ",'EdgeColor','none','FontSize',30*(x+y)/2,'color',[1,.99,1])

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
rectangle('Position',[2,70,20,5])
rectangle('Position',[2,50,16,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[23,50,16,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[18,30,5,5])
rectangle('Position',[14,10,86,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[2,10,8,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[98,0,2,85],'FaceColor',[.3,.3,.3])
rectangle('Position',[90,15,2,85])
rectangle('Position',[40,65,4,23])
rectangle('Position',[54,15,4,23])
rectangle('Position',[80,50,7,17])
%Environment x and y values
blocks=[0,2,23,2,17,14,2,90,40,54,80;... %min x value
    2,5,41,3,24,100,11,92,69,60,97;... %max x value
    5,70,50,50,30,10,10,15,65,15,50;... %min y values
    75.5,75.5,55.5,55.5,35.5,15.5,25.5,95,87,40,57]; %max y values

%-----------------------loop----------------------------%
while true
    %check if wall is hit
    
    %check if player hit a solid block
    if (playerPos(1)<=1 && sign(playerVel(1))==-1) ||(playerPos(1)>=100 && sign(playerVel(1))==1)...
            || ((playerPos(1)>=90 && playerPos(2)>=10) && sign(playerVel(1))==1)...
            || ((playerPos(1)<=3 && sign(playerVel(1))==-1)&&playerPos(2)>=30)
        playerVel(1)=0;
    end
    %check if player hit the roof or is on the floor
    if (playerPos(2)<=2 && sign(playerVel(2))==1) || playerPos(1)>=98
        playerVel(2)=0;
        playerPos(2)=-0.5;
    elseif (playerPos(2)>=98 && sign(playerVel(2))==1)
        playerVel(2)=-5;
        playerPos(2)=99;
    end
    
    
    %gravity
    if playerPos(2)>2
        playerVel(2)=playerVel(2)-.1;
    end
    
    %check if ball hits any block
    underBlock=(find(((playerPos(1)+5)>=blocks(1,:)) == ((playerPos(1))<=blocks(2,:))));
    besideBlock=(find(((playerPos(2)+5)>=blocks(3,:)) == ((playerPos(2)-1.5)<=blocks(4,:))));
    for beside=besideBlock
        for under=underBlock
            if max(under==besideBlock)
                if (playerVel(2)<=0)
                    playerVel=[playerVel(1);0];
                    playerPos(2)=blocks(4,under)+1.5;
                end
                %check if ball hits red block
                if max(under==[6,5,10])&&playerVel(2)>=1
                    playerVel=[0,0];
                    playerPos=[1,77];
                end
                if max(under==[7,5,10])&&max(beside==[7,5,10])
                    playerVel(2)=5;
                end
            end
        end
    end
    
    
    if playerPos(1)==100 && playerPos(2)<=10
        End
    end
    
    %making the level beatable
    if playerPos(1)==90
        playerPos(1)=95;
        playerPos(2)=1;
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
    playerPos(2)=playerPos(2)-10; %Go through block
end
if (event.Key=="downarrow")||(event.Key=="s")
    playerVel(1)=0; %stop moving horizontaly
end
end