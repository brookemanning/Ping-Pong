% in this version, the paddles move, ball moves and bounces, and score
% correctly updates AND has 3 difficulties

%potential adding callback function for level selector: yuki 

%whole ping pong starts HERE ------------------
function pingpongsetup()


%mode selector starts HERE ------------------
    tablecolor = uint8([42,54,74]);
    board = figure('Color',tablecolor,'Position',[150,200,1200,750]); 

    ax = axes('Parent',board,'Position',[0,0,1,1],'Color','none');
    xlim([0,1]);
    ylim([0,1]);
    axis off;

    %make option title: game level
    text(ax,0.5,0.8,'game level','Color','white','FontSize',36,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');

    %create options: easy, medium, hard
    easy_mode = text(ax,0.5,0.58,'easy','Color','white','FontSize',30,'HorizontalAlignment','center','VerticalAlignment','middle');
    medium_mode = text(ax,0.5,0.48,'medium','Color','white','FontSize',30,'HorizontalAlignment','center','VerticalAlignment','middle');
    hard_mode = text(ax,0.5,0.38,'hard','Color','white','FontSize',30,'HorizontalAlignment','center','VerticalAlignment','middle');

    %set callback function for easy mode
    set(easy_mode,'ButtonDownFcn',@starteasy)
    %callback function for easy mode
    function starteasy(~,~)
        close(board);
        easymode_pingpong();
    end

    %set callback function for medium mode
    set(medium_mode,'ButtonDownFcn',@startmedium)
    %callback function for medium mode
    function startmedium(~,~)
        close(board);
        mediummode_pingpong();
    end

    %set callback function for hard mode
    set(hard_mode,'ButtonDownFcn',@starthard)
    %callback function for hard mode
    function starthard(~,~)
        close(board);
        hardmode_pingpong();
    end
%mode selector ends HERE ------------------

%EASY mode ping pong starts HERE ------------------
    function easymode_pingpong()
    %-- CREATING GAMEBOARD + VISUALS --
    % creating background
        tablecolor = uint8([42,54,74]);
        board = figure('Color',tablecolor,'Position',[150,200,1200,750]); 
        fig_position = get(board, 'Position'); %vector for board x, y, wid, h
        boardwidth = fig_position(3);
        boardheight = fig_position(4);
    
    % create axes for the board
        ax = axes('Parent',board,'Position',[0,0,1,1],'Color','none');
        xlim([0,1]);
        ylim([0,1]);
        axis off;
    
    % create line in center
        x_center = [0.5, 0.5]; %x coord for ends of center line
        y_center = [0, 1]; %y coords for ends of center line
        line(x_center,y_center,'Color','white','LineStyle','--','LineWidth',6);
    
    % creating paddles
        paddlewidth = 0.015;
        paddleheight = 0.15;
    % initial paddle position
        paddleAposition = [0,0.5 - (paddleheight/2),paddlewidth,paddleheight];
        paddleBposition = [1-paddlewidth,0.5 - (paddleheight/2),paddlewidth,paddleheight];
    % create rectangular paddles
        paddleA = rectangle('Parent',ax,'Position',paddleAposition,'EdgeColor','white','FaceColor','white');
        paddleB = rectangle('Parent',ax,'Position',paddleBposition,'EdgeColor','white','FaceColor','white');
    
    % creating the ball
    % initial ball position
        ballradius = 0.02;
        ballposition_start = [0.5 + ballradius/2,0.5];
        ballposition = ballposition_start; 
        ballcolor = uint8([255,193,59]);
        ball = rectangle('Parent',ax,'Position',[ballposition_start - ballradius,ballradius + (ballradius * 0.2),ballradius*2],'Curvature',1,'EdgeColor','none','FaceColor',ballcolor);
        ballvelocity = [0.015,0.015];
    
    % creating the scoreboard
        score_playerA = 0;
        score_playerB = 0;
        strScoreA = num2str(score_playerA);
        strScoreB = num2str(score_playerB);
        paddleA_score = text(ax,0.45,0.1,strScoreA,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');
        paddleB_score = text(ax,0.55,0.1,strScoreB,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');

    %-- INITIALIZE ARROW KEY STATES --

    % define variables in global function
        global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;

        upArrowPressed = false;
        downArrowPressed = false;
        wKeyPressed = false;
        sKeyPressed = false;

    % set up key press/key release
        set(gcf, 'KeyPressFcn', @keyDown);
        set(gcf, 'KeyReleaseFcn', @keyUp);

   % game parameters: 
        game_over = false; 
        winning_score = 5;

    %-- WHILE LOOP FOR KEY PRESS/PADDLE MOVEMENT, BALL MOVEMENT, AND
    %SCORING --

        while ~game_over

            % handle ball movement
            ballposition = ballposition + ballvelocity;
            set(ball, 'Position', [ballposition - ballradius, ballradius + (ballradius * 0.2), ballradius*2]);
            pause(0.1);
       

        % checking collisions
            % edges of the board
            if ballposition(1) - ballradius <= 0|| ballposition(1) + ballradius >= boardwidth %left/right
                % added 3/18 to make ball return to center when it hits left side, instead of stopping
                ballposition = ballposition_start;
                ballvelocity(1) = -ballvelocity(1); %ballvelocity = [0.015,0.015];
            elseif ballposition(2) - ballradius <=0 || ballposition(2) + ballradius >= 1 %ceiling/bottom
                ballvelocity(2) = -ballvelocity(2); %top/bottom
            end

            % check collision with paddle A
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
        
        % set speed of paddles 
        speedLevel = 0.03;

        % conditionals for the movement of paddles upon key press 
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
   

    %-- SCORING -- 
    % changed condition to 2*radius b/c i thought it wasn't registering
    % properly - was 0 before
        if ballposition(1) <= ballradius*2 && ballvelocity(1) < 0 % if the ball has crossed the left side of the board and is still moving left
        % if the y coordinate of the ball is less than the y coordinate of the paddle 
        % or the y coordinate of the ball is greater than the bottom edge of the paddle 
        % or the x coordinate of the ball is less than the paddle: 
        if ballposition(2) < paddleBposition(2) || ballposition(2) > paddleBposition(2) + paddleheight || ballposition(1) + ballradius < paddleBposition(1)
        score_playerB = score_playerB + 1; 
            update_score(); 
            ballposition = ballposition_start; 
            pause(1); 
        end 
    % if the ball has crossed the right side of the board and is still moving
    % right: 
    elseif ballposition(1) >= 1 && ballvelocity(1) > 0
        if ballposition(2) < paddleAposition(2) || ballposition(2) > paddleAposition(2) + paddleheight || ballposition(1) - ballradius > paddleAposition(1) + paddlewidth
            score_playerA = score_playerA + 1; 
            update_score();
            ballposition = ballposition_start; 
            pause(1); 
        end 
    end 
            
    if score_playerB == winning_score || score_playerA == winning_score
        game_over = true; 
        if score_playerA == winning_score
            game_over_message = 'Game is over! Player A wins'; 
        else 
            game_over_message = 'Game is over! Player B wins';
        end 

    text(ax, 0.5, 0.5, game_over_message, 'Color', 'White', 'FontSize', 30, 'HorizontalAlignment','center');
    ballposition = ballposition_start; 
    score_playerA = 0; 
    score_playerB = 0;

    end
    end
    
    %-- CALLBACK FUNCTIONS --
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
 
    function update_score()
        set(paddleA_score, 'String', num2str(score_playerA));
        set(paddleB_score, 'String', num2str(score_playerB));
    end

    %create replay 
    replay = text(ax,0.5,0.3,'replay','Color','white','FontSize',27,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
    set(replay,'ButtonDownFcn',@replaypong);
    %callback function to start a new game of easy ping pong
    function replaypong(~, ~)
        close(board);
        pingpongsetup();
    end

    end
%EASY mode ping pong ends HERE ------------------



%MEDIUM mode ping pong starts HERE ------------------
    function mediummode_pingpong()
    %-- CREATING GAMEBOARD + VISUALS --
    % creating background
        tablecolor = uint8([42,54,74]);
        board = figure('Color',tablecolor,'Position',[150,200,1200,750]); 
        fig_position = get(board, 'Position'); %vector for board x, y, wid, h
        boardwidth = fig_position(3);
        boardheight = fig_position(4);
    
    % create axes for the board
        ax = axes('Parent',board,'Position',[0,0,1,1],'Color','none');
        xlim([0,1]);
        ylim([0,1]);
        axis off;
    
    % create line in center
        x_center = [0.5, 0.5]; %x coord for ends of center line
        y_center = [0, 1]; %y coords for ends of center line
        line(x_center,y_center,'Color','white','LineStyle','--','LineWidth',6);
    
    % creating paddles
        paddlewidth = 0.015;
        paddleheight = 0.15;
    % initial paddle position
        paddleAposition = [0,0.5 - (paddleheight/2),paddlewidth,paddleheight];
        paddleBposition = [1-paddlewidth,0.5 - (paddleheight/2),paddlewidth,paddleheight];
    % create rectangular paddles
        paddleA = rectangle('Parent',ax,'Position',paddleAposition,'EdgeColor','white','FaceColor','white');
        paddleB = rectangle('Parent',ax,'Position',paddleBposition,'EdgeColor','white','FaceColor','white');
    
    % creating the ball
    % initial ball position
        ballradius = 0.02;
        ballposition_start = [0.5 + ballradius/2,0.5];
        ballposition = ballposition_start; 
        ballcolor = uint8([255,193,59]);
        ball = rectangle('Parent',ax,'Position',[ballposition_start - ballradius,ballradius + (ballradius * 0.2),ballradius*2],'Curvature',1,'EdgeColor','none','FaceColor',ballcolor);
        ballvelocity = [0.02,0.02];
    
    % creating the scoreboard
        score_playerA = 0;
        score_playerB = 0;
        strScoreA = num2str(score_playerA);
        strScoreB = num2str(score_playerB);
        paddleA_score = text(ax,0.45,0.1,strScoreA,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');
        paddleB_score = text(ax,0.55,0.1,strScoreB,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');

    %-- INITIALIZE ARROW KEY STATES --

    % define variables in global function
        global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;

        upArrowPressed = false;
        downArrowPressed = false;
        wKeyPressed = false;
        sKeyPressed = false;

    % set up key press/key release
        set(gcf, 'KeyPressFcn', @keyDown);
        set(gcf, 'KeyReleaseFcn', @keyUp);

   % game parameters: 
        game_over = false; 
        winning_score = 5;

    %-- WHILE LOOP FOR KEY PRESS/PADDLE MOVEMENT, BALL MOVEMENT, AND
    %SCORING --

        while ~game_over

            % handle ball movement
            ballposition = ballposition + ballvelocity;
            set(ball, 'Position', [ballposition - ballradius, ballradius + (ballradius * 0.2), ballradius*2]);
            pause(0.1);
       

        % checking collisions
            % edges of the board
            if ballposition(1) - ballradius <= 0|| ballposition(1) + ballradius >= boardwidth %left/right
                % added 3/18 to make ball return to center when it hits left side, instead of stopping
                ballposition = ballposition_start;
                ballvelocity(1) = -ballvelocity(1); %ballvelocity = [0.015,0.015];
            elseif ballposition(2) - ballradius <=0 || ballposition(2) + ballradius >= 1 %ceiling/bottom
                ballvelocity(2) = -ballvelocity(2); %top/bottom
            end

            % check collision with paddle A
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
        
        % set speed of paddles 
        speedLevel = 0.03;

        % conditionals for the movement of paddles upon key press 
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
   

    %-- SCORING -- 
    % changed condition to 2*radius b/c i thought it wasn't registering
    % properly - was 0 before
        if ballposition(1) <= ballradius*2 && ballvelocity(1) < 0 % if the ball has crossed the left side of the board and is still moving left
        % if the y coordinate of the ball is less than the y coordinate of the paddle 
        % or the y coordinate of the ball is greater than the bottom edge of the paddle 
        % or the x coordinate of the ball is less than the paddle: 
        if ballposition(2) < paddleBposition(2) || ballposition(2) > paddleBposition(2) + paddleheight || ballposition(1) + ballradius < paddleBposition(1)
        score_playerB = score_playerB + 1; 
            update_score(); 
            ballposition = ballposition_start; 
            pause(1); 
        end 
    % if the ball has crossed the right side of the board and is still moving
    % right: 
    elseif ballposition(1) >= 1 && ballvelocity(1) > 0
        if ballposition(2) < paddleAposition(2) || ballposition(2) > paddleAposition(2) + paddleheight || ballposition(1) - ballradius > paddleAposition(1) + paddlewidth
            score_playerA = score_playerA + 1; 
            update_score();
            ballposition = ballposition_start; 
            pause(1); 
        end 
    end 
            
    if score_playerB == winning_score || score_playerA == winning_score
        game_over = true; 
        if score_playerA == winning_score
            game_over_message = 'Game is over! Player A wins'; 
        else 
            game_over_message = 'Game is over! Player B wins';
        end 

    text(ax, 0.5, 0.5, game_over_message, 'Color', 'White', 'FontSize', 30, 'HorizontalAlignment','center');
    ballposition = ballposition_start; 
    score_playerA = 0; 
    score_playerB = 0;

    end
    end
    
    %-- CALLBACK FUNCTIONS --
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
 
    function update_score()
        set(paddleA_score, 'String', num2str(score_playerA));
        set(paddleB_score, 'String', num2str(score_playerB));
    end

    %create replay 
    replay = text(ax,0.5,0.3,'replay','Color','white','FontSize',27,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
    set(replay,'ButtonDownFcn',@replaypong);
    %callback function to start a new game of easy ping pong
    function replaypong(~, ~)
        close(board);
        pingpongsetup();
    end

    end
%MEDIUM mode ping pong ends HERE ------------------



%HARD mode ping pong starts HERE ------------------
    function hardmode_pingpong()
    %-- CREATING GAMEBOARD + VISUALS --
    % creating background
        tablecolor = uint8([42,54,74]);
        board = figure('Color',tablecolor,'Position',[150,200,1200,750]); 
        fig_position = get(board, 'Position'); %vector for board x, y, wid, h
        boardwidth = fig_position(3);
        boardheight = fig_position(4);
    
    % create axes for the board
        ax = axes('Parent',board,'Position',[0,0,1,1],'Color','none');
        xlim([0,1]);
        ylim([0,1]);
        axis off;
    
    % create line in center
        x_center = [0.5, 0.5]; %x coord for ends of center line
        y_center = [0, 1]; %y coords for ends of center line
        line(x_center,y_center,'Color','white','LineStyle','--','LineWidth',6);
    
    % creating paddles
        paddlewidth = 0.015;
        paddleheight = 0.15;
    % initial paddle position
        paddleAposition = [0,0.5 - (paddleheight/2),paddlewidth,paddleheight];
        paddleBposition = [1-paddlewidth,0.5 - (paddleheight/2),paddlewidth,paddleheight];
    % create rectangular paddles
        paddleA = rectangle('Parent',ax,'Position',paddleAposition,'EdgeColor','white','FaceColor','white');
        paddleB = rectangle('Parent',ax,'Position',paddleBposition,'EdgeColor','white','FaceColor','white');
    
    % creating the ball
    % initial ball position
        ballradius = 0.02;
        ballposition_start = [0.5 + ballradius/2,0.5];
        ballposition = ballposition_start; 
        ballcolor = uint8([255,193,59]);
        ball = rectangle('Parent',ax,'Position',[ballposition_start - ballradius,ballradius + (ballradius * 0.2),ballradius*2],'Curvature',1,'EdgeColor','none','FaceColor',ballcolor);
        ballvelocity = [0.04,0.04];
    
    % creating the scoreboard
        score_playerA = 0;
        score_playerB = 0;
        strScoreA = num2str(score_playerA);
        strScoreB = num2str(score_playerB);
        paddleA_score = text(ax,0.45,0.1,strScoreA,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');
        paddleB_score = text(ax,0.55,0.1,strScoreB,'Color',[0.7,0.7,0.7],'FontSize',30,'HorizontalAlignment','center');

    %-- INITIALIZE ARROW KEY STATES --

    % define variables in global function
        global wKeyPressed sKeyPressed upArrowPressed downArrowPressed;

        upArrowPressed = false;
        downArrowPressed = false;
        wKeyPressed = false;
        sKeyPressed = false;

    % set up key press/key release
        set(gcf, 'KeyPressFcn', @keyDown);
        set(gcf, 'KeyReleaseFcn', @keyUp);

   % game parameters: 
        game_over = false; 
        winning_score = 5;

    %-- WHILE LOOP FOR KEY PRESS/PADDLE MOVEMENT, BALL MOVEMENT, AND
    %SCORING --

        while ~game_over

            % handle ball movement
            ballposition = ballposition + ballvelocity;
            set(ball, 'Position', [ballposition - ballradius, ballradius + (ballradius * 0.2), ballradius*2]);
            pause(0.1);
       

        % checking collisions
            % edges of the board
            if ballposition(1) - ballradius <= 0|| ballposition(1) + ballradius >= boardwidth %left/right
                % added 3/18 to make ball return to center when it hits left side, instead of stopping
                ballposition = ballposition_start;
                ballvelocity(1) = -ballvelocity(1); %ballvelocity = [0.015,0.015];
            elseif ballposition(2) - ballradius <=0 || ballposition(2) + ballradius >= 1 %ceiling/bottom
                ballvelocity(2) = -ballvelocity(2); %top/bottom
            end

            % check collision with paddle A
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
        
        % set speed of paddles 
        speedLevel = 0.03;

        % conditionals for the movement of paddles upon key press 
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
   

    %-- SCORING -- 
    % changed condition to 2*radius b/c i thought it wasn't registering
    % properly - was 0 before
        if ballposition(1) <= ballradius*2 && ballvelocity(1) < 0 % if the ball has crossed the left side of the board and is still moving left
        % if the y coordinate of the ball is less than the y coordinate of the paddle 
        % or the y coordinate of the ball is greater than the bottom edge of the paddle 
        % or the x coordinate of the ball is less than the paddle: 
        if ballposition(2) < paddleBposition(2) || ballposition(2) > paddleBposition(2) + paddleheight || ballposition(1) + ballradius < paddleBposition(1)
        score_playerB = score_playerB + 1; 
            update_score(); 
            ballposition = ballposition_start; 
            pause(1); 
        end 
    % if the ball has crossed the right side of the board and is still moving
    % right: 
    elseif ballposition(1) >= 1 && ballvelocity(1) > 0
        if ballposition(2) < paddleAposition(2) || ballposition(2) > paddleAposition(2) + paddleheight || ballposition(1) - ballradius > paddleAposition(1) + paddlewidth
            score_playerA = score_playerA + 1; 
            update_score();
            ballposition = ballposition_start; 
            pause(1); 
        end 
    end 
            
    if score_playerB == winning_score || score_playerA == winning_score
        game_over = true; 
        if score_playerA == winning_score
            game_over_message = 'Game is over! Player A wins'; 
        else 
            game_over_message = 'Game is over! Player B wins';
        end 

    text(ax, 0.5, 0.5, game_over_message, 'Color', 'White', 'FontSize', 30, 'HorizontalAlignment','center');
    ballposition = ballposition_start; 
    score_playerA = 0; 
    score_playerB = 0;

    end
    end
    
    %-- CALLBACK FUNCTIONS --
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
 
    function update_score()
        set(paddleA_score, 'String', num2str(score_playerA));
        set(paddleB_score, 'String', num2str(score_playerB));
    end

    %create replay 
    replay = text(ax,0.5,0.3,'replay','Color','white','FontSize',27,'HorizontalAlignment','center','VerticalAlignment','middle','FontWeight','bold');
    set(replay,'ButtonDownFcn',@replaypong);
    %callback function to start a new game of easy ping pong
    function replaypong(~, ~)
        close(board);
        pingpongsetup();
    end

    end
%HARD mode ping pong ends HERE ------------------
    
%end of whole ping pong
end