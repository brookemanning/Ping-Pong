% define variables 

% initialize player scores 
Score_PlayerA = 0;  
Score_PlayerB = 0; 

% positions of paddles and balls
ballposition = [x, y]; %current position of the ball 
starting_ball_position = [x, y] 

% need to add these in 
paddleA_position = [x, y]
paddleB_position = [x, y] 

% code for Player_A: 
while true 
    if ballposition == inbounds_paddleAx && ballposition == inbounds_paddleAy
        continue; 
    else 
        Score_PlayerB = Score_PlayerB + 1;
        ballposition = ballposition_start; 
    end
% code for Player_B: 
while true 
    if ballposition == inbounds_paddleBx && ballposition == inbounds_paddleBy
        continue; 
    else 
        Score_PlayerA = Score_PlayerA + 1;
        ballposition = ballposition_start; 
    end

% Code for ending the game and displaying the winner 
if score_playerA > score_playerB && score_playerA >= 5 
    break; 
    disp('game is over! Player A wins');  
    pause(2); 
    ballposition = ballposition_start; 
    Score_PlayerA = 0; 
    Score_PlayerB = 0;
if score_playerB > score_playerA && score_playerB >= 5 
    break; 
    disp('game is over! Player B wins'); 
    pause(2);
    ballposition = ballposition_start; 
    Score_PlayerA = 0; 
    Score_PlayerB = 0;
end 
end
end 
end 
