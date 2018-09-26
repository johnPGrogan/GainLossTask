# GainLossTask
Matlab code for running the GainLoss task

This repo contains the MATLAB code to run the GainLoss experiment, created by John Grogan and Hanna Isotalus, based on the task reported in:
	Pessiglione, M., Seymour, B., Flandin, G.,  Dolan, R.J., & Frith, C.D. (2006). Dopamine-dependent prediction errors  underpin reward-seeking behaviour in humans. Nature, 442, (7106),  pp1042-1045.

This was run on MATLAB r2015, with PsychToolbox-3.

There are 3 phases to the task: practice, learning, and choice test.

In the learning trials, 3 pairs of stimuli are presented in a random order. Participants select one stimulus using the keyboard and receive feedback, which is determined probabilistically:
	In pair AB, stimulus A receives 'Gain 20p' on 80% of trials and 'Nothing' on 20%. Vice versa for stimulus B.
	In pair CD, stimulus C receives 'Look 20p' (no monetary value) on 80% of trials, and 'Nothing' on 20%. Vice versa for stimulus D.
	In pair EF, stimulus E receives 'Lose 20p' on 80% of trials and 'Nothing' on 20%. Vice versa for stimulus F.

There are 2 blocks of 90 trials, with a break in between. A .txt file is updated after each trial, and a .mat file is created at the end of the task.


The practice phase is the same as the learning phase, but with only 30 trials, using different stimuli. No output files are created.


The test phase shows all combinations of pairs of stimuli (e.g. AB, AC, AD,...) 6 times each (90 trials in total, 15 combinations). Participants select one stimulus and DO NOT receive feedback. A .txt file is updated after each trial, and a .mat file is created at the end of the task.


There are 4 sets of stimuli that can be used (chosen by the versNo argument to the scripts). These are stored in the \Stimuli\ folder, along with a redRing.png to show which stimulus is selected, and a 20p.bmp to use in the outcome screens.

Below is a list of all files in this repo:

Folder PATH listing for volume Windows
C:.

|   GLLearn.m
|   GLLearn.txt
|   GLPractice.m
|   GLTest.m
|   GLTest.txt
|   README.md
|   
\---Stimuli
    |   20p.bmp
    |   redRing.png
    |   
    +---Practice
    |       1.bmp
    |       2.bmp
    |       3.bmp
    |       4.bmp
    |       5.bmp
    |       6.bmp
    |       
    +---Version1
    |       1.bmp
    |       2.bmp
    |       3.bmp
    |       4.bmp
    |       5.bmp
    |       6.bmp
    |       
    +---Version2
    |       1.bmp
    |       2.bmp
    |       3.bmp
    |       4.bmp
    |       5.bmp
    |       6.bmp
    |       
    +---Version3
    |       1.bmp
    |       2.bmp
    |       3.bmp
    |       4.bmp
    |       5.bmp
    |       6.bmp
    |       
    \---Version4
            1.bmp
            2.bmp
            3.bmp
            4.bmp
            5.bmp
            6.bmp
            
