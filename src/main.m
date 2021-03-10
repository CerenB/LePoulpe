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


fs = 44100;
saveAsWav = 1;
duration = 5.2;

% outSound = generateNoise('white', duration, saveAsWav, fs);
outSound = generateNoise('pink', duration, saveAsWav, fs);


nbSpeakers = 31;
saveAsWav = 0;
% [soundArray] = cutSoundArray(inputSound, inputName, fs, nbSpeakers, saveAsWav);
[soundArray] = cutSoundArray(outSound, 'pinknoise', fs, nbSpeakers, 0);


%playMotion(plane, arraySpeakers, soundArray, nbRepetition);


pressSpaceForMeOrWait(pacedByUser, waitForAWhile)


playMotionVisual('rightward', ...
                 0.0170, ...
                 2, ...
                 1);


pressSpaceForMeOrWait(pacedByUser, waitForAWhile)


playMotionVisual('leftward', ...
                 0.0170, ...
                 2, ...
                 1)


pressSpaceForMeOrWait(pacedByUser, waitForAWhile)


playMotionVisual('downward', ...
                 0.0170, ...
                 1, ...
                 1)


pressSpaceForMeOrWait(pacedByUser, waitForAWhile)


playMotionVisual('upward', ...
                 0.0170, ...
                 1, ...
                 1)




