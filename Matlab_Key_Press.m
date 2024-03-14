% Create a figure
figure;

screen_width = 800; % Width of the screen
screen_height = 600; % Height of the screen
axes('Position', [0, 0, 1, 1], 'XLim', [0, 1], 'YLim', [0, 1], 'Visible', 'on');

paddlewidth = 0.015;
paddleheight = 0.10

% Player 1 Paddle 
paddleAposition = [0, 0.5 - (paddleheight/2), paddlewidth, paddleheight]
% Player 2 Paddle 
paddleBposition = [1 - paddlewidth, 0.5 - (paddleheight/2), paddlewidth, paddleheight]

paddleA = rectangle('Position', paddleAposition, 'FaceColor', 'red'); 
paddleB = rectangle('Position', paddleBposition, 'FaceColor', 'blue');

% define variables in global function 
global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;

% Set up KeyPressFcn/KeyReleaseFcn callback function
set(gcf, 'KeyPressFcn', @keyDown);
set(gcf, 'KeyReleaseFcn', @keyUp);

% initializing variables for key press 
upArrowPressed = false; 
downArrowPressed = false; 
wKeyPressed = false; 
sKeyPressed = false;

    % Updating movement of paddles with while loop and if statements 
    
    while true 
        if wKeyPressed
            paddleAposition(2) = min(1-paddleheight, paddleAposition(2) + 0.01); 
            set(paddleA, 'Position', paddleAposition); 
        elseif sKeyPressed
            paddleAposition(2) = max(0, paddleAposition(2) - 0.01); 
            set(paddleA, 'Position', paddleAposition);   
        end 

        if upArrowPressed
            paddleBposition(2) = min(1-paddleheight, paddleBposition(2) + 0.01); 
            set(paddleB, 'Position', paddleBposition);
        elseif downArrowPressed
            paddleBposition(2) = max(0, paddleBposition(2) - 0.01);
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
