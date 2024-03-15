% Create a figure
figure;

screen_width = 800; % Width of the screen
screen_height = 600; % Height of the screen

paddlewidth = 0.015;
paddleheight = 0.15;

% Player 1 Paddle 
paddleA_position = [0, 0.5 - (paddleheight/2), paddlewidth, paddleheight];
% Player 2 Paddle 
paddleB_position = [1 - paddlewidth, 0.5 - (paddleheight/2), paddlewidth, paddleheight];

paddleA = rectangle('Position', paddleA_position, 'FaceColor', 'red'); 
paddleB = rectangle('Position', paddleB_position, 'FaceColor', 'blue');

% Set up KeyPressFcn/KeyReleaseFcn callback function for the current figure
set(gcf, 'KeyPressFcn', @keyDown);
set(gcf, 'KeyReleaseFcn', @keyUp);

% Initialize variables to track key presses
global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;
upArrowPressed = false; 
downArrowPressed = false; 
wKeyPressed = false; 
sKeyPressed = false;

% Infinite loop for updating paddle movement
while true 
    % Check and update paddle movement based on key presses
    if wKeyPressed
        paddleA_position(2) = min(paddleA_position(2) + 0.01, 1 - paddleheight); 
        set(paddleA, 'Position', paddleA_position); 
    elseif sKeyPressed
        paddleA_position(2) = max(paddleA_position(2) - 0.01, 0); 
        set(paddleA, 'Position', paddleA_position); 
    end 

    if downArrowPressed
        paddleB_position(2) = max(paddleB_position(2) - 0.01, 0);
        set(paddleB, 'Position', paddleB_position); 
    elseif upArrowPressed
        paddleB_position(2) = min(paddleB_position(2) + 0.01, 1 - paddleheight); 
        set(paddleB, 'Position', paddleB_position);
    end 
    
    % Pause to avoid high CPU usage
    pause(0.05);
end 

% Callback function for key press
function keyDown(~, event)
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