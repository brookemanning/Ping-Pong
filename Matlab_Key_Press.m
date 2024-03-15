
% note: I used code from https://github.com/Seth-Joseph/Project/blob/main/pingPong.m
% to guide my work. Here is what I changed in order to make the code
% functional and add to Seth's work: 

% 1) created global variables upArrowPressed, downArrowPressed,
% wKeyPressed, sKeyPressed in order to make sure MATLAB recognized them. 
% I used these at the beginning of my code, as well as within the callback functions.

% 2) instead of using the 'get' function in order to update the position of
% the paddles, I used 'min' and 'max' in order to keep it within a X, Y,
% coordinate size of [1, 1], and properly adjust the y coordinate as using
% 'get' and 'set' alone did not work.

% 3) I created  'easy, 'medium,' and 'hard' settings for the game. In the 'easy' setting, 
% the paddles move faster, and in the 'hard' setting, the paddles move slower. 

%choice between easy or hard version 



% Create a figure
figure;

screen_width = 800; % Width of the screen
screen_height = 600; % Height of the screen

axes('Position', [0, 0, 1, 1], 'XLim', [0,1], 'YLim', [0,1], 'Visible', 'on');

paddlewidth = 0.015;
paddleheight = 0.10;

% Creating Player 1 Paddle
paddleAposition = [0, 0.5 - (paddleheight/2), paddlewidth, paddleheight];

% Creating Player 2 Paddle
paddleBposition = [1 - paddlewidth, 0.5 - (paddleheight/2), paddlewidth, paddleheight];

% Colors and positions of paddles 
paddleA = rectangle('Position', paddleAposition, 'FaceColor', 'red');
paddleB = rectangle('Position', paddleBposition, 'FaceColor', 'blue');

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

   % Updating movement of paddles with while loop and if statements
  



