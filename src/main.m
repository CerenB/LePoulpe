% (C) Copyright 2021 CPP LePoulpe developers

% this is the main script to present auditory or visual motion in LePoulpe
% it calls generate sounds (white, pink, brown noise) in a given length and
% cuts the sound array into chunks to play each chunk in a speaker.

% for visual motion it activates LEDs in a given speed, plane (horizontal,
% vertical), and plays them in a given number of repetitions

% if the suer control is needed, please provide that. Otherwise it loops

% through the repetitions with 5s wait time.

pacedByUser = true;

waitForAWhile = 0;


%% prepare sounds to be played
fs = 44100;
saveAsWav = 1;
duration = 0.5;

% outSound = generateNoise('white', duration, saveAsWav, fs);
outSound = generateNoise('pink', duration, saveAsWav, fs);


nbSpeakers = 31;
saveAsWav = 1;

% [soundArray] = cutSoundArray(inputSound, inputName, fs, nbSpeakers, saveAsWav);
[soundArray] = cutSoundArray(outSound, 'pinknoise', fs, nbSpeakers, saveAsWav);


% build the speaker arrays for each direction
speakerIdxRightward = generateMotionSpeakerArray('rightward');

speakerIdxLeftward = generateMotionSpeakerArray('leftward');

speakerIdxDownward = generateMotionSpeakerArray('downward');

speakerIdxUpward = generateMotionSpeakerArray('upward');

%% play sounds (auditory motion)
nbRepetition = 2;

waitForSwtich = 1;

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)
playMotionSound('horizontal', ...
                speakerIdxRightward, ...
                soundArray, ...
                nbRepetition, ...
                waitForSwtich);

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)
playMotionSound('horizontal', ...
                speakerIdxLeftward, ...
                soundArray, ...
                nbRepetition, ...
                waitForSwtich);

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)
playMotionSound('vertical', ...
                speakerIdxDownward, ...
                soundArray, ...
                nbRepetition, ...
                waitForSwtich);

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)
playMotionSound('vertical', ...
                speakerIdxUpward, ...
                soundArray, ...
                nbRepetition, ...
                waitForSwtich);

 %% play LEDs (visual motion)
nbRepetition = 3;
pressSpaceForMeOrWait(pacedByUser, waitForAWhile)
playVisualMotion('rightward', ...
                 0.0170, ...
                 2, ...
                 nbRepetition);


pressSpaceForMeOrWait(pacedByUser, waitForAWhile)
playVisualMotion('leftward', ...
                 0.0170, ...
                 2, ...
                 nbRepetition)


pressSpaceForMeOrWait(pacedByUser, waitForAWhile)
playVisualMotion('downward', ...
                 0.0170, ...
                 1, ...
                 nbRepetition)


pressSpaceForMeOrWait(pacedByUser, waitForAWhile)
playVisualMotion('upward', ...
                 0.0170, ...
                 1, ...
                 nbRepetition)
