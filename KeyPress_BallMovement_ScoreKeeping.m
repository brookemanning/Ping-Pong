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
paddleAposition = [0,0.5 - (paddleheight/2),paddlewidth,paddleheight];
paddleBposition = [1-paddlewidth,0.5 - (paddleheight/2),paddlewidth,paddleheight];
%create rectangular paddles
paddleA = rectangle(ax,'Position',paddleAposition,'EdgeColor','white','FaceColor','white');
paddleB = rectangle(ax,'Position',paddleBposition,'EdgeColor','white','FaceColor','white');

%creating the ball
% %initial ball position!
ballradius = 0.02;
ballposition = [0.5 + ballradius/2,0.5];
ballcolor = uint8([255,193,59]);
ball = rectangle(ax,'Position',[ballposition - ballradius,ballradius + (ballradius * 0.2),ballradius*2],'Curvature',1,'EdgeColor','none','FaceColor',ballcolor);


%creating the scoreboard

%initialize variable
ballposition_start = [0.5, 0.5];
ballposition = []; %ball starts in the middle of the board
ballvelocity=[0.01,0.01];
ballradius = 0.5;

score_playerA = 0;  
score_playerB = 0; 


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

   
%keep ball moving

while true
    ballposition = ballposition_start + ballvelocity; %update ball position
    %pause(0.1) %control speed
    
    %CHECK FOR COLLISION WITH EDGES OF THE BAORD BUT NOT A PADDLE
    if ballposition(1) - ballradius<=0 || ballposition(1) + ballradius>= boardwidth
        %if the x value of the ball - its radius is less than or equal to 0, 
        % it has crossed the left wall of the board. OR if the x value of the 
        % ball + the ball radius is greater than or equal to the boardwith, it 
        % has crossed the right wall of the board
        ballvelocity = [0,0]; %stop the ball (round has ended, one player gets a point

    elseif ballposition(2) - ballradius<=0 || ballposition(2) + ballradius >= boardheight
        %if the y value of the ball - its radius is less than or equal to
        %0, it has hit the bottom of the board. If it is greater than or
        %equal to the board height, it has hit the top of the board
        ballvelocity(2) = -ballvelocity(2); %reverse y component of velocity to bounce off the ceiling/floor
    end 

    %CHECK FOR COLLISION WITH PADDLE A
    %check if the ball is within the x and y coordinates of paddle A 
    inbounds_paddleAx = (ballposition(1)>=paddleAposition(1) && ballposition(1) <= (paddleAposition(1)+paddleAposition(3)));
    inbounds_paddleAy = (ballposition(2)>=paddleAposition(2) && ballposition(2) <=(paddleAposition(2)+paddleAposition(4)));

    if inbounds_paddleAx && inbounds_paddleAy
        %bounce off the paddle
        ballvelocity(1) = -ballvelocity(1); 
        ballposition(1) = paddleAposition(1) + paddleAposition(3) + ballradius;
                   

    %CHECK FOR COLLISION WITH PADDLE B
    inbounds_paddleBx = (ballposition(1)>=paddleBposition(1) && ballposition(1) <= (paddleBposition(1)+paddleBposition(3)));
    inbounds_paddleBy = (ballposition(2)>=paddleBposition(2) && ballposition(2) <=(paddleBposition(2)+paddleBposition(4)));

    if inbounds_paddleBx && inbounds_paddleBy
        %bounce off the paddle
        ballvelocity(1) = -ballvelocity(1);
        ballposition(1) = paddleBposition(1) - ballradius; 
    end

     %update ball position to keep it moving 
    set(ball, 'Position', [ballposition(1) - ballradius, ballposition(2) - ballradius, 2*ballradius, 2*ballradius]);

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
    break; 
end 
if score_playerB > score_playerA && score_playerB >= 5 
    disp('game is over! Player B wins'); 
    pause(1);
    ballposition = ballposition_start; 
    score_playerA = 0; 
    score_playerB = 0;
        break; 
end 
end 
drawnow; 
pause(0.1); 
end 

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



 
