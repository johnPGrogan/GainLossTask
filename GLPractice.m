function GLPractice
% GLPractice
% The GainLoss task practice version. Requires PsychToolbox package.
% Data are not saved.
% 
% Written by John Grogan and Hanna Isotalus
% Based on the task reported in Pessiglione, M., Seymour, B., Flandin, G.,
% Dolan, R.J., & Frith, C.D. (2006). Dopamine-dependent prediction errors 
% underpin reward-seeking behaviour in humans. Nature, 442, (7106), 
% pp1042-1045.

rng('shuffle')%set random number generator seed to time/date
stim = importdata(sprintf('GLLearn.txt')); %%d.txt',VersNo)); 
% in stim 1 = gain; 2 = nothing; 3 = look;  4=loss
% stim column 1 = condition AB = 1; CD = 2; EF = 3 ; column 2 = outcome response 1; 
% column 3 = outcome response 2; column 4 = left /right 
% last column is zeros and will be overwritten by stimOrder

stim(:,5) = randperm(length(stim))';%randomise order
stimOrderLearn = stim(:,5);%store it here also
Screen('Preference', 'SkipSyncTests', 1);    
nTrials = 30;

%% instructions
instructions{1} = 'In each trial you have to choose between the two symbols displayed on the screen, to either side of the central cross. \n \n  \n  Your choice will be circled in red. \n \n - to choose the left symbol, press button 1 \n \n - to choose the right symbol, press button 5 \n \n \n \n Please press key 3 to continue \n';
instructions{2} = 'As an outcome of your choice you may \n \n \n  -get nothing \n \n -gain a coin \n \n  -lose a coin \n \n \n \n Please press key 3 to continue';
instructions{3} = 'The two symbols displayed on the same screen are not equivalent in terms of outcome: with one you are more likely to get nothing than the other. \n \n \n Each symbol has its own meaning, regardless of where and when it is displayed. \n \n \n  The aim of the game is to win as much money as possible. \n \n \n \n  Please press key 3 to continue';
instructions{4} = 'This is the beginning of the practice phase. \n \n \n  Use keys 1 and 5 to responsd \n \n \n Please press key 3 to begin';
endMessage = 'You have now finished the practice phase. \n \n \n \n Thank you. ';
trialMessage1 = '1';
trialMessage2 = '5';
   
%% define key 
KbName('UnifyKeyNames'); %otherwise different key codes on my laptop
oneResp = 49;% left key
threeResp = 51;% middle key
fiveResp = 53;% right key

isi = 0.5;%inter stimulus interval
%% get ready
    try    
        %% set up stuff
        screens=Screen('Screens');% Get screenNumber of stimulation display. 
        screenNumber=max(screens);% set the display screen
        HideCursor; % Hide the mouse cursor:
        black = BlackIndex(screenNumber); %colours
        white = WhiteIndex(screenNumber); 
        [w]=Screen('OpenWindow', screenNumber, black);
        priorityLevel=MaxPriority(w);% Set priority for script execution 
        Priority(priorityLevel);     % to realtime priority 
        Screen('TextSize', w, 36);
        Screen('BlendFunction', w, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);     
       %% get coordinates 
       [xScreen, yScreen]=Screen('WindowSize', w);
       yCenter = yScreen/2;
       xCenter = xScreen/2;
       imageSide = xScreen/5; 
       gap = xScreen/15;
       leftBR = xCenter + gap;
       rightBR = leftBR + imageSide; 
       rightBL = xCenter - gap;
       leftBL = rightBL - imageSide; % left border of left figure
       bottomBorder = yCenter + (imageSide/2);
       topBorder = bottomBorder - imageSide;
       leftLocation = [leftBL, topBorder, rightBL, bottomBorder];
       rightLocation = [leftBR, topBorder, rightBR, bottomBorder];
       height = yScreen-gap;
       leftText = leftBL + (imageSide/2);
       rightText = rightBR - (imageSide/2);
       topText = topBorder - gap;
       
       %dummy calls
        KbCheck;
        WaitSecs(0.1);
        GetSecs;
        
        %% Run instructions
        RestrictKeysForKbCheck(threeResp);%for instructions
        for i = 1:length(instructions) % depends on how many you use
            DrawFormattedText(w, instructions{i}, 'center', 'center', white, 40);
            Screen('Flip', w);% Update the display to show the instruction text:
            WaitSecs(0.3);%wait a tiny bit before...
            KbWait;%wait for button press, key 3
            WaitSecs(0.001);  
            KbWait([],1); % wait for buttons to be released
        end % end for instructions
         
        %% Run experiment
 
        %% fixation cross before trial loop starts 
        DrawFormattedText(w, '+', 'center', 'center', [255 0 0], 40);        
        Screen('Flip', w);% Update the display to show the instruction text:
        WaitSecs(isi)            
        
        %% load images

        for p = 1:6
            stimfilename = sprintf('\\GainLoss\\Stimuli\\Practice\\%.1d.bmp', p); 
            imdata{p} = imread(char(stimfilename)); % stores in a cell and works nicely. Remember to use {} when call, not ()
        end
        
        stimfilename20p = sprintf('\\GainLoss\\Stimuli\\20p.bmp'); 
        twentyP = imread(char(stimfilename20p));   
        stimfilenameredRing = sprintf('\\GainLoss\\Stimuli\\redRing.png'); 
        redRing = imread(char(stimfilenameredRing));   
   
        RestrictKeysForKbCheck([oneResp,fiveResp]);%only 1 and 5           
        %% loop through trials
        for k = 1:nTrials 
            %% set trial up
            Screen('TextSize', w, 36);
            trial = stimOrderLearn(k,1);%get trial number
            %load up stimulil
            if stim(trial, 1) == 1 % trial selects the row, 1 indicates column 1
                cardA = imdata{1};
                cardB = imdata{2};
            elseif stim(trial, 1) == 2
                cardA = imdata{3};
                cardB = imdata{4};
            elseif stim(trial, 1) == 3
                cardA = imdata{5};
                cardB = imdata{6};           
            end
            
            figureA = Screen('MakeTexture', w, cardA);%make into picture
            figureB = Screen('MakeTexture', w, cardB);
            redRing=MaskImageIn(redRing);
            ring = Screen('MakeTexture', w, redRing);
            
            if stim(trial,4) == 1 %decide which stim is left/right
                coordinateA = leftLocation;
                coordinateB = rightLocation;
            elseif stim(trial,4) == 2
                coordinateB = leftLocation;
                coordinateA = rightLocation;    
            end            
            
            DrawFormattedText(w, '+', 'center', 'center', [255 0 0], 40);
            Screen('Flip', w);%show fix cross
            WaitSecs(isi);          %wait
            DrawFormattedText(w, '+', 'center', 'center', [255 0 0], 40); 
            Screen('DrawTextures', w, figureA, [], coordinateA);%picture            
            Screen('DrawTextures', w, figureB, [], coordinateB);%picture 
            DrawFormattedText(w, trialMessage1, leftText, height, white, [], [], [], 10);
            DrawFormattedText(w, trialMessage2, rightText, height, white, [], [], [], 10);
            
            [~, startRT]=Screen('Flip', w,[], 1);%show stim
            [endrt, key] = KbPressWait;   %get response
            learnRT(k,1) = round(1000*(endrt-startRT));     % get response time  
            learnResp(k,1) = find(key) - 48;%get which key it was
            
            if learnResp(k,1) == 1;%draw ring around selected stim
                Screen('DrawTexture', w, ring, [], leftLocation);
                outcomeColumn = 2;  % set which outcome column to use based on response. If left, outcome for left card 
            elseif learnResp(k,1) == 5;
                Screen('DrawTexture', w, ring, [], rightLocation);
                outcomeColumn = 3; 
            end
            Screen('Flip', w); 
            WaitSecs(isi);

            if stim(trial, outcomeColumn) == 2%find which feedback to show
                outcomeColour = white;
                outcomeMessage = 'NOTHING';   
            else
                if stim(trial, outcomeColumn) == 1          
                % gain
                outcomeColour = [0 204 0];
                outcomeMessage = 'GAIN';
                elseif stim(trial, outcomeColumn) == 3
                % look
                outcomeColour = white;
                outcomeMessage = 'LOOK';
                elseif stim(trial, outcomeColumn) == 4
                % loss
                outcomeColour = [255 0 0];
                outcomeMessage = 'LOSS';
                end
                
                coin = Screen('MakeTexture', w, twentyP);
                Screen('DrawTextures', w, coin);                              
            end
            Screen('TextSize', w, 48);
            DrawFormattedText(w, outcomeMessage, 'center', topText, outcomeColour);
            Screen('Flip', w);
            WaitSecs(1);            

        end % end trial
        Screen('TextSize', w, 36); 
        DrawFormattedText(w, endMessage, 'center', 'center', white, 40);%display end text
        Screen('Flip', w);     
        WaitSecs(2);     
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
        % End of experiment:
        close all;  
        beep on; 
        beep;
        return;
        
        
    catch
        Screen('CloseAll');
        ShowCursor;
        fclose('all');
        Priority(0);
        psychrethrow(psychlasterror);  
        save(sprintf('PPID%dSess%d.catch.mat',ppID,sesNo))
        
    end
    close all;%closes figures
    RestrictKeysForKbCheck([]);
    beep on; 
    beep;
end