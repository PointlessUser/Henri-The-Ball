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
annotation('textbox', [.45, 0.89,.1,.1], 'string', 'Have Fun!','EdgeColor','none','FontSize',30*(x+y)/2,'color',[1,.99,1])

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

%drawing environment
rectangle('Position',[0,10,2,90],'FaceColor',[.3,.3,.3])
rectangle('Position',[2,10,10,5])
rectangle('Position',[12,0,3,15],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[20,30,4,5])
rectangle('Position',[20,10,4,20],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[30,0,2,10],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[30,21,2,10],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[37,0,2,17],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[45,0,5,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[50,0,5,10])
rectangle('Position',[55,0,5,15],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[60,0,5,20])
rectangle('Position',[65,0,35,30],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
rectangle('Position',[24,37,81,5])
rectangle('Position',[93,60,5,5])

rectangle('Position',[98,0,2,75],'FaceColor',[.3,.3,.3])

%Environment x and y values
blocks=[4,13,20,20,30,30,37,45,50,55,60,65,24,93;... %min x
    12,16,24,24,32,32,39,50,55,60,65,95,100,98;... %max x
    10,0,30,10,0,21,0,0,0,0,0,0,37,60;... %min y values
    15,15,35,30,10,31,17,5,10,15,20,30,42,65]; %max y values

%tells you weather the trap is shown or not
trap_state=0;

%-----------------------loop----------------------------%
while true
    %change trap block colour
    if ((((abs(playerPos(1)-20)<=5)||(abs(playerPos(1)-24)<=5)))&&(((abs(playerPos(2)-30)<=7)||(abs(playerPos(2)-35)<=7))))&&(trap_state==0)
        rectangle('Position',[20,30,4,5],'FaceColor',[.9,.1,.3],'EdgeColor',[.1,0,0])
        trap_state=1;
    elseif (trap_state==1) && not(((abs(playerPos(1)-20)<=5)||(abs(playerPos(1)-24)<=5))&&((abs(playerPos(2)-30)<=7)||(abs(playerPos(2)-35)<=7)))
        rectangle('Position',[20,30,4,5],'FaceColor',[.9,.9,.9])
        trap_state=0;
    end
    
    
    %check if player hit a solid block
    if (playerPos(1)<=1 && sign(playerVel(1))==-1) ||(playerPos(1)>=100 && sign(playerVel(1))==1)...
            || ((playerPos(1)>=97 && playerPos(2)<=75) && sign(playerVel(1))==1)...
            || ((playerPos(1)<=3 && sign(playerVel(1))==-1)&&playerPos(2)>=10)
        playerVel(1)=0;
    end
    
    %check if player hits bottom of solid block
    if (playerPos(1)>=0)&&(playerPos(1)<=2.9)&&(playerVel(2)>0)&&playerPos(2)>=9
        playerVel(2)=0;
        playerPos(2)=9;
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
    
    %check if ball hits block
    underBlock=(find(((playerPos(1)+1)>=blocks(1,:)) == ((playerPos(1))<=blocks(2,:))));
    besideBlock=(find(((playerPos(2)+1)>=blocks(3,:)) == ((playerPos(2)-1.5)<=blocks(4,:))));
    for beside=besideBlock
        for under=underBlock
            if max(under==besideBlock)
                if (playerVel(2)<=0)
                    playerVel=[playerVel(1),0];
                    playerPos(2)=blocks(4,under)+1.5;
                end
                if max(under==[2,3,4,5,6,7,8,10,12])&&max(beside==[2,3,4,5,6,7,8,10,12])
                    playerVel=[0,0];
                    playerPos=[1,2];
                    trap_state=1;
                end
            end
        end
    end
    
    %If you reach the end, go to the next level
    if playerPos(1)==100 && playerPos(2)>=77
        lvl4
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