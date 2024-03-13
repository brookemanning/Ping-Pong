%pingpong visual setup: board, center line, paddle, ball
%written 3/12 by Yuki Ueta

%creating background
tablecolor = uint8([42,54,74]);
board = figure('Color',tablecolor,'Position',[150,200,1200,750]);
fig_position = get(board, 'Position'); %vector for board x, y, wid, h
boardwidth = fig_position(3);
boardheight = fig_position(4);

%create axes to make boundary lines
ax = axes('Color','none','Position',[0,0,1,1]);
%create line in center
x_center = [0.5, 0.5]; %x coord for ends of line
y_center = [0, 1]; %y coords for ends of line
line(x_center,y_center,'Color','white','LineStyle','--','LineWidth',6);

%creating paddles
paddlewidth = 0.015;
paddleheight = 0.15;
%initial paddle position!
paddleA_position = [0,0.5 - (paddleheight/2),paddlewidth,paddleheight];
paddleB_position = [1-paddlewidth,0.5 - (paddleheight/2),paddlewidth,paddleheight];
%create rectangular paddles
paddleA = rectangle(ax,'Position',paddleA_position,'EdgeColor','white','FaceColor','white');
paddleB = rectangle(ax,'Position',paddleB_position,'EdgeColor','white','FaceColor','white');

%creating the ball
% %initial ball position!
ballradius = 0.02;
ballposition = [0.5 + ballradius/2,0.5];
ballcolor = uint8([255,193,59]);
ball = rectangle(ax,'Position',[ballposition - ballradius,ballradius + (ballradius * 0.2),ballradius*2],'Curvature',1,'EdgeColor','none','FaceColor',ballcolor);


%creating the scoreboard

