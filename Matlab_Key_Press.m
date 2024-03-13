% Create a figure
figure;

screen_width = 800; % Width of the screen
screen_height = 600; % Height of the screen


paddlewidth = 0.015
paddleheight = 0.15

% Player 1 Paddle 
paddleA_position = [0, 0.5 - (paddleheight/2), paddlewidth, paddleheight]
% Player 2 Paddle 
paddleB_position = [1 - paddlewidth, 0.5 - (paddleheight/2), paddlewidth, paddleheight]

paddleA = rectangle('Position', paddleA_position, 'FaceColor', 'red'); 
paddleB = rectangle('Position', paddleB_position, 'FaceColor', 'blue');

global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;


% Set up KeyPressFcn/KeyReleaseFcn callback function
set(gcf, 'KeyPressFcn', @keyDown);
set(gcf, 'KeyReleaseFcn', @keyUp);

% variables for key press 
upArrowPressed = false; 
downArrowPressed = false; 
wKeyPressed = false; 
sKeyPressed = false;

    % Updating movement — updated by storing code inside infinite loop im
    % showinside
    
    while true 
        if wKeyPressed
            paddleA_position.Position(2) = paddleA_position.Position(2) + 0.05; 
            set(paddleA, 'Position', paddleA_position); 
        elseif sKeyPressed
            paddleA_position.Position(2) = paddleA_position.Position(2) - 0.05; 
            set(paddleA, 'Position', paddleA_position); 
        end 

        if downArrowPressed
            paddleB_position.Position(2) = paddleB_position.Position(2) - 0.05;
            set(paddleB, 'Position', paddleB_position); 
        elseif upArrowPressed
            paddleB_position.Position(2) = paddleB_position.Position(2) + 0.05; 
            set(paddleB, 'Position', paddleB_position);
        end
      pause(0.01); 
    end 

    % callback for key press 
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
