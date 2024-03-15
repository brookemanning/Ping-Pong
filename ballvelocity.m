%initialize variable
ballposition = [1,6]; %ball starts in the middle of the board
ballvelocity=[0.5,0.5];
ballradius = 0.5;
boardwidth = 15;
boardheight = 30;
paddleAposition = [0, 25, 1, 5]; %x,y,width,height
paddleBposition = [14, 16, 1, 5];

% Visualize the board
rectangle('Position', [0, 0, boardwidth, boardheight], 'EdgeColor', 'black', 'LineWidth', 2);
hold on;

% Visualize the paddles
rectangle('Position', paddleAposition, 'FaceColor', 'blue');
rectangle('Position', paddleBposition, 'FaceColor', 'red');

% Create ball 
ball = rectangle('Position', [ballposition(1)-ballradius, ballposition(2)-ballradius, 2*ballradius, 2*ballradius], 'Curvature', [1, 1], 'FaceColor', 'green');

%keep ball moving
while true
    ballposition = ballposition + ballvelocity; %update ball position
    
    %update ball position in figure
    set(ball, 'Position', [ballposition(1)-ballradius, ballposition(2)-ballradius, 2*ballradius,2*ballradius]);
    
    pause(0.1) %control speed
    
    %CHECK FOR COLLISION WITH EDGES OF THE BAORD BUT NOT A PADDLE
    if ballposition(1) - ballradius<=0|| ballposition(1) + ballradius>= boardwidth
        %if the x value of the ball - its radius is less than or equal to 0, 
        % it has crossed the left wall of the board. OR if the x value of the 
        % ball + the ball radius is greater than or equal to the boardwith, it 
        % has crossed the right wall of the board
        ballvelocity = [0,0]; %stop the ball (round has ended, one player gets a point)
        delete(ball); %make the ball disappear because it has gone 'out of bounds'
        break %exit the loop because this round of the game has ended

    elseif ballposition(2) - ballradius<=0 || ballposition(2) + ballradius >= boardheight
        %if the y value of the ball - its radius is less than or equal to
        %0, it has hit the bottom of the board. If it is greater than or
        %equal to the board height, it has hit the top of the board
        ballvelocity(2)=-ballvelocity(2); %reverse y component of velocity to bounce off the ceiling/floor
    end

    %CHECK FOR COLLISION WITH PADDLE A
    %check if the ball is within the x and y coordinates of paddle A 
    inbounds_paddleAx = (ballposition(1)>=paddleAposition(1) && ballposition(1) <= (paddleAposition(1)+paddleAposition(3)));
    inbounds_paddleAy = (ballposition(2)>=paddleAposition(2) && ballposition(2) <=(paddleAposition(2)+paddleAposition(4)));

    if inbounds_paddleAx && inbounds_paddleAy
        %bounce off the paddle
        ballvelocity(1) = -ballvelocity(1); %reverse x component of velocity to make it bounce horizontally

        %calculate the center of paddle A
        %center_paddleA = (paddleAposition(4)/2) + paddleAposition(2); %height/2 + bottom y value

        %if ballposition(2) > center_paddleA
         %   ballvelocity(2) = abs(ballvelocity(2));
            %if it hits above the center of the paddle, it bounces off in
            %the upward direction (positive y component)
       %else
            %otherwise, reverse y velocity
          %  ballvelocity(2) = -abs(ballvelocity(2));
        %end
    end

    %CHECK FOR COLLISION WITH PADDLE B
    inbounds_paddleBx = (ballposition(1)>=paddleBposition(1) && ballposition(1) <= (paddleBposition(1)+paddleBposition(3)));
    inbounds_paddleBy = (ballposition(2)>=paddleBposition(2) && ballposition(2) <=(paddleBposition(2)+paddleBposition(4)));

    if inbounds_paddleBx && inbounds_paddleBy
        %bounce off the paddle
        ballvelocity(1) = -ballvelocity(1);
    end


end
