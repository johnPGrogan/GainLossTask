function GLTest(ppID,sesNo, versNo, letter)
% GLTest(ppID,sesNo, versNo, letter)
% The GainLoss task novel pairs test. Requires PsychToolbox package.
% inputs:   ppID = ID number e.g. 101
%           sesNo = session number e.g. 1 or 2
%           versNo = which version of stimuli to use: 1, 2, 3, or 4
%           letter = character: A=0min test, B=30min, C=24hr
% 
% Written by John Grogan and Hanna Isotalus
% Based on the task reported in Pessiglione, M., Seymour, B., Flandin, G.,
% Dolan, R.J., & Frith, C.D. (2006). Dopamine-dependent prediction errors 
% underpin reward-seeking behaviour in humans. Nature, 442, (7106), 
% pp1042-1045.

rng('shuffle')%set random number generator seed to time/date
stim = importdata(sprintf('GLTest.txt')); %%d.txt',VersNo)); 
% 1st column is image pair (e.g. 12 or 22), second column is first card of
% image pair (e.g. 1 or 2), third column is second card of image pair (e.g.
% 2). 4th column is left or right. 5th column is zeros and will be
% overwritten

stim(:,5) = randperm(length(stim))'; % creates stimulus presentation order on 5th column
stimOrderTest = stim(:,5);%store here also
Screen('Preference', 'SkipSyncTests', 1);
totalTrials = length(stim);%number of trials

%% instructions
instructions{1} = 'In each trial you have to choose between the two  \n   symbols displayed on the screen, to either side of the central cross.  \n \n Your choice will be circled in red. \n \n  - to choose left, press 1 \n \n  - to choose right, press  5 \n \n \n Please press key 3 to continue';
instructions{2} = 'You get the same outcomes as one the previous test \n \n \n  -get nothing \n \n  -gain a coin \n  \n  -lose a coin \n \n  but this time will not be shown feedback \n \n (i.e. you will still be winning and losing money, we just won''t be telling you when you do) \n \n \n Please press key 3 to continue';
instructions{3} = 'The two symbols displayed on the same screen are not equivalent in terms of outcome:\n  \n  with one you are more likely to get nothing than the other. \n  \n  Each symbol has its own meaning, regardless of where and when it is displayed. \n \n  The aim of the game is to win as much money as possible.\n \n  \n  Please press key 3 to continue';
endMessage = 'You have now finished. \n \n \n Thank you. ';
trialMessage1 = '1';
trialMessage2 = '5';
   
%% define key 
KbName('UnifyKeyNames'); %otherwise different key codes on my laptop
oneResp = 49;% left key
threeResp = 51;% middle key
fiveResp = 53;% right key
    
%% For saving data
testResp = zeros(totalTrials, 1);%preallocate these
testRT = zeros(totalTrials, 1);
cardChosenTest = zeros(totalTrials, 1);
cardNotChosenTest = zeros(totalTrials, 1);

isi = 0.5;% inter stimulus interval
datafilename = strcat('GLTest',letter,'_ppID',num2str(ppID),'sesNo',num2str(sesNo),'versNo',num2str(versNo), '.txt'); % name of data file to write to
datafilepointer = fopen(datafilename,'wt');

%% get ready
    try    
        %% set up stuff
        screens=Screen('Screens');% Get screenNumber of stimulation display. 
        screenNumber=max(screens);% set the display screen
        HideCursor; % Hide the mouse cursor:
        black = BlackIndex(screenNumber); 
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
            KbPressWait;%wait for button press, key 3
            WaitSecs(0.001);  
        end % end for instructions
         
        %% Run experiment
 
        %% fixation cross before trial loop starts 
        DrawFormattedText(w, '+', 'center', 'center', [255 0 0], 40);        
        Screen('Flip', w);% Update the display to show the instruction text:
        WaitSecs(isi)            
        
        %% load images
        RestrictKeysForKbCheck([oneResp,fiveResp]);%only 1 and 5           
        for p = 1:6
            stimfilename = sprintf('\\GainLoss\\Stimuli\\Version%.1d\\%.1d.bmp', versNo, p); 
            imdata{p} = imread(char(stimfilename)); % stores in a cell and works nicely. Remember to use {} when call, not ()
        end       
        stimfilenameredRing = sprintf('\\GainLoss\\Stimuli\\redRing.png'); 
        redRing = imread(char(stimfilenameredRing));           
        %% loop through trials
        for k = 1:totalTrials  
            %% set trial up
            Screen('TextSize', w, 36);
            trial = stimOrderTest(k,1);% get trial number
            for n= 1:6%get images for stimuli
                if stim(trial, 2) == n % trial selects the row, 1 indicates column 1
                   cardA = imdata{n};
                end
                if stim(trial, 3)==n
                   cardB = imdata{n};
                end
            end
            
            figureA = Screen('MakeTexture', w, cardA);%make into pictures
            figureB = Screen('MakeTexture', w, cardB);
            redRing=MaskImageIn(redRing);
            ring = Screen('MakeTexture', w, redRing);
            
            if stim(trial,4) == 1 %decide left or right
                coordinateA = leftLocation;
                coordinateB = rightLocation;
            elseif stim(trial,4) == 2
                coordinateB = leftLocation;
                coordinateA = rightLocation;    
            end            
            
            DrawFormattedText(w, '+', 'center', 'center', [255 0 0], 40);
            Screen('Flip', w);
            WaitSecs(isi);%draw fix cross
          
            DrawFormattedText(w, '+', 'center', 'center', [255 0 0], 40);           
            Screen('DrawTextures', w, figureA, [], coordinateA);%picture            
            Screen('DrawTextures', w, figureB, [], coordinateB);%picture 
            DrawFormattedText(w, trialMessage1, leftText, height, white, [], [], [], 10);
            DrawFormattedText(w, trialMessage2, rightText, height, white, [], [], [], 10);
            
            [~, startRT]=Screen('Flip', w,[], 1);%show stim
            [endrt, key] = KbPressWait;   %get response
            testRT(k,1) = round(1000*(endrt-startRT));     % get response time  
            testResp(k,1) = find(key) - 48;%turn into 1 or 5

            %% set ring and get response card
            if testResp(k,1) == 1 % left was selected
                Screen('DrawTexture', w, ring, [], leftLocation);
                if stim(trial,4) == 1 % card A on left
                    cardChosenTest(k,1) = stim(trial, 2);
                    cardNotChosenTest(k,1) = stim(trial, 3);
                elseif stim(trial,4) == 2 % card B on left
                    cardChosenTest(k,1) = stim(trial, 3);
                    cardNotChosenTest(k,1) = stim(trial, 2);
                end
                
            elseif testResp(k,1) == 5 % right was selected
                Screen('DrawTexture', w, ring, [], rightLocation);
                if stim(trial,4) == 1 % card A on left
                    cardChosenTest(k,1) = stim(trial, 3);
                    cardNotChosenTest(k,1) = stim(trial, 2);
                elseif stim(trial,4) == 2 % card B on left
                    cardChosenTest(k,1) = stim(trial, 2);
                    cardNotChosenTest(k,1) = stim(trial, 3);
                end 
            end
            Screen('Flip', w);
            WaitSecs(isi);
            
            %blank screen
            Screen('Flip', w);
            WaitSecs(0.3);            

           % Write trial result to file 
            fprintf(datafilepointer,'%i\t%i\t%i\t%i\t%i\n', ...
                    stimOrderTest(k,1),...
                    cardChosenTest(k,1), ...
                    cardNotChosenTest(k,1),...
                    testResp(k,1), ...
                    testRT(k,1));     % i don't really know what's useful to save
        
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
        save(strcat(sprintf('GLTest%cPPID%dSess%dVersNo%d',letter,ppID, sesNo, versNo),'.',datestr(now, 'ddmmyyyy.HHMMSS'),'.mat'),'stimOrderTest','cardChosenTest','cardNotChosenTest', 'testResp', 'testRT');        
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
        save(strcat(sprintf('GLTest%cPPID%dSess%dVersNo%d',letter,ppID, sesNo, versNo),'.',datestr(now, 'ddmmyyyy.HHMMSS'),'.mat'),'stimOrderTest','cardChosenTest','cardNotChosenTest', 'testResp', 'testRT');        
        
    end
    close all;%closes figures
    RestrictKeysForKbCheck([]);
    beep on; 
    beep;
end