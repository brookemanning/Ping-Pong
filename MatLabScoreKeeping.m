
% define variables 

% initialize player scores 
Score_PlayerA = 0;  
Score_PlayerB = 0; 

% positions of paddles and balls
ballposition = [x, y]; %current position of the ball 
starting_ball_position = [x, y] 

% need to add these in 
ballposition_Awins = 
ballposition_Bwins = 
paddleA_position = [x, y]
paddleB_position = [x, y] 

% 'splitting the table in half 
Table_PlayerA = [Table, x, y, z] % i.e. half of table closer to player A 
Table_PlayerB = [x, y, z] % i.e. half of table closer to player B

% code for Player_A: 
while true 
    if ballposition == inbounds_paddleAx && ballposition == inbounds_paddleAy
        continue; 
    else 
        Score_PlayerB = Score_PlayerB + 1;
        ballposition = ballposition_Bwins; 
    end
% code for Player_B: 
while true 
    if ballposition == inbounds_paddleBx && ballposition == inbounds_paddleBy
        continue; 
    else 
        Score_PlayerA = Score_PlayerA + 1;
        ballposition = ballposition_Awins; 
    end

% Code for ending the game and displaying the winner 
if score_playerA > score_playerB && score_playerA >= 5 
    break; 
    disp('game is over! Player A wins');  
    pause(2); 
    ballposition = starting_ball_position; 
    Score_PlayerA = 0; 
    Score_PlayerB = 0;
if score_playerB > score_playerA && score_playerB >= 5 
    break; 
    disp('game is over! Player B wins'); 
    pause(2);
    ballposition = starting_ball_position; 
    Score_PlayerA = 0; 
    Score_PlayerB = 0;
end 
