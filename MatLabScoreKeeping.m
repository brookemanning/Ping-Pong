%initialize variable
ballposition_start = [7, 15];
ballposition = []; %ball starts in the middle of the board
ballvelocity=[0.01,0.01];
ballradius = 0.5;
boardwidth = 15;
boardheight = 30;

paddleAposition = [1, 4, 1, 3]; %x,y,width,height
paddleBposition = [8, 4, 1, 3];

score_playerA = 0;  
score_playerB = 0; 

% Visualize the board
rectangle('Position', [0, 0, boardwidth, boardheight], 'EdgeColor', 'black', 'LineWidth', 2);

% Visualize the paddles
rectangle('Position', paddleAposition, 'FaceColor', 'blue');
rectangle('Position', paddleBposition, 'FaceColor', 'red');

% Create ball 
ball = rectangle('Position', [ballposition_start(1)-ballradius, ballposition_start(2)-ballradius, 2*ballradius, 2*ballradius], 'Curvature', [1, 1], 'FaceColor', 'green');

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
                   
    end

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
drawnow; 
pause(0.1); 
end 


