
pacedByUser = true;

waitForAWhile = 0;

% build the speaker arrays for each direction
speakerIdxRightward = generateMotionSpeakerArray('rightward')

speakerIdxLeftward = generateMotionSpeakerArray('leftward')

speakerIdxDownward = generateMotionSpeakerArray('downward')

speakerIdxUpward = generateMotionSpeakerArray('upward')

%% 1.2

% loadAudio

soundPath = '/Users/barilari/Desktop/technologic.wav';

[outSound, fs] = audioread(soundPath);

% cutAudio

[soundArray] = cutSoundArray(outSound, 'pinknoise', fs, nbSpeakers, 0);


for i = 1:5

pressSpaceForMeOrWait(pacedByUser, waitForAWhile)

playMotionSound('horizontal', ...
                speakerIdxRightward, ...
                soundArray, ...
                1);

playMotionSound('horizontal', ...
                speakerIdxLeftward, ...
                soundArray, ...
                1);

playMotionSound('vertical', ...
                speakerIdxDownward, ...
                soundArray, ...
                1);

playMotionSound('vertical', ...
                speakerIdxUpward, ...
                soundArray, ...
                1);

end


%% 0.6

%% 1.7

%% 0.85
