%creating the background
tablecolor = uint8([42,54,74]);
board = figure('Color',tablecolor,'Position',[150,200,1200,750]); 
fig_position = get(board, 'Position'); %vector for board x, y, wid, h
boardwidth = fig_position(3);
boardheight = fig_position(4);

%create axes for the board
ax = axes('Parent',board,'Position',[0,0,1,1],'Color','none');
xlim([0,1]);
ylim([0,1]);
axis off;

%create line in center
x_center = [0.5, 0.5]; %x coord for ends of center line
y_center = [0, 1]; %y coords for ends of center line
line(x_center,y_center,'Color','white','LineStyle','--','LineWidth',6);

%creating paddles
paddlewidth = 0.015;
paddleheight = 0.15;
%initial paddle position!
paddleA_position = [0,0.5 - (paddleheight/2),paddlewidth,paddleheight];
paddleB_position = [1-paddlewidth,0.5 - (paddleheight/2),paddlewidth,paddleheight];
%create rectangular paddles
paddleA = rectangle('Parent',ax,'Position',paddleA_position,'EdgeColor','white','FaceColor','white');
paddleB = rectangle('Parent',ax,'Position',paddleB_position,'EdgeColor','white','FaceColor','white');

%creating the scoreboard
%ENTER SCORE A AND SCORE B INITIALIZATION
Score_PlayerA = 0;
Score_PlayerB = 0;
strScoreA = num2str(Score_PlayerA);
strScoreB = num2str(Score_PlayerB);
paddleA_score = text(ax,0.45,0.1,strScoreA,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');
paddleB_score = text(ax,0.55,0.1,strScoreB,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');

axis off;
xlim([0,1]);
ylim([0,1]);



%creating the ball
% %initial ball position!
ballradius = 0.02;
ballposition = [0.5 + ballradius/2,0.5];
ballcolor = uint8([255,193,59]);
ball = rectangle('Parent',ax,'Position',[ballposition - ballradius,ballradius + (ballradius * 0.2),ballradius*2],'Curvature',1,'EdgeColor','none','FaceColor',ballcolor);

% Set up KeyPressFcn/KeyReleaseFcn callback function
set(gcf, 'KeyPressFcn', @keyDown);
set(gcf, 'KeyReleaseFcn', @keyUp);

% define variables in global function
global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;

%initializing variables for key press
upArrowPressed = false;
downArrowPressed = false;
wKeyPressed = false;
sKeyPressed = false;
speedLevel = 0.01; 

% while loop to update the Y coordinates of paddle A and B position at speedLevel
% within the board 
   while true
       if wKeyPressed
           paddleAposition(2) = min(1-paddleheight, paddleAposition(2) + speedLevel);
           set(paddleA, 'Position', paddleAposition);
           
       elseif sKeyPressed
           paddleAposition(2) = max(0, paddleAposition(2) - speedLevel);
           set(paddleA, 'Position', paddleAposition);
          
       end

       if upArrowPressed
           paddleBposition(2) = min(1-paddleheight, paddleBposition(2) + speedLevel);
           set(paddleB, 'Position', paddleBposition);
          
       elseif downArrowPressed
           paddleBposition(2) = max(0, paddleBposition(2) - speedLevel);
           set(paddleB, 'Position', paddleBposition);
          
       end
       pause(0.01);
      
   end

ballvelocity = [0.01,0.01];
while true
    ballposition = ballposition + ballvelocity;
    set(ball, 'Position', [ballposition - ballradius, ballradius + (ballradius * 0.2), ballradius*2]);
    pause(0.1);
end

 %check if someone scored by checking whether the ball is outside the
    %bounds of the other paddle 
    if ~inbounds_paddleAx && ~inbounds_paddleAy && ballvelocity(1) < 0
        score_playerB = score_playerB + 1; 
        ballposition = ballposition_start; 
    elseif ~inbounds_paddleBx && ~inbounds_paddleBy && ballvelocity(1) > 0 
        score_playerA = score_playerA + 1; 
        ballposition = ballposition_start; 
    end 

if score_playerA > score_playerB && score_playerA >= 5 
    disp('game is over! Player A wins');  
    pause(1); 
    ballposition = ballposition_start; 
    score_playerA = 0; 
    score_playerB = 0;
    
end 
if score_playerB > score_playerA && score_playerB >= 5 
    disp('game is over! Player B wins'); 
    pause(1);
    ballposition = ballposition_start; 
    score_playerA = 0; 
    score_playerB = 0;
end  
drawnow; 
pause(0.1); 
 

           % Callback function for key press
   function keyDown(~, event)
   global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;

       switch event.Key
           case 'uparrow'
               upArrowPressed = true;
           case 'downarrow'
               downArrowPressed = true;
           case 'w'
               wKeyPressed = true;
           case 's'
               sKeyPressed = true;
       end
        
   end

   % Callback function for key release
   function keyUp(~, event)
   global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;

       switch event.Key
           case 'uparrow'
               upArrowPressed = false;
           case 'downarrow'
               downArrowPressed = false;
           case 'w'
               wKeyPressed = false;
           case 's'
               sKeyPressed = false;
       end
              
   end
