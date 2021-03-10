% (C) Copyright 2021 CPP LePoulpe developers

% this is the main script to present auditory or visual motion in LePoulpe
% it calls generate sounds (white, pink, brown noise) in a given length and
% cuts the sound array into chunks to play each chunk in a speaker. 

% for visual motion it activates LEDs in a given speed, plane (horizontal,
% vertical), and plays them in a given number of repetitions

% if the suer control is needed, please provide that. Otherwise it loops
% through the repetitions with 5s wait time. 


fs = 44100;
saveAsWav = 1;
duration = 1.2;

% outSound = generateNoise('white', duration, saveAsWav, fs);
outSound = generateNoise('pink', duration, saveAsWav, fs);


% [soundArray] = cutSoundArray(inputSound, fs, nbSpeakers, saveAsWav);
[soundArray] = cutSoundArray(outSound, fs, 31, 0);


playMotion(plane, arraySpeakers, soundArray, nbRepetition);