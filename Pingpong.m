function Pingpong()
    %CREATE GAMEBOARD
    %creating background
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
    paddleAposition = [0,0.5 - (paddleheight/2),paddlewidth,paddleheight];
    paddleBposition = [1-paddlewidth,0.5 - (paddleheight/2),paddlewidth,paddleheight];
    %create rectangular paddles
    paddleA = rectangle('Parent',ax,'Position',paddleAposition,'EdgeColor','white','FaceColor','white');
    paddleB = rectangle('Parent',ax,'Position',paddleBposition,'EdgeColor','white','FaceColor','white');
    
    %creating the ball
    % %initial ball position!
    ballradius = 0.02;
    ballposition = [0.5 + ballradius/2,0.5];
    ballcolor = uint8([255,193,59]);
    ball = rectangle('Parent',ax,'Position',[ballposition - ballradius,ballradius + (ballradius * 0.2),ballradius*2],'Curvature',1,'EdgeColor','none','FaceColor',ballcolor);
    ballvelocity = [0.01,0.01];
    
    %creating the scoreboard
    Score_PlayerA = 0;
    Score_PlayerB = 0;
    strScoreA = num2str(Score_PlayerA);
    strScoreB = num2str(Score_PlayerB);
    paddleA_score = text(ax,0.45,0.1,strScoreA,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');
    paddleB_score = text(ax,0.55,0.1,strScoreB,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');

    %INITIALIZE ARROW KEY STATES
    upArrowPressed = false;
    downArrowPressed = false;
    wKeyPressed = false;
    sKeyPressed = false;

    %SET UP KEY PRESS/KEY RELEASE
    set(gcf, 'KeyPressFcn', @keyDown);
    set(gcf, 'KeyReleaseFcn', @keyUp);

    % define variables in global function
    global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;

    while true
        %HANDLE BALL MOVEMENT
        ballposition = ballposition + ballvelocity;
        set(ball, 'Position', [ballposition - ballradius, ballradius + (ballradius * 0.2), ballradius*2]);
        pause(0.1);

        %CHECK COLLISIONS
        %edges of the board
        if ballposition(1) - ballradius<=0|| ballposition(1) + ballradius>= boardwidth %left/right
            ballvelocity = [0,0]; %left/right
        elseif ballposition(2) - ballradius<=0 || ballposition(2) + ballradius >= 1 %ceiling/bottom
            ballvelocity(2) = -ballvelocity(2); %top/bottom
        end

        %check collision with paddle A
        inbounds_paddleAx = (ballposition(1) - ballradius <= paddleAposition(1) + paddlewidth);
        inbounds_paddleAy = (ballposition(2) >= paddleAposition(2) && ballposition(2) <= paddleAposition(2) + paddleheight);

        if inbounds_paddleAx && inbounds_paddleAy
            ballvelocity(1) = -ballvelocity(1);
        end

        %check collision with paddle B
        inbounds_paddleBx = (ballposition(1) + ballradius >= paddleBposition(1));
        inbounds_paddleBy = (ballposition(2) >= paddleBposition(2) && ballposition(2) <= paddleBposition(2) + paddleheight);
        
        if inbounds_paddleBx && inbounds_paddleBy
           ballvelocity(1) = -ballvelocity(1);
        end
        
        speedLevel = 0.01;
        if wKeyPressed
            paddleAposition(2) = min(1-paddleheight, paddleAposition(2) + speedLevel);
            set(paddleA, 'Position', paddleAposition);
        elseif sKeyPressed
            paddleAposition(2)=max(0, paddleAposition(2) - speedLevel);
            set(paddleA, 'Position', paddleAposition);
        end
    
        if upArrowPressed
            paddleBposition(2) = min(1-paddleheight, paddleBposition(2) + speedLevel);
            set(paddleB, 'Position', paddleBposition);
              
        elseif downArrowPressed
            paddleBposition(2) = max(0, paddleBposition(2) - speedLevel);
            set(paddleB, 'Position', paddleBposition);
        end
              
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

end