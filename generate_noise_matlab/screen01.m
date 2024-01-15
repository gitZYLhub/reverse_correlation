clc
clear
close all

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
        width_cm = 5;% 70.71;%in cm
        height_cm = 5; %39.78;%in cm
    else
        windowWidth = 512;%pixel
        width_cm = 5;%in cm
        windowHeight = 512;%pixel
        height_cm = 5;%in cm
    end

    degree2pixel = 1/(57/visual_distance)*windowHeight/height_cm;%1 degree have n pixels.

    before_block=30;

    % Interstimulus interval and stim time
    ISI = 3;  % isi time, second
    stim_t = 1; % stimuli time. second

    window = Screen('OpenWindow', screenNumber, 0);

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

    for i = 1:5
        

    % Convert grating to grayscale pixel values and window it
    grating = uint8((grating + 1) / 2 * 255);


    % Convert to Psychtoolbox texture
    gratingTexture = Screen('MakeTexture', window, grating);

    % Draw the grating texture to the screen
    Screen('DrawTexture', window, gratingTexture);
    Screen('FillRect', window, black, squareBlock); % Display black square
    Screen('Flip', window);

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


function image = generateNoise(img_size, T)

img_size = 512;
T = 256;

scales = [1, 2, 4, 8, 16];
scalesnum = size(scales, 2);
images = zeros(scalesnum, img_size, img_size);
for i = 1:scalesnum
    scale = scales(i);
    for m = 1:scale
        for n = 1:scale
            R = rand(12,1);
            img_size_1 = img_size/scale;
            T_1 = T/scale;
            G = generateMultiSinusoid(img_size_1, T_1, R);
            images(i, (m-1)*img_size_1+1:m*img_size_1, (n-1)*img_size_1+1:n*img_size_1) = G;
        end
    end
end
image = squeeze(sum(images, 1))/scalesnum;
image = image - min(min(image));
image = image/max(max(image));
% imshow(image);

end


function G = generateMultiSinusoid(img_size, T, R)

A = zeros(12, img_size, img_size);
for i_2 = 1:6
    A_temp = generateSingleSinusoid(img_size, 30*(i_2-1), 0, T);
    A(i_2,:,:) = R(i_2) * ( A_temp - 0.5 ) + 0.5;
end
for i_2 = 7:12
    A_temp = generateSingleSinusoid(img_size, 30*(i_2-1), pi/2, T);
    A(i_2,:,:) = R(i_2) * ( A_temp - 0.5 ) + 0.5;
end
G = squeeze(sum(A,1))/12;

end


function G = generateSingleSinusoid(img_size, angle, phase, T)

G = zeros(img_size);
angle = deg2rad(angle);
direction = [cos(angle), -sin(angle)];

for i_1 = 1:img_size
    for j_1 = 1:img_size
        x = i_1*cos(angle) - j_1*sin(angle);
        G(i_1,j_1) = 0.5+0.5*sin(x*2*pi/T + phase);
    end
end

end