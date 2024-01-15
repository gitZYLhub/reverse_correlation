%230627 jerry plaid stimuli
%230627 hengma modified
%230712 jerry add blank stimulus  (last id)
%230722 only plaid90 and grating and blank, 17conditions
%230805 add rand seed generater
%231014 only grating

clc;clear
PsychStartup
% Requires Psychtoolbox installed
Screen('Preference', 'SkipSyncTests', 2);

%stimulus monitor para
visual_distance = 5;  %in cm
projection_screen = 0; %if you use projection_screen, you may need set its parameter by hand. 1 still has some problems


try
    % Open a fullscreen, black window on the main screen
    screenNumber = max(Screen('Screens'));

    % Gray and white color
    gray = [127 127 127];
    white = [255 255 255];
    black = [0 0 0];

    if projection_screen == 0
        [windowWidth, windowHeight] = Screen('WindowSize', screenNumber);
        width_cm = 15.5;% 70.71;%in cm
        height_cm = 8.7; %39.78;%in cm
    else
        windowWidth = 1920;%pixel
        width_cm = 47.7;%in cm
        windowHeight = 1080;%pixel
        height_cm = 26.8;%in cm
    end

    degree2pixel = 1/(57/visual_distance)*windowHeight/height_cm;%1 degree have n pixels.
    dir_n = 12;
    ntrials = 10;% repeats for one condition
    % Generate sine wave grating
    SF=0.02;
    freq = SF/degree2pixel; % frequency of sine wave,i.e., SF
    driftSpeed = 2; % phase change per second, increase this to make gratings move faster,i.e., TF
    before_block=60;

    % Interstimulus interval and stim time
    ISI = 3;  % isi time, second
    stim_t = 4; % stimuli time. second

    window = Screen('OpenWindow', screenNumber, 0);

    % Generate a grid of points
    [x, y] = meshgrid(-windowWidth/2:windowWidth/2 - 1, -windowHeight/2:windowHeight/2 - 1);
    
    % Convert pixel coordinates to physical coordinates (cm)
    x_cm = (x / windowWidth) * width_cm;
    y_cm = (y / windowHeight) * height_cm;
    
    % Assume the eye is at (0,0) in cm, compute z distance from eye to screen
    z_cm = visual_distance;  % Modify as needed
    
    % Transform to spherical coordinates
    [sphr_theta, sphr_phi, ~] = cart2sph(z_cm, x_cm, y_cm);
    
    % Rescale the Cartesian maps into dimensions of radians
    xmaxRad = max(sphr_theta(:));
    ymaxRad = max(sphr_phi(:));
    
    fx = xmaxRad / max(x_cm(:));
    fy = ymaxRad / max(y_cm(:));

    % Grating directions
    directions = 0:(360/dir_n):(360-360/dir_n);
    conditions = combvec(freq, driftSpeed, directions)';
    conditions = cat(1,conditions,[NaN,NaN,NaN]);

    % Randomize the order of conditions , save sequence and save alignment id with stimulus
    Ncondition = size(conditions,1);
    idwith_condition = [conditions,(1:Ncondition)'];
    save('idwith_condition_TF','idwith_condition'); %save id with stimuls condition

    useful_id=1:Ncondition;
    n_using_condition=numel(useful_id);

    stimmatrix = zeros(ntrials,n_using_condition);
    N_time = fix(clock);
    filename = strcat(num2str(N_time(4)),'-',num2str(N_time(5)),'-',num2str(N_time(6)),'_TF.txt');
    fid = fopen(filename, 'a');
    rng('shuffle')
    for i = 1:ntrials
             %   stimmatrix(i,:) = useful_id; %if you want fix sequence
     stimmatrix(i,:) = useful_id(randperm(n_using_condition)); %if you want random sequence
        fprintf(fid,'%2.0f\t',stimmatrix(i,:));
    end
    fclose(fid);
    stimmatrix_vec = reshape(stimmatrix',[1,ntrials*n_using_condition]);

    % Define the square block size and position
    blockSize = windowWidth / 20;
    % squareBlock = [0, windowHeight - blockSize, blockSize, windowHeight];

    squareBlock = [windowWidth - blockSize, windowHeight - blockSize, windowWidth, windowHeight];

    % Display gray at the beginning
    %     tic
    Screen('FillRect', window, gray);
    Screen('FillRect', window, white, squareBlock); % Display white square
    Screen('Flip', window);
    WaitSecs(before_block);
    %     toc

    % Iterate over each condition
    for i = 1:numel(stimmatrix_vec)
	SF = conditions(stimmatrix_vec(i),1);
	TF = conditions(stimmatrix_vec(i),2);
	direction = conditions(stimmatrix_vec(i),3);

        if isnan(direction)
            startTime = GetSecs;
            while GetSecs - startTime < stim_t
                Screen('FillRect', window, gray);
                Screen('FillRect', window, black, squareBlock); % Display white square
                Screen('Flip', window);
            end
        else
            % Calculate direction for grating
            theta = deg2rad(direction);
            dx = cos(theta);
            dy = sin(theta);

            % Initial phase of sine wave
            phase = 0;

            % Get start time
            %         tic
            startTime = GetSecs;
            while GetSecs - startTime < stim_t % Each condition lasts for stim_t second
                % Generate grating with varying phase for both directions
                grating_cart = sin(SF * 2 * pi * (dx * x + dy * y) + phase);
                
                % Apply spherical correction via interpolation
                grating = interp2(x_cm .* fx, y_cm .* fy, grating_cart, sphr_theta, sphr_phi);
                
                % Convert grating to grayscale pixel values and window it
                grating = uint8((grating + 1) / 2 * 255);
                

                % Convert to Psychtoolbox texture
                gratingTexture = Screen('MakeTexture', window, grating);

                % Draw the grating texture to the screen
                Screen('DrawTexture', window, gratingTexture);
                Screen('FillRect', window, black, squareBlock); % Display black square
                Screen('Flip', window);

                % Advance the phase for the next frame based on the elapsed time
                phase = 2 * pi * TF * (GetSecs - startTime);

                % Close the current texture to avoid memory leak
                Screen('Close', gratingTexture);
            end

        end

        % Add gray screen during interstimulus interval
        Screen('FillRect', window, gray);
        Screen('FillRect', window, white, squareBlock); % Display white square
        Screen('Flip', window);
        %         toc
        %         tic
        WaitSecs(ISI);
        %         toc
    end

    % Close the screen
    Screen('CloseAll');

catch err
    % Close the screen in case of error
    Screen('CloseAll');
    rethrow(err);
end
